# Epic 4: Multi-Node Container Orchestration (Portainer)

### Trigger Conditions
- Portainer web interface inaccessible
- Container management failures
- Multi-node orchestration issues
- Resource allocation problems

### Recovery Objectives
- **RTO:** 10 minutes
- **RPO:** No data loss (container configurations preserved)

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic4.sh - Portainer Orchestration Rollback

echo "=== Epic 4 Rollback: Portainer Orchestration ==="

# Stop Portainer
docker stop portainer
docker rm portainer

# Restore previous Docker Compose setup
cp infrastructure/docker-compose.backup.yml infrastructure/docker-compose.yml

# Start services without Portainer orchestration
docker-compose -f infrastructure/docker-compose.yml up -d

# Verify service access
curl http://localhost:8080/health
echo "Portainer rollback complete. Using direct Docker Compose management."
```

### Manual Procedures
1. **Stop Portainer:**
   ```bash
   docker stop portainer
   docker rm portainer
   ```

2. **Restore Direct Management:**
   ```bash
   cp infrastructure/docker-compose.backup.yml infrastructure/docker-compose.yml
   docker-compose up -d
   ```

3. **Verify Container Status:**
   ```bash
   docker ps
   docker stats  # Check resource usage
   ```

4. **Test Service Access:**
   ```bash
   curl http://localhost:8080/health
   ```

### Validation Steps
- [ ] All containers running (docker ps)
- [ ] Services accessible via direct ports
- [ ] Resource usage within normal limits
- [ ] No Portainer-related errors