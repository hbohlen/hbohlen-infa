# Baseline Measurement Procedures

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