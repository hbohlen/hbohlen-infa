# Rollback Procedures for hbohlen.io Personal Cloud

## Overview

This document provides detailed rollback procedures for each epic in the hbohlen.io Personal Cloud project. Each procedure includes:

- **Trigger Conditions:** When to initiate rollback
- **Recovery Time Objective (RTO):** Target time for service restoration
- **Recovery Point Objective (RPO):** Maximum acceptable data loss
- **Automated Scripts:** Command sequences for quick execution
- **Manual Procedures:** Step-by-step fallback instructions
- **Validation Steps:** How to confirm successful rollback

## Epic 1: Secure Network Foundation (Tailscale)

### Trigger Conditions
- Tailscale connectivity failures affecting >50% of nodes
- SSH access lost to critical infrastructure nodes
- Network latency >500ms consistently
- Tailscale daemon crashes preventing service communication

### Recovery Objectives
- **RTO:** 10 minutes
- **RPO:** No data loss (network configuration only)

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic1.sh - Tailscale Network Rollback

echo "=== Epic 1 Rollback: Tailscale Network ==="

# Stop Tailscale daemon
sudo systemctl stop tailscaled

# Remove current Tailscale configuration
sudo tailscale down
sudo rm -f /var/lib/tailscale/tailscaled.state

# Restore previous network configuration
sudo cp /etc/netplan/backup/01-netcfg.yaml /etc/netplan/01-netcfg.yaml
sudo netplan apply

# Restart networking
sudo systemctl restart networking

# Verify connectivity
ping -c 3 8.8.8.8
echo "Network rollback complete. Verify service access manually."
```

### Manual Procedures
1. **Stop Tailscale Service:**
   ```bash
   sudo systemctl stop tailscaled
   sudo tailscale down
   ```

2. **Restore Network Configuration:**
   ```bash
   sudo cp /etc/netplan/backup/01-netcfg.yaml /etc/netplan/01-netcfg.yaml
   sudo netplan apply
   ```

3. **Restart Networking:**
   ```bash
   sudo systemctl restart networking
   ```

4. **Verify Connectivity:**
   ```bash
   ping -c 3 8.8.8.8
   ssh user@hetzner-ip  # Test SSH access
   ```

### Validation Steps
- [ ] Internet connectivity restored
- [ ] SSH access to all VPS nodes working
- [ ] Existing services accessible via direct IPs
- [ ] No Tailscale-related errors in system logs

## Epic 2: Professional Service Access (Caddy)

### Trigger Conditions
- SSL certificate failures preventing HTTPS access
- Domain routing failures (>50% of requests failing)
- Caddy daemon crashes or configuration errors
- Performance degradation >200ms response time

### Recovery Objectives
- **RTO:** 5 minutes
- **RPO:** No data loss (configuration only)

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic2.sh - Caddy Service Access Rollback

echo "=== Epic 2 Rollback: Caddy Reverse Proxy ==="

# Stop current Caddy
docker stop hbohlen-caddy || true
docker rm hbohlen-caddy || true

# Restore previous Caddyfile
cp /opt/caddy/backup/Caddyfile.previous /opt/caddy/Caddyfile

# Start Caddy with previous configuration
docker run -d \
  --name hbohlen-caddy \
  --restart unless-stopped \
  -p 80:80 -p 443:443 \
  -v /opt/caddy/Caddyfile:/etc/caddy/Caddyfile \
  -v /opt/caddy/data:/data \
  caddy:latest

# Wait for startup
sleep 10

# Verify service access
curl -I https://falkordb.hbohlen.io
echo "Caddy rollback complete."
```

### Manual Procedures
1. **Stop Current Caddy:**
   ```bash
   docker stop hbohlen-caddy
   docker rm hbohlen-caddy
   ```

2. **Restore Configuration:**
   ```bash
   cp /opt/caddy/backup/Caddyfile.previous /opt/caddy/Caddyfile
   ```

3. **Start Caddy Manually:**
   ```bash
   docker run -d \
     --name hbohlen-caddy \
     --restart unless-stopped \
     -p 80:80 -p 443:443 \
     -v /opt/caddy/Caddyfile:/etc/caddy/Caddyfile \
     -v caddy_data:/data \
     caddy:latest
   ```

4. **Verify SSL and Routing:**
   ```bash
   curl -I https://falkordb.hbohlen.io
   curl -I https://test.hbohlen.io
   ```

