# Continuous Performance Monitoring

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