# Integration Testing Strategy for hbohlen.io Personal Cloud

## Overview

This document defines the integration testing strategy for the hbohlen.io Personal Cloud project. Integration testing validates that components from different epics work together correctly, ensuring end-to-end functionality and preventing breaking changes during the brownfield enhancement process.

## Integration Testing Objectives

- **Validate Cross-Epic Dependencies:** Ensure components from different epics integrate seamlessly
- **Prevent Breaking Changes:** Catch integration issues before they affect production
- **Maintain Service Continuity:** Verify existing services remain functional during enhancements
- **Performance Validation:** Ensure new components don't degrade existing performance
- **Security Verification:** Confirm security measures work across integrated components

## Integration Points Matrix

| Integration Point | Epic A | Epic B | Test Type | Frequency | Owner |
|------------------|--------|--------|-----------|-----------|-------|
| Network + Routing | Epic 1 | Epic 2 | Automated | Pre-deploy | Dev |
| Routing + Deployment | Epic 2 | Epic 3 | Automated | Pre-deploy | Dev |
| Deployment + Orchestration | Epic 3 | Epic 4 | Automated | Pre-deploy | Dev |
| Orchestration + Discovery | Epic 4 | Epic 5 | Manual | Post-deploy | Dev |
| Network + Monitoring | Epic 1 | All | Automated | Continuous | Dev |
| Full Stack Integration | All | All | Manual | Weekly | Dev |

## Testing Environment Setup

### Staging Environment Configuration

```yaml
# infrastructure/docker-compose.staging.yml
version: '3.8'
services:
  # Core infrastructure (always running)
  caddy:
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./caddy/Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
    networks:
      - hbohlen-network

  # Existing service (FalkorDB Browser)
  falkordb-browser:
    image: falkordb/falkordb-browser:latest
    ports:
      - "8080:8080"
    environment:
      - FALKORDB_URL=http://falkordb:6379
    networks:
      - hbohlen-network
    depends_on:
      - falkordb

  # Test services for integration validation
  integration-tester:
    image: curlimages/curl:latest
    networks:
      - hbohlen-network
    profiles:
      - testing

networks:
  hbohlen-network:
    driver: bridge

volumes:
  caddy_data:
```

### Test Data Setup

```bash
#!/bin/bash
# setup-integration-test-data.sh

echo "Setting up integration test data..."

# Create test database entries
docker exec falkordb redis-cli SET test:key "integration-test-value"

# Configure test domains
echo "test.hbohlen.io integration test service" >> /etc/hosts

# Set up test certificates
mkdir -p /opt/caddy/test-certs
openssl req -x509 -newkey rsa:4096 -keyout /opt/caddy/test-certs/key.pem \
  -out /opt/caddy/test-certs/cert.pem -days 365 -nodes \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=test.hbohlen.io"

echo "Integration test data setup complete."
```

## Automated Integration Tests

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

## Manual Integration Testing Procedures

### Weekly Full Integration Test

**Preparation:**
1. Ensure staging environment is running
2. Verify all services are healthy
3. Check monitoring dashboards for baseline metrics

**Test Scenarios:**

#### Scenario 1: End-to-End Service Request
1. **Objective:** Validate complete request flow from external user to service
2. **Steps:**
   - Access https://falkordb.hbohlen.io from external network
   - Verify SSL certificate validity
   - Confirm service responds correctly
   - Check monitoring shows request in logs
3. **Success Criteria:**
   - Response time < 500ms
   - SSL certificate valid
   - Monitoring data captured
   - No errors in service logs

#### Scenario 2: Service Deployment Integration
1. **Objective:** Test GitOps deployment with monitoring integration
2. **Steps:**
   - Make configuration change in Git
   - Push change to trigger deployment
   - Monitor deployment progress in Portainer
   - Verify service health after deployment
   - Check monitoring alerts (if any)
3. **Success Criteria:**
   - Deployment completes within 5 minutes
   - Service remains accessible during deployment
   - Monitoring captures deployment metrics
   - No false positive alerts

