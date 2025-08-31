# Automated Integration Tests

### Epic 1-2 Integration: Network + Routing

```bash
#!/bin/bash
# test-epic1-epic2-integration.sh

echo "Testing Epic 1-2 Integration: Network + Routing"

# Test 1: Network connectivity
echo "1. Testing Tailscale network connectivity..."
ping -c 3 100.64.0.1  # Tailscale gateway
if [ $? -ne 0 ]; then
    echo "❌ Network connectivity test failed"
    exit 1
fi

# Test 2: Caddy routing through Tailscale
echo "2. Testing Caddy routing..."
RESPONSE=$(curl -s -w "%{http_code}" -o /dev/null https://falkordb.hbohlen.io)
if [ "$RESPONSE" != "200" ]; then
    echo "❌ Caddy routing test failed (HTTP $RESPONSE)"
    exit 1
fi

# Test 3: SSL termination
echo "3. Testing SSL certificate..."
SSL_VALID=$(curl -s -I https://falkordb.hbohlen.io | grep -c "HTTP/2 200")
if [ "$SSL_VALID" -eq 0 ]; then
    echo "❌ SSL certificate test failed"
    exit 1
fi

echo "✅ Epic 1-2 integration tests passed"
```

### Epic 2-3 Integration: Routing + Deployment

```bash
#!/bin/bash
# test-epic2-epic3-integration.sh

echo "Testing Epic 2-3 Integration: Routing + Deployment"

# Test 1: GitOps deployment trigger
echo "1. Testing GitOps deployment..."
git tag test-deployment-$(date +%s)
git push origin --tags

# Wait for deployment
sleep 30

# Test 2: Service availability after deployment
echo "2. Testing service availability..."
HEALTH_CHECK=$(curl -s http://localhost:8080/health)
if [ "$HEALTH_CHECK" != "OK" ]; then
    echo "❌ Service health check failed"
    exit 1
fi

# Test 3: Configuration consistency
echo "3. Testing configuration consistency..."
CADDY_CONFIG=$(docker exec caddy cat /etc/caddy/Caddyfile)
if ! echo "$CADDY_CONFIG" | grep -q "falkordb.hbohlen.io"; then
    echo "❌ Configuration consistency test failed"
    exit 1
fi

echo "✅ Epic 2-3 integration tests passed"
```

### Epic 3-4 Integration: Deployment + Orchestration

```bash
#!/bin/bash
# test-epic3-epic4-integration.sh

echo "Testing Epic 3-4 Integration: Deployment + Orchestration"

# Test 1: Portainer API integration
echo "1. Testing Portainer API..."
PORTAINER_STATUS=$(curl -s http://localhost:9000/api/system/status)
if [ -z "$PORTAINER_STATUS" ]; then
    echo "❌ Portainer API test failed"
    exit 1
fi

# Test 2: Container orchestration
echo "2. Testing container orchestration..."
CONTAINER_COUNT=$(docker ps | grep -c "hbohlen")
if [ "$CONTAINER_COUNT" -lt 3 ]; then
    echo "❌ Container orchestration test failed"
    exit 1
fi

# Test 3: Resource management
echo "3. Testing resource management..."
CPU_USAGE=$(docker stats --no-stream --format "table {{.CPUPerc}}" | tail -n +2 | sed 's/%//')
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "❌ Resource management test failed (CPU > 80%)"
    exit 1
fi

echo "✅ Epic 3-4 integration tests passed"
```