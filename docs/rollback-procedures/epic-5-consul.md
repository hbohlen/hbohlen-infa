# Epic 5: Service Discovery & Health Management (Consul)

### Trigger Conditions
- Consul cluster failures
- Service discovery registration issues
- Health check failures causing service outages
- DNS resolution problems

### Recovery Objectives
- **RTO:** 20 minutes
- **RPO:** No data loss (service configurations preserved)

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic5.sh - Consul Service Discovery Rollback

echo "=== Epic 5 Rollback: Consul Service Discovery ==="

# Stop Consul agents
docker stop consul-server consul-agent-hetzner consul-agent-do
docker rm consul-server consul-agent-hetzner consul-agent-do

# Restore direct service access configuration
cp infrastructure/docker-compose.consul-backup.yml infrastructure/docker-compose.yml

# Update Caddy configuration for direct routing
cp infrastructure/caddy/Caddyfile.no-consul infrastructure/caddy/Caddyfile

# Restart services
docker-compose up -d

# Verify service access
curl http://localhost:8080/health
echo "Consul rollback complete. Using direct service routing."
```

### Manual Procedures
1. **Stop Consul Services:**
   ```bash
   docker stop consul-server consul-agent-hetzner consul-agent-do
   docker rm consul-server consul-agent-hetzner consul-agent-do
   ```

2. **Restore Direct Configuration:**
   ```bash
   cp infrastructure/docker-compose.consul-backup.yml infrastructure/docker-compose.yml
   cp infrastructure/caddy/Caddyfile.no-consul infrastructure/caddy/Caddyfile
   ```

3. **Restart Services:**
   ```bash
   docker-compose up -d
   ```

4. **Update DNS/Local Resolution:**
   ```bash
   # Add direct IP mappings if needed
   echo "127.0.0.1 falkordb.local" >> /etc/hosts
   ```

### Validation Steps
- [ ] Services accessible via direct IPs/ports
- [ ] Caddy routing working without Consul
- [ ] No service discovery errors
- [ ] Health checks functional via direct methods