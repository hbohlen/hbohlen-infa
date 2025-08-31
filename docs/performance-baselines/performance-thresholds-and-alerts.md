# Performance Thresholds & Alerts

### Baseline Thresholds

```yaml
# performance-thresholds.yml
thresholds:
  cpu:
    warning: 80
    critical: 95
    baseline: 45  # Current baseline CPU usage %

  memory:
    warning: 85
    critical: 95
    baseline: 60  # Current baseline memory usage %

  response_time:
    warning: 0.5   # seconds
    critical: 2.0
    baseline: 0.15 # Current baseline response time

  ssl_handshake:
    warning: 0.2
    critical: 1.0
    baseline: 0.08

  network_latency:
    warning: 50    # ms
    critical: 200
    baseline: 15   # Current baseline latency

  disk_usage:
    warning: 80
    critical: 95
    baseline: 45
```

### Alert Configuration

```yaml
# monitoring/alerts/performance-alerts.yml
groups:
  - name: performance_alerts
    rules:
      - alert: HighCPUUsage
        expr: cpu_usage_percent > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
          description: "CPU usage is {{ $value }}%, above baseline of 45%"

      - alert: HighMemoryUsage
        expr: memory_usage_percent > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage detected"
          description: "Memory usage is {{ $value }}%, above baseline of 60%"

      - alert: SlowResponseTime
        expr: service_response_time_seconds > 0.5
        for: 3m
        labels:
          severity: warning
        annotations:
          summary: "Slow response time detected"
          description: "Response time is {{ $value }}s, above baseline of 0.15s"

      - alert: HighNetworkLatency
        expr: network_latency_ms > 50
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High network latency detected"
          description: "Network latency is {{ $value }}ms, above baseline of 15ms"
```