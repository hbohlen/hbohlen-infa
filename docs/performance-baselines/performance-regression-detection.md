# Performance Regression Detection

### Automated Regression Testing

```bash
#!/bin/bash
# detect-performance-regression.sh

echo "Detecting Performance Regressions..."
echo "==================================="

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