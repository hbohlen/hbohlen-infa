# Performance Baselines for hbohlen.io Personal Cloud

## Overview

This document establishes performance baselines for the hbohlen.io Personal Cloud infrastructure. Performance baselines provide the foundation for detecting performance regressions during brownfield enhancements and ensure that new components don't degrade existing service performance.

## Current System Configuration

### Infrastructure Baseline
- **Primary VPS (Hetzner):** CX11 (2 vCPU, 4GB RAM, 40GB SSD)
- **Secondary VPS (DigitalOcean):** Basic Droplet (1 vCPU, 1GB RAM, 25GB SSD)
- **Network:** Tailscale mesh networking
- **Services:** FalkorDB Browser, basic infrastructure

### Service Baseline
- **FalkorDB Browser:** Containerized web interface
- **Access Pattern:** HTTPS via Caddy reverse proxy
- **Expected Load:** 1-10 concurrent users
- **Geographic Distribution:** EU-based users

## Baseline Measurement Procedures

### Automated Baseline Collection

```bash
#!/bin/bash
# collect-performance-baseline.sh

echo "Collecting Performance Baseline - $(date)"
echo "========================================="

# Create baseline directory
BASELINE_DIR="performance-baselines/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BASELINE_DIR"

# System Resource Metrics
echo "1. System Resource Metrics"
echo "-------------------------" > "$BASELINE_DIR/system-resources.txt"

# CPU Usage
echo "CPU Usage:" >> "$BASELINE_DIR/system-resources.txt"
top -bn1 | head -10 >> "$BASELINE_DIR/system-resources.txt"

# Memory Usage
echo -e "\nMemory Usage:" >> "$BASELINE_DIR/system-resources.txt"
free -h >> "$BASELINE_DIR/system-resources.txt"

# Disk Usage
echo -e "\nDisk Usage:" >> "$BASELINE_DIR/system-resources.txt"
df -h >> "$BASELINE_DIR/system-resources.txt"

# Network Statistics
echo -e "\nNetwork Statistics:" >> "$BASELINE_DIR/system-resources.txt"
ip -s link >> "$BASELINE_DIR/system-resources.txt"

# Service Performance Metrics
echo "2. Service Performance Metrics"
echo "-----------------------------" > "$BASELINE_DIR/service-performance.txt"

# FalkorDB Browser Response Time
echo "FalkorDB Browser Response Times:" >> "$BASELINE_DIR/service-performance.txt"
for i in {1..10}; do
    RESPONSE_TIME=$(curl -s -w "%{time_total}" -o /dev/null http://localhost:8080/health)
    echo "$i: ${RESPONSE_TIME}s" >> "$BASELINE_DIR/service-performance.txt"
    sleep 1
done

# SSL/TLS Handshake Time
echo -e "\nSSL Handshake Times:" >> "$BASELINE_DIR/service-performance.txt"
for i in {1..5}; do
    SSL_TIME=$(curl -s -w "%{time_connect}" -o /dev/null https://falkordb.hbohlen.io)
    echo "$i: ${SSL_TIME}s" >> "$BASELINE_DIR/service-performance.txt"
    sleep 2
done

# Container Resource Usage
echo "3. Container Resource Usage"
echo "--------------------------" > "$BASELINE_DIR/container-resources.txt"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}" >> "$BASELINE_DIR/container-resources.txt"

# Network Performance
echo "4. Network Performance"
echo "---------------------" > "$BASELINE_DIR/network-performance.txt"

# Internal network latency
echo "Internal Network Latency:" >> "$BASELINE_DIR/network-performance.txt"
ping -c 10 100.64.0.1 >> "$BASELINE_DIR/network-performance.txt"  # Tailscale gateway

# External connectivity
echo -e "\nExternal Connectivity:" >> "$BASELINE_DIR/network-performance.txt"
ping -c 10 8.8.8.8 >> "$BASELINE_DIR/network-performance.txt"

# DNS resolution time
echo -e "\nDNS Resolution Time:" >> "$BASELINE_DIR/network-performance.txt"
time nslookup falkordb.hbohlen.io >> "$BASELINE_DIR/network-performance.txt"

# Generate summary report
echo "5. Baseline Summary"
echo "==================" > "$BASELINE_DIR/summary.txt"
echo "Baseline collected: $(date)" >> "$BASELINE_DIR/summary.txt"
echo "System: $(uname -a)" >> "$BASELINE_DIR/summary.txt"
echo "Docker version: $(docker --version)" >> "$BASELINE_DIR/summary.txt"
echo "Tailscale status: $(tailscale status | head -1)" >> "$BASELINE_DIR/summary.txt"

echo "Performance baseline collected in: $BASELINE_DIR"
echo "Use './analyze-baseline.sh $BASELINE_DIR' to analyze results."
```

