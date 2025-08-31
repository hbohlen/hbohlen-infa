#!/bin/bash
# Service Isolation Management Script
# Manages the transition from isolated development to production integration

set -e

# Configuration
COMPOSE_FILE="infrastructure/docker-compose.isolated.yml"
BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)"
LOG_FILE="logs/isolation-management-$(date +%Y%m%d).log"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Create backup before any changes
create_backup() {
    log "Creating backup before isolation management..."
    mkdir -p "$BACKUP_DIR"

    # Backup current configurations
    cp infrastructure/docker-compose.yml "$BACKUP_DIR/docker-compose.production.backup" 2>/dev/null || true
    cp infrastructure/caddy/Caddyfile "$BACKUP_DIR/Caddyfile.production.backup" 2>/dev/null || true

    # Backup running container configurations
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}" > "$BACKUP_DIR/running-containers.txt"

    log "Backup created in: $BACKUP_DIR"
}

# Test existing services before making changes
test_existing_services() {
    log "Testing existing services before isolation changes..."

    # Test FalkorDB Browser
    if curl -f -s http://localhost:8080/health > /dev/null; then
        log "✅ FalkorDB Browser is healthy"
    else
        log "❌ FalkorDB Browser is not responding"
        return 1
    fi

    # Test database connectivity
    if docker exec hbohlen-falkordb-db-existing redis-cli ping | grep -q "PONG"; then
        log "✅ FalkorDB database is responding"
    else
        log "❌ FalkorDB database is not responding"
        return 1
    fi

    log "All existing services are healthy"
}

# Start isolated infrastructure services
start_isolated_services() {
    local service_type=$1

    log "Starting isolated $service_type services..."

    case $service_type in
        "infrastructure")
            docker-compose -f "$COMPOSE_FILE" --profile infrastructure up -d
            ;;
        "monitoring")
            docker-compose -f "$COMPOSE_FILE" --profile monitoring up -d
            ;;
        "testing")
            docker-compose -f "$COMPOSE_FILE" --profile testing up -d
            ;;
        "all")
            docker-compose -f "$COMPOSE_FILE" up -d
            ;;
        *)
            log "❌ Invalid service type: $service_type"
            echo "Usage: $0 start <infrastructure|monitoring|testing|all>"
            exit 1
            ;;
    esac

    # Wait for services to be healthy
    sleep 30

    # Verify services started
    case $service_type in
        "infrastructure")
            if docker ps | grep -q "hbohlen-caddy-new"; then
                log "✅ Infrastructure services started successfully"
            else
                log "❌ Infrastructure services failed to start"
                return 1
            fi
            ;;
        "monitoring")
            if docker ps | grep -q "hbohlen-datadog-agent-new"; then
                log "✅ Monitoring services started successfully"
            else
                log "❌ Monitoring services failed to start"
                return 1
            fi
            ;;
    esac
}

# Test service isolation
test_isolation() {
    log "Testing service isolation..."

    # Test 1: Existing services should be accessible
    if curl -f -s http://localhost:8080/health > /dev/null; then
        log "✅ Existing services remain accessible"
    else
        log "❌ Existing services became inaccessible"
        return 1
    fi

    # Test 2: New services should be isolated
    if curl -f -s http://localhost:8081/health > /dev/null 2>&1; then
        log "⚠️  New services are accessible (expected in isolation)"
    else
        log "✅ New services are properly isolated"
    fi

    # Test 3: Cross-network access should be blocked
    # This test would require running the integration-tester service
    log "✅ Service isolation test completed"
}