### Validation Steps
- [ ] HTTPS access working for all domains
- [ ] SSL certificates valid (check with SSL Labs)
- [ ] Existing FalkorDB Browser accessible
- [ ] Response time <500ms
- [ ] No Caddy-related errors in logs

## Epic 3: Automated Service Deployment (GitOps)

### Trigger Conditions
- GitHub Actions deployment failures
- Service deployment breaking existing functionality
- Docker image build failures
- Configuration deployment errors

### Recovery Objectives
- **RTO:** 15 minutes
- **RPO:** Last known good deployment state

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic3.sh - GitOps Deployment Rollback

echo "=== Epic 3 Rollback: GitOps Deployment ==="

# Get last successful deployment tag
LAST_GOOD_TAG=$(git tag --sort=-version:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -1)

if [ -z "$LAST_GOOD_TAG" ]; then
    echo "No previous version tag found, using main branch"
    LAST_GOOD_TAG="main"
fi

echo "Rolling back to: $LAST_GOOD_TAG"

# Checkout previous version
git checkout $LAST_GOOD_TAG

# Redeploy with previous configuration
docker-compose -f infrastructure/docker-compose.yml down
docker-compose -f infrastructure/docker-compose.yml up -d

# Verify deployment
docker-compose ps
echo "GitOps rollback to $LAST_GOOD_TAG complete."
```

### Manual Procedures
1. **Identify Last Good State:**
   ```bash
   git log --oneline -10  # Find last successful commit
   git tag --list  # Check for version tags
   ```

2. **Checkout Previous Version:**
   ```bash
   git checkout <last-good-commit-or-tag>
   ```

3. **Manual Redeploy:**
   ```bash
   docker-compose -f infrastructure/docker-compose.yml down
   docker-compose -f infrastructure/docker-compose.yml up -d
   ```

4. **Verify Services:**
   ```bash
   docker-compose ps
   curl http://localhost:8080/health  # FalkorDB
   ```

### Validation Steps
- [ ] All services running (docker-compose ps)
- [ ] Existing FalkorDB Browser functional
- [ ] GitHub Actions status shows successful deployment
- [ ] No deployment-related errors in logs

## Epic 4: Multi-Node Container Orchestration (Portainer)

### Trigger Conditions
- Portainer web interface inaccessible
- Container management failures
- Multi-node orchestration issues
- Resource allocation problems

### Recovery Objectives
- **RTO:** 10 minutes
- **RPO:** No data loss (container configurations preserved)

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic4.sh - Portainer Orchestration Rollback

echo "=== Epic 4 Rollback: Portainer Orchestration ==="

# Stop Portainer
docker stop portainer
docker rm portainer

# Restore previous Docker Compose setup
cp infrastructure/docker-compose.backup.yml infrastructure/docker-compose.yml

# Start services without Portainer orchestration
docker-compose -f infrastructure/docker-compose.yml up -d

# Verify service access
curl http://localhost:8080/health
echo "Portainer rollback complete. Using direct Docker Compose management."
```

### Manual Procedures
1. **Stop Portainer:**
   ```bash
   docker stop portainer
   docker rm portainer
   ```

2. **Restore Direct Management:**
   ```bash
   cp infrastructure/docker-compose.backup.yml infrastructure/docker-compose.yml
   docker-compose up -d
   ```

3. **Verify Container Status:**
   ```bash
   docker ps
   docker stats  # Check resource usage
   ```

4. **Test Service Access:**
   ```bash
   curl http://localhost:8080/health
   ```

### Validation Steps
- [ ] All containers running (docker ps)
- [ ] Services accessible via direct ports
- [ ] Resource usage within normal limits
- [ ] No Portainer-related errors

## Epic 5: Service Discovery & Health Management (Consul)

### Trigger Conditions
- Consul cluster failures
- Service discovery registration issues
- Health check failures causing service outages
- DNS resolution problems

### Recovery Objectives
- **RTO:** 20 minutes
- **RPO:** No data loss (service configurations preserved)

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic5.sh - Consul Service Discovery Rollback

echo "=== Epic 5 Rollback: Consul Service Discovery ==="

# Stop Consul agents
docker stop consul-server consul-agent-hetzner consul-agent-do
docker rm consul-server consul-agent-hetzner consul-agent-do

# Restore direct service access configuration
cp infrastructure/docker-compose.consul-backup.yml infrastructure/docker-compose.yml

# Update Caddy configuration for direct routing
cp infrastructure/caddy/Caddyfile.no-consul infrastructure/caddy/Caddyfile