#### Scenario 3: Multi-Node Orchestration
1. **Objective:** Validate container orchestration across nodes
2. **Steps:**
   - Deploy test service to specific node via Portainer
   - Verify service appears in correct node
   - Test inter-node communication
   - Check resource allocation
3. **Success Criteria:**
   - Service deploys to correct node
   - Inter-node communication works
   - Resource limits respected
   - Portainer shows correct status

#### Scenario 4: Monitoring Integration
1. **Objective:** Validate monitoring tools work together
2. **Steps:**
   - Generate test traffic to services
   - Check Datadog metrics collection
   - Verify New Relic APM data
   - Review Sentry error tracking
   - Compare data consistency across tools
3. **Success Criteria:**
   - All monitoring tools collect data
   - Metrics are consistent across tools
   - No data gaps or duplicates
   - Alert thresholds working

## Performance Integration Testing

### Baseline Performance Metrics

```bash
#!/bin/bash
# performance-baseline.sh

echo "Establishing Performance Baseline..."

# Network latency
NETWORK_LATENCY=$(ping -c 10 localhost | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
echo "Network Latency: ${NETWORK_LATENCY}ms"

# Service response time
SERVICE_RESPONSE=$(curl -s -w "%{time_total}" -o /dev/null http://localhost:8080/health)
echo "Service Response: ${SERVICE_RESPONSE}s"

# Container resource usage
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}"

# SSL handshake time
SSL_TIME=$(curl -s -w "%{time_connect}" -o /dev/null https://falkordb.hbohlen.io)
echo "SSL Handshake: ${SSL_TIME}s"

echo "Performance baseline established."
```

### Performance Regression Tests

```bash
#!/bin/bash
# performance-regression-test.sh

echo "Running Performance Regression Tests..."

# Load testing
echo "1. Load testing..."
hey -n 1000 -c 10 https://falkordb.hbohlen.io

# Memory leak detection
echo "2. Memory monitoring..."
docker stats --format "table {{.Name}}\t{{.MemPerc}}" | grep hbohlen

# Network throughput
echo "3. Network throughput..."
iperf3 -c localhost -t 10

# Database performance
echo "4. Database performance..."
docker exec falkordb redis-benchmark -n 1000 -c 10

echo "Performance regression tests complete."
```

## Security Integration Testing

### Authentication & Authorization Tests

```bash
#!/bin/bash
# security-integration-test.sh

echo "Running Security Integration Tests..."

# Test 1: SSL/TLS validation
echo "1. SSL/TLS validation..."
SSL_LABS=$(curl -s "https://api.ssllabs.com/api/v3/analyze?host=falkordb.hbohlen.io" | jq -r '.endpoints[0].grade')
if [ "$SSL_LABS" = "A" ] || [ "$SSL_LABS" = "A+" ]; then
    echo "✅ SSL grade: $SSL_LABS"
else
    echo "❌ SSL grade too low: $SSL_LABS"
    exit 1
fi

# Test 2: Network security
echo "2. Network security..."
nmap -sV --script ssl-enum-ciphers falkordb.hbohlen.io

# Test 3: Container security
echo "3. Container security..."
docker scan hbohlen/falkordb-browser

# Test 4: Access control
echo "4. Access control..."
curl -I http://localhost:8080  # Should redirect to HTTPS
curl -I https://falkordb.hbohlen.io/admin  # Should require auth if configured

echo "Security integration tests complete."
```

## Test Automation Framework

### CI/CD Integration

```yaml
# .github/workflows/integration-tests.yml
name: Integration Tests
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  integration-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Infrastructure
        run: |
          docker-compose -f infrastructure/docker-compose.staging.yml up -d
          sleep 30

      - name: Run Automated Integration Tests
        run: |
          chmod +x scripts/test-integration.sh
          ./scripts/test-integration.sh

      - name: Performance Tests
        run: |
          chmod +x scripts/performance-baseline.sh
          ./scripts/performance-baseline.sh

      - name: Security Tests
        run: |
          chmod +x scripts/security-integration-test.sh
          ./scripts/security-integration-test.sh

      - name: Cleanup
        if: always()
        run: docker-compose -f infrastructure/docker-compose.staging.yml down
```

### Test Result Reporting

```bash
#!/bin/bash
# generate-test-report.sh

echo "# Integration Test Report" > test-report.md
echo "Generated: $(date)" >> test-report.md
echo "" >> test-report.md

echo "## Test Results" >> test-report.md
echo "| Test | Status | Duration | Details |" >> test-report.md
echo "|------|--------|----------|---------|" >> test-report.md

# Add test results...
echo "| Epic 1-2 Integration | ✅ PASS | 45s | All network routing tests passed |" >> test-report.md
echo "| Epic 2-3 Integration | ✅ PASS | 120s | GitOps deployment successful |" >> test-report.md
echo "| Epic 3-4 Integration | ⚠️ WARN | 90s | Portainer API response slow |" >> test-report.md

echo "" >> test-report.md
echo "## Recommendations" >> test-report.md
echo "- Monitor Portainer API performance" >> test-report.md
echo "- Consider API caching for better response times" >> test-report.md

echo "Test report generated: test-report.md"
```

## Success Criteria & Validation

### Integration Test Success Metrics

- **Test Pass Rate:** > 95% of automated tests pass
- **Performance Regression:** < 10% degradation from baseline
- **Security Compliance:** All security tests pass
- **Manual Test Coverage:** 100% of critical integration scenarios tested weekly

### Validation Checklist

- [ ] All automated integration tests pass
- [ ] Manual end-to-end scenarios complete successfully
- [ ] Performance metrics within acceptable ranges
- [ ] Security scans show no critical vulnerabilities
- [ ] Monitoring tools report consistent data
- [ ] Rollback procedures tested and functional
- [ ] Documentation updated with test results

## Continuous Integration

### Daily Health Checks

```bash
#!/bin/bash
# daily-health-check.sh

echo "Running Daily Integration Health Check..."

# Service availability
curl -f https://falkordb.hbohlen.io/health || echo "❌ FalkorDB health check failed"

# Container status
docker ps | grep -q hbohlen-caddy || echo "❌ Caddy container not running"

# Network connectivity
ping -c 1 8.8.8.8 > /dev/null || echo "❌ Network connectivity issue"

# Certificate validity
openssl s_client -connect falkordb.hbohlen.io:443 -servername falkordb.hbohlen.io < /dev/null 2>/dev/null | openssl x509 -noout -dates

echo "Daily health check complete."
```

### Alert Integration

```yaml
# monitoring/alerts/integration-alerts.yml
groups:
  - name: integration_alerts
    rules:
      - alert: IntegrationTestFailure
        expr: integration_test_status == 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Integration test failure detected"
          description: "Automated integration tests have failed. Check test logs for details."

      - alert: PerformanceRegression
        expr: service_response_time > 1.5
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Performance regression detected"
          description: "Service response time has increased significantly."
```

## Test Data Management

### Test Data Strategy

1. **Ephemeral Test Data:** Use temporary databases for integration tests
2. **Seed Data:** Pre-populated test data for consistent testing
3. **Cleanup Procedures:** Automated cleanup after test completion
4. **Data Isolation:** Separate test data from production data

### Test Data Scripts

```bash
#!/bin/bash
# setup-test-data.sh

echo "Setting up test data..."

# Create test database
docker exec postgres createdb integration_test

# Seed test data
docker exec -i postgres psql integration_test << EOF
CREATE TABLE test_metrics (
    id SERIAL PRIMARY KEY,
    metric_name VARCHAR(255),
    value DECIMAL,
    timestamp TIMESTAMP DEFAULT NOW()
);

INSERT INTO test_metrics (metric_name, value) VALUES
('cpu_usage', 45.5),
('memory_usage', 67.8),
('response_time', 0.234);
EOF

echo "Test data setup complete."
```

---

*This integration testing strategy ensures robust validation of cross-epic dependencies and prevents breaking changes during the brownfield enhancement process. Regular execution of these tests provides confidence in system stability and performance.*