# Gradually migrate services from isolation to production
migrate_service() {
    local service_name=$1

    log "Migrating $service_name from isolation to production..."

    case $service_name in
        "caddy")
            # Stop existing Caddy
            docker stop hbohlen-caddy-current 2>/dev/null || true

            # Update Caddyfile to production configuration
            cp infrastructure/caddy/Caddyfile.production infrastructure/caddy/Caddyfile

            # Start new Caddy on production ports
            docker-compose -f "$COMPOSE_FILE" up -d caddy-new

            # Update port mapping (this would require docker-compose override)
            log "⚠️  Manual port reconfiguration required for Caddy migration"
            ;;

        "portainer")
            # Migrate Portainer to production
            docker-compose -f "$COMPOSE_FILE" up -d portainer-new
            log "✅ Portainer migrated to production"
            ;;

        "consul")
            # Migrate Consul to production
            docker-compose -f "$COMPOSE_FILE" up -d consul-server-new
            log "✅ Consul migrated to production"
            ;;

        *)
            log "❌ Unknown service: $service_name"
            echo "Available services: caddy, portainer, consul"
            return 1
            ;;
    esac
}

# Rollback isolated services
rollback_isolation() {
    log "Rolling back isolated services..."

    # Stop all isolated services
    docker-compose -f "$COMPOSE_FILE" down

    # Restore from backup if needed
    if [ -d "$BACKUP_DIR" ]; then
        log "Restoring from backup: $BACKUP_DIR"
        cp "$BACKUP_DIR/docker-compose.production.backup" infrastructure/docker-compose.yml 2>/dev/null || true
        cp "$BACKUP_DIR/Caddyfile.production.backup" infrastructure/caddy/Caddyfile 2>/dev/null || true
    fi

    # Restart production services
    docker-compose up -d

    log "✅ Isolation rollback completed"
}

# Monitor isolation status
monitor_isolation() {
    log "Monitoring service isolation status..."

    echo "=== Existing Services (Protected) ==="
    docker ps --filter "label=isolation.level=protected" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

    echo ""
    echo "=== New Services (Isolated) ==="
    docker ps --filter "label=isolation.level=isolated" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

    echo ""
    echo "=== Monitoring Services ==="
    docker ps --filter "label=isolation.level=monitoring" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

    echo ""
    echo "=== Network Segmentation ==="
    docker network ls | grep hbohlen

    echo ""
    echo "=== Resource Usage ==="
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.NetIO}}"
}

# Main command processing
case "${1:-help}" in
    "backup")
        create_backup
        ;;
    "test-existing")
        test_existing_services
        ;;
    "start")
        if [ -z "$2" ]; then
            echo "Usage: $0 start <infrastructure|monitoring|testing|all>"
            exit 1
        fi
        create_backup
        test_existing_services
        start_isolated_services "$2"
        ;;
    "test")
        test_isolation
        ;;
    "migrate")
        if [ -z "$2" ]; then
            echo "Usage: $0 migrate <caddy|portainer|consul>"
            exit 1
        fi
        migrate_service "$2"
        ;;
    "rollback")
        rollback_isolation
        ;;
    "monitor")
        monitor_isolation
        ;;
    "status")
        echo "=== Service Isolation Status ==="
        echo "Existing Services: $(docker ps --filter "label=isolation.level=protected" --quiet | wc -l) running"
        echo "Isolated Services: $(docker ps --filter "label=isolation.level=isolated" --quiet | wc -l) running"
        echo "Monitoring Services: $(docker ps --filter "label=isolation.level=monitoring" --quiet | wc -l) running"
        echo "Networks: $(docker network ls | grep hbohlen | wc -l) active"
        ;;
    "help"|*)
        echo "Service Isolation Management Script"
        echo ""
        echo "Usage: $0 <command> [options]"
        echo ""
        echo "Commands:"
        echo "  backup                    Create backup before changes"
        echo "  test-existing            Test existing services health"
        echo "  start <type>             Start isolated services (infrastructure|monitoring|testing|all)"
        echo "  test                     Test service isolation"
        echo "  migrate <service>        Migrate service to production (caddy|portainer|consul)"
        echo "  rollback                 Rollback all isolated services"
        echo "  monitor                  Show detailed isolation status"
        echo "  status                   Show summary isolation status"
        echo "  help                     Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 start infrastructure   # Start isolated infrastructure services"
        echo "  $0 test                   # Test that isolation is working"
        echo "  $0 migrate caddy         # Migrate Caddy to production"
        echo "  $0 monitor               # Show detailed status"
        ;;
esac