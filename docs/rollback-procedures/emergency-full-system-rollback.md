# Emergency Full System Rollback

### Trigger Conditions
- Multiple epic failures
- Complete system instability
- Data corruption concerns
- Extended downtime (>1 hour)

### Recovery Objectives
- **RTO:** 30 minutes
- **RPO:** Last daily backup

### Emergency Rollback Script
```bash
#!/bin/bash
# emergency-rollback.sh - Full System Rollback

echo "=== EMERGENCY: Full System Rollback ==="

# Stop all services
docker-compose down

# Restore from backup
BACKUP_DIR="/opt/hbohlen/backup/$(date +%Y%m%d)"
if [ -d "$BACKUP_DIR" ]; then
    cp -r $BACKUP_DIR/* /opt/hbohlen/
    echo "Backup restored from $BACKUP_DIR"
else
    echo "No recent backup found, using git fallback"
    git checkout main
    git reset --hard HEAD~10  # Go back 10 commits
fi

# Start minimal services
docker-compose -f infrastructure/docker-compose.minimal.yml up -d

# Verify basic functionality
curl http://localhost:8080/health
echo "Emergency rollback complete. Assess system stability before proceeding."
```