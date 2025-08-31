# Baseline Analysis Tools

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