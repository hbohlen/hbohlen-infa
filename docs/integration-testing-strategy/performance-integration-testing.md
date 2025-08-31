# Performance Integration Testing

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