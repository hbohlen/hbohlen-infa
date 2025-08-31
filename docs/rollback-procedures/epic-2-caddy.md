# Epic 2: Professional Service Access (Caddy)

### Trigger Conditions
- SSL certificate failures preventing HTTPS access
- Domain routing failures (>50% of requests failing)
- Caddy daemon crashes or configuration errors
- Performance degradation >200ms response time

### Recovery Objectives
- **RTO:** 5 minutes
- **RPO:** No data loss (configuration only)

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic2.sh - Caddy Service Access Rollback

echo "=== Epic 2 Rollback: Caddy Reverse Proxy ==="

# Stop current Caddy
docker stop hbohlen-caddy || true
docker rm hbohlen-caddy || true

# Restore previous Caddyfile
cp /opt/caddy/backup/Caddyfile.previous /opt/caddy/Caddyfile

# Start Caddy with previous configuration
docker run -d \
  --name hbohlen-caddy \
  --restart unless-stopped \
  -p 80:80 -p 443:443 \
  -v /opt/caddy/Caddyfile:/etc/caddy/Caddyfile \
  -v /opt/caddy/data:/data \
  caddy:latest

# Wait for startup
sleep 10

# Verify service access
curl -I https://falkordb.hbohlen.io
echo "Caddy rollback complete."
```

### Manual Procedures
1. **Stop Current Caddy:**
   ```bash
   docker stop hbohlen-caddy
   docker rm hbohlen-caddy
   ```

2. **Restore Configuration:**
   ```bash
   cp /opt/caddy/backup/Caddyfile.previous /opt/caddy/Caddyfile
   ```

3. **Start Caddy Manually:**
   ```bash
   docker run -d \
     --name hbohlen-caddy \
     --restart unless-stopped \
     -p 80:80 -p 443:443 \
     -v /opt/caddy/Caddyfile:/etc/caddy/Caddyfile \
     -v caddy_data:/data \
     caddy:latest
   ```

4. **Verify SSL and Routing:**
   ```bash
   curl -I https://falkordb.hbohlen.io
   curl -I https://test.hbohlen.io
   ```

### Validation Steps
- [ ] HTTPS access working for all domains
- [ ] SSL certificates valid (check with SSL Labs)
- [ ] Existing FalkorDB Browser accessible
- [ ] Response time <500ms
- [ ] No Caddy-related errors in logs