# Restart services
docker-compose up -d

# Verify service access
curl http://localhost:8080/health
echo "Consul rollback complete. Using direct service routing."
```

### Manual Procedures
1. **Stop Consul Services:**
   ```bash
   docker stop consul-server consul-agent-hetzner consul-agent-do
   docker rm consul-server consul-agent-hetzner consul-agent-do
   ```

2. **Restore Direct Configuration:**
   ```bash
   cp infrastructure/docker-compose.consul-backup.yml infrastructure/docker-compose.yml
   cp infrastructure/caddy/Caddyfile.no-consul infrastructure/caddy/Caddyfile
   ```

3. **Restart Services:**
   ```bash
   docker-compose up -d
   ```

4. **Update DNS/Local Resolution:**
   ```bash
   # Add direct IP mappings if needed
   echo "127.0.0.1 falkordb.local" >> /etc/hosts
   ```

### Validation Steps
- [ ] Services accessible via direct IPs/ports
- [ ] Caddy routing working without Consul
- [ ] No service discovery errors
- [ ] Health checks functional via direct methods

## Emergency Full System Rollback

### Trigger Conditions
- Multiple epic failures
- Complete system instability
- Data corruption concerns
- Extended downtime (>1 hour)

### Recovery Objectives
- **RTO:** 30 minutes
- **RPO:** Last daily backup

### Emergency Rollback Script
```bash
#!/bin/bash
# emergency-rollback.sh - Full System Rollback

echo "=== EMERGENCY: Full System Rollback ==="

# Stop all services
docker-compose down

# Restore from backup
BACKUP_DIR="/opt/hbohlen/backup/$(date +%Y%m%d)"
if [ -d "$BACKUP_DIR" ]; then
    cp -r $BACKUP_DIR/* /opt/hbohlen/
    echo "Backup restored from $BACKUP_DIR"
else
    echo "No recent backup found, using git fallback"
    git checkout main
    git reset --hard HEAD~10  # Go back 10 commits
fi

# Start minimal services
docker-compose -f infrastructure/docker-compose.minimal.yml up -d

# Verify basic functionality
curl http://localhost:8080/health
echo "Emergency rollback complete. Assess system stability before proceeding."
```

## Rollback Testing Procedures

### Pre-Deployment Testing
1. **Test Rollback Scripts:**
   ```bash
   # Test in staging environment
   ./rollback-epic1.sh --dry-run
   ./rollback-epic2.sh --dry-run
   ```

2. **Validate Recovery Objectives:**
   - Time rollback execution
   - Verify data integrity
   - Test service functionality

3. **Document Test Results:**
   - Actual RTO vs target
   - Any issues encountered
   - Lessons learned

### Post-Rollback Validation
1. **Service Health Checks:**
   ```bash
   # Check all critical services
   curl -f http://localhost:8080/health || echo "FalkorDB health check failed"
   curl -f http://localhost:9000/api/system/status || echo "Portainer health check failed"
   ```

2. **Performance Validation:**
   ```bash
   # Basic performance checks
   time curl http://localhost:8080/api/status
   docker stats --no-stream
   ```

3. **Log Analysis:**
   ```bash
   # Check for errors during rollback
   docker-compose logs --tail=50
   journalctl -u docker --since "10 minutes ago"
   ```

## Rollback Prevention Best Practices

### Proactive Measures
1. **Daily Backups:** Automated backup of configurations and data
2. **Staging Environment:** Test all changes in staging first
3. **Gradual Rollouts:** Deploy changes incrementally
4. **Monitoring Alerts:** Set up alerts for early problem detection

### Documentation Updates
1. **Update After Each Rollback:** Document what went wrong and how it was fixed
2. **Review Recovery Objectives:** Adjust RTO/RPO based on actual experience
3. **Update Contact Lists:** Ensure team knows who to contact during incidents

## Contact Information

### Emergency Contacts
- **Primary:** [Your Name] - [Phone/Email]
- **Secondary:** [Backup Contact] - [Phone/Email]
- **Infrastructure Provider:** Hetzner Support - support@hetzner.com
- **Infrastructure Provider:** DigitalOcean Support - support@digitalocean.com

### Escalation Procedures
1. **T < 15 minutes:** Handle personally
2. **15min < T < 1 hour:** Contact secondary
3. **T > 1 hour:** Contact infrastructure providers

---

*This document should be reviewed and updated after each deployment and rollback scenario. Last updated: $(date)*