### Load Testing Baseline

```bash
#!/bin/bash
# load-test-baseline.sh

echo "Running Load Test Baseline..."

# Install hey (lightweight load testing tool)
if ! command -v hey &> /dev/null; then
    wget https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64
    chmod +x hey_linux_amd64
    sudo mv hey_linux_amd64 /usr/local/bin/hey
fi

# Create results directory
RESULTS_DIR="load-test-baselines/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$RESULTS_DIR"

# Test configurations
URLS=("https://falkordb.hbohlen.io" "http://localhost:8080/health")
CONCURRENCIES=(1 5 10 25)
REQUESTS=100

for URL in "${URLS[@]}"; do
    for CONCURRENCY in "${CONCURRENCIES[@]}"; do
        echo "Testing $URL with $CONCURRENCY concurrent users..."

        OUTPUT_FILE="$RESULTS_DIR/$(basename ${URL}).concurrency-${CONCURRENCY}.txt"

        hey -n $REQUESTS -c $CONCURRENCY -q 1 "$URL" > "$OUTPUT_FILE"

        # Extract key metrics
        RESPONSE_TIME=$(grep "Average" "$OUTPUT_FILE" | awk '{print $2}')
        RPS=$(grep "Requests/sec" "$OUTPUT_FILE" | awk '{print $2}')
        P95=$(grep "95%" "$OUTPUT_FILE" | awk '{print $2}')

        echo "URL: $URL" >> "$RESULTS_DIR/summary.txt"
        echo "Concurrency: $CONCURRENCY" >> "$RESULTS_DIR/summary.txt"
        echo "Avg Response Time: ${RESPONSE_TIME}ms" >> "$RESULTS_DIR/summary.txt"
        echo "Requests/sec: $RPS" >> "$RESULTS_DIR/summary.txt"
        echo "95th Percentile: ${P95}ms" >> "$RESULTS_DIR/summary.txt"
        echo "---" >> "$RESULTS_DIR/summary.txt"
    done
done

echo "Load test baseline complete. Results in: $RESULTS_DIR"
```

## Baseline Analysis Tools

### Performance Analysis Script

```bash
#!/bin/bash
# analyze-baseline.sh

BASELINE_DIR=$1

if [ -z "$BASELINE_DIR" ]; then
    echo "Usage: $0 <baseline-directory>"
    exit 1
fi

echo "Analyzing Performance Baseline: $BASELINE_DIR"
echo "==========================================="

# System Resource Analysis
if [ -f "$BASELINE_DIR/system-resources.txt" ]; then
    echo "System Resource Analysis:"
    echo "-----------------------"

    # CPU Analysis
    CPU_IDLE=$(grep "CPU(s)" "$BASELINE_DIR/system-resources.txt" | awk '{print $8}')
    echo "CPU Idle: ${CPU_IDLE}%"

    # Memory Analysis
    MEM_TOTAL=$(grep "Mem:" "$BASELINE_DIR/system-resources.txt" | awk '{print $2}')
    MEM_USED=$(grep "Mem:" "$BASELINE_DIR/system-resources.txt" | awk '{print $3}')
    MEM_FREE=$(grep "Mem:" "$BASELINE_DIR/system-resources.txt" | awk '{print $4}')
    echo "Memory: ${MEM_USED}/${MEM_TOTAL} used (${MEM_FREE} free)"

    # Disk Analysis
    ROOT_USAGE=$(grep "/$" "$BASELINE_DIR/system-resources.txt" | awk '{print $5}' | tr -d '%')
    echo "Root Disk Usage: ${ROOT_USAGE}%"
fi

# Service Performance Analysis
if [ -f "$BASELINE_DIR/service-performance.txt" ]; then
    echo -e "\nService Performance Analysis:"
    echo "----------------------------"

    # Response Time Analysis
    RESPONSE_TIMES=$(grep -E "^[0-9]+:" "$BASELINE_DIR/service-performance.txt" | awk '{print $2}' | sed 's/s//')
    AVG_RESPONSE=$(echo "$RESPONSE_TIMES" | awk '{sum+=$1} END {print sum/NR}')
    echo "Average Response Time: ${AVG_RESPONSE}s"

    # SSL Analysis
    SSL_TIMES=$(grep -A5 "SSL Handshake Times" "$BASELINE_DIR/service-performance.txt" | grep -E "^[0-9]+:" | awk '{print $2}' | sed 's/s//')
    AVG_SSL=$(echo "$SSL_TIMES" | awk '{sum+=$1} END {print sum/NR}')
    echo "Average SSL Handshake: ${AVG_SSL}s"
fi

# Generate recommendations
echo -e "\nPerformance Recommendations:"
echo "---------------------------"

# CPU recommendations
if (( $(echo "$CPU_IDLE < 20" | bc -l) )); then
    echo "⚠️  CPU usage is high (${CPU_IDLE}% idle). Consider resource optimization."
else
    echo "✅ CPU usage is acceptable (${CPU_IDLE}% idle)."
fi

# Memory recommendations
MEM_USAGE_PERCENT=$(echo "scale=2; $MEM_USED / $MEM_TOTAL * 100" | bc -l | cut -d'.' -f1)
if [ "$MEM_USAGE_PERCENT" -gt 80 ]; then
    echo "⚠️  Memory usage is high (${MEM_USAGE_PERCENT}%). Monitor for leaks."
else
    echo "✅ Memory usage is acceptable (${MEM_USAGE_PERCENT}%)."
fi

# Response time recommendations
if (( $(echo "$AVG_RESPONSE > 0.5" | bc -l) )); then
    echo "⚠️  Response time is high (${AVG_RESPONSE}s). Consider optimization."
else
    echo "✅ Response time is acceptable (${AVG_RESPONSE}s)."
fi

echo -e "\nAnalysis complete."
```

## Performance Thresholds & Alerts

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

## Historical Performance Tracking

### Baseline History Database

```sql
-- performance_baselines.sql
CREATE TABLE performance_baselines (
    id SERIAL PRIMARY KEY,
    collection_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    metric_name VARCHAR(100) NOT NULL,
    metric_value DECIMAL NOT NULL,
    unit VARCHAR(20),
    environment VARCHAR(20) DEFAULT 'production',
    notes TEXT
);

CREATE TABLE performance_regressions (
    id SERIAL PRIMARY KEY,
    baseline_id INTEGER REFERENCES performance_baselines(id),
    regression_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    metric_name VARCHAR(100),
    baseline_value DECIMAL,
    current_value DECIMAL,
    percentage_change DECIMAL,
    severity VARCHAR(20) CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    resolved BOOLEAN DEFAULT FALSE,
    resolution_notes TEXT
);

-- Index for performance
CREATE INDEX idx_baselines_date ON performance_baselines(collection_date);
CREATE INDEX idx_baselines_metric ON performance_baselines(metric_name);
CREATE INDEX idx_regressions_date ON performance_regressions(regression_date);
```

### Historical Analysis Script

```bash
#!/bin/bash
# analyze-performance-history.sh

echo "Analyzing Performance History..."
echo "==============================="

# Query baseline history
echo "Recent Baselines:"
psql -h localhost -d hbohlen_io -c "
SELECT
    collection_date,
    metric_name,
    metric_value,
    unit
FROM performance_baselines
WHERE collection_date >= NOW() - INTERVAL '30 days'
ORDER BY collection_date DESC, metric_name;
"

# Check for regressions
echo -e "\nPerformance Regressions:"
psql -h localhost -d hbohlen_io -c "
SELECT
    r.regression_date,
    r.metric_name,
    r.baseline_value,
    r.current_value,
    r.percentage_change,
    r.severity
FROM performance_regressions r
WHERE r.resolved = FALSE
ORDER BY r.regression_date DESC;
"

# Generate trend analysis
echo -e "\nPerformance Trends (Last 30 Days):"
psql -h localhost -d hbohlen_io -c "
SELECT
    metric_name,
    ROUND(AVG(metric_value), 2) as avg_value,
    ROUND(STDDEV(metric_value), 2) as std_dev,
    MIN(metric_value) as min_value,
    MAX(metric_value) as max_value,
    COUNT(*) as measurements
FROM performance_baselines
WHERE collection_date >= NOW() - INTERVAL '30 days'
GROUP BY metric_name
ORDER BY metric_name;
"
```

## Performance Regression Detection

### Automated Regression Testing

```bash
#!/bin/bash
# detect-performance-regression.sh

echo "Detecting Performance Regressions..."

# Load baseline values
source performance-thresholds.sh

# Current measurements
CURRENT_CPU=$(top -bn1 | grep "CPU(s)" | awk '{print 100 - $8}')
CURRENT_MEMORY=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
CURRENT_RESPONSE=$(curl -s -w "%{time_total}" -o /dev/null http://localhost:8080/health)

# Calculate regressions
CPU_REGRESSION=$(echo "scale=2; ($CURRENT_CPU - $BASELINE_CPU) / $BASELINE_CPU * 100" | bc)
MEMORY_REGRESSION=$(echo "scale=2; ($CURRENT_MEMORY - $BASELINE_MEMORY) / $BASELINE_MEMORY * 100" | bc)
RESPONSE_REGRESSION=$(echo "scale=2; ($CURRENT_RESPONSE - $BASELINE_RESPONSE) / $BASELINE_RESPONSE * 100" | bc)

# Check thresholds
REGRESSIONS_FOUND=0

if (( $(echo "$CPU_REGRESSION > 20" | bc -l) )); then
    echo "⚠️  CPU regression detected: +${CPU_REGRESSION}%"
    REGRESSIONS_FOUND=1
fi

if (( $(echo "$MEMORY_REGRESSION > 15" | bc -l) )); then
    echo "⚠️  Memory regression detected: +${MEMORY_REGRESSION}%"
    REGRESSIONS_FOUND=1
fi

if (( $(echo "$RESPONSE_REGRESSION > 50" | bc -l) )); then
    echo "⚠️  Response time regression detected: +${RESPONSE_REGRESSION}%"
    REGRESSIONS_FOUND=1
fi

if [ $REGRESSIONS_FOUND -eq 0 ]; then
    echo "✅ No significant performance regressions detected"
else
    echo "❌ Performance regressions found - investigate immediately"
    exit 1
fi
```

## Continuous Performance Monitoring

### Daily Performance Report

```bash
#!/bin/bash
# daily-performance-report.sh

REPORT_DATE=$(date +%Y%m%d)
REPORT_FILE="performance-reports/daily-$REPORT_DATE.md"

echo "# Daily Performance Report - $(date)" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# System Health
echo "## System Health" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
uptime >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Resource Usage
echo "## Resource Usage" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Service Performance
echo "## Service Performance" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
echo "FalkorDB Browser Response Time: $(curl -s -w "%{time_total}" -o /dev/null http://localhost:8080/health)s" >> "$REPORT_FILE"
echo "SSL Handshake Time: $(curl -s -w "%{time_connect}" -o /dev/null https://falkordb.hbohlen.io)s" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Baseline Comparison
echo "## Baseline Comparison" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
./detect-performance-regression.sh >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"

# Send report
if command -v mail &> /dev/null; then
    mail -s "Daily Performance Report - $(date)" your-email@example.com < "$REPORT_FILE"
fi

echo "Daily performance report generated: $REPORT_FILE"
```

## Performance Optimization Guidelines

### CPU Optimization
- **Container Limits:** Set CPU limits in docker-compose.yml
- **Process Monitoring:** Identify CPU-intensive processes
- **Caching:** Implement appropriate caching strategies
- **Background Jobs:** Move heavy processing to background

### Memory Optimization
- **Container Limits:** Set memory limits and reservations
- **Memory Leaks:** Monitor for memory leaks in applications
- **Database Tuning:** Optimize database memory usage
- **Swap Management:** Configure appropriate swap settings

### Network Optimization
- **Connection Pooling:** Implement connection pooling
- **CDN Usage:** Leverage CDN for static assets
- **Compression:** Enable gzip/brotli compression
- **Caching:** Implement HTTP caching headers

### Database Optimization
- **Query Optimization:** Analyze and optimize slow queries
- **Indexing:** Ensure proper database indexes
- **Connection Pooling:** Configure database connection pools
- **Caching:** Implement database query caching

---

*This performance baseline documentation provides the foundation for detecting and preventing performance regressions during the brownfield enhancement process. Regular collection and analysis of these metrics ensures system stability and optimal user experience.*