# Continuous Integration

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