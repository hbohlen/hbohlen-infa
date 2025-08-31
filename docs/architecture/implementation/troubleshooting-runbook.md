# Infrastructure Troubleshooting Runbook

## Emergency Response Procedures

### Service Completely Unavailable (Red Alert)
**Symptoms:** All *.hbohlen.io services return timeout or connection refused

**Immediate Actions (5 minutes):**
1. **Check Gateway Status:**
   ```bash
   # From external location
   ping gateway.hbohlen.io
   curl -I https://api.hbohlen.io/health
   
   # If accessible via SSH
   ssh admin@<hetzner-ip>
   systemctl status caddy consul portainer
   ```

2. **Verify Tailscale Connectivity:**
   ```bash
   tailscale status
   tailscale ping <service-node-tailscale-ip>
   ```

3. **Check Datadog Dashboard:**
   - Navigate to hbohlen.io Infrastructure Overview dashboard
   - Check gateway node CPU, memory, disk usage
   - Review recent alerts and events

**Recovery Actions (15 minutes):**
1. **Service Restart Sequence:**
   ```bash
   # On gateway node
   sudo systemctl restart tailscale
   sleep 30
   sudo systemctl restart caddy
   sleep 30
   sudo systemctl restart consul
   sudo systemctl restart portainer
   ```

2. **Verify Service Recovery:**
   ```bash
   # Test each service endpoint
   curl -f https://test.hbohlen.io/health
   curl -f https://portainer.hbohlen.io/api/system/status
   ```

3. **Escalation:** If services don't recover, page through Honeybadger and begin detailed investigation

### Individual Service Down (Yellow Alert)
**Symptoms:** Specific service (e.g., falkordb.hbohlen.io) unavailable but others working

**Investigation Sequence:**
1. **Check Service Discovery:**
   ```bash
   # On gateway node
   consul services list
   consul health service <service-name>
   curl http://localhost:8500/v1/health/service/<service-name>
   ```

2. **Check Container Status:**
   ```bash
   # Via Portainer API or direct node access
   ssh admin@<service-node-tailscale-ip>
   docker ps -a | grep <service-name>
   docker logs <container-id> --tail 50
   ```

3. **Check Monitoring Data:**
   - **Datadog:** Service-specific dashboard for resource usage
   - **New Relic:** Application performance and error rates
   - **Sentry:** Recent errors and performance issues
   - **Honeybadger:** Uptime monitoring and alerts

**Resolution Actions:**
1. **Container Restart:**
   ```bash
   docker restart <container-id>
   # Or via Portainer interface
   ```

2. **Service Re-registration:**
   ```bash
   # Force service re-registration with Consul
   consul services deregister <service-id>
   # Container restart should trigger re-registration
   ```

3. **Configuration Validation:**
   ```bash
   # Check Doppler configuration
   doppler secrets get --project hbohlen-io --config production
   # Verify environment variables match expectations
   ```

### Monitoring Tool Failures
**Symptoms:** Datadog, New Relic, or Sentry not receiving data

**Tool-Specific Troubleshooting:**

#### Datadog Agent Issues
```bash
# Check agent status
sudo datadog-agent status
sudo datadog-agent flare  # Generate diagnostic package

# Common fixes
sudo systemctl restart datadog-agent
sudo datadog-agent config check
sudo datadog-agent check docker

# Validate configuration
cat /etc/datadog-agent/datadog.yaml | grep -E "(api_key|site|tags)"
```

#### New Relic Agent Issues
```bash
# Check Node.js APM agent
pm2 logs | grep -i newrelic
# Check agent connectivity
curl -H "Api-Key: $NEW_RELIC_LICENSE_KEY" \
  https://api.newrelic.com/v2/applications.json

# Configuration validation
echo $NEW_RELIC_LICENSE_KEY | wc -c  # Should be 40 characters
```

#### Sentry Integration Issues
```bash
# Test Sentry connectivity
curl -X POST \
  -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  https://sentry.io/api/0/projects/

# Check error capture
node -e "require('@sentry/node').captureMessage('Test message')"
```

## Performance Degradation

### Slow Response Times (>2 seconds)
**Investigation Priority:**
1. **Gateway Performance:** Check Caddy and gateway node resources
2. **Network Latency:** Test Tailscale mesh performance
3. **Service Performance:** Check individual service resource usage
4. **Database Performance:** Analyze database query performance

**Performance Analysis Commands:**
```bash
# Gateway analysis
htop  # Real-time resource usage
iotop # Disk I/O analysis  
netstat -tuln # Network connection analysis

# Network latency testing
tailscale ping <service-node>
curl -w "@curl-format.txt" https://api.hbohlen.io/health

# Service-specific analysis
docker stats <container-id>
docker exec <container-id> top
```

**Optimization Actions:**
1. **Resource Scaling:** Based on Datadog metrics and cost analysis
2. **Caching Implementation:** Redis caching for frequently accessed data
3. **Database Optimization:** Query optimization and connection pooling
4. **CDN Configuration:** Cloudflare caching for static assets

### High Resource Usage (>80% sustained)
**Immediate Response:**
1. **Identify Resource Consumer:**
   ```bash
   # CPU analysis
   ps aux --sort=-%cpu | head -10
   
   # Memory analysis  
   ps aux --sort=-%mem | head -10
   
   # Container resource usage
   docker stats --no-stream
   ```

2. **Quick Mitigation:**
   ```bash
   # Restart high-resource services
   docker restart <high-usage-container>
   
   # Clear temporary files and logs
   docker system prune -f
   journalctl --vacuum-time=7d
   ```

3. **Monitoring Analysis:**
   - Review Datadog resource utilization trends
   - Check New Relic performance profiling data
   - Analyze recent deployment impact via monitoring correlation

## Network and Connectivity Issues

### Tailscale Mesh Problems
**Common Issues and Solutions:**

**Connectivity Between Nodes:**
```bash
# Restart Tailscale and check status
sudo systemctl restart tailscale
tailscale status
tailscale netcheck

# Debug connectivity
tailscale ping <target-node>
sudo tailscale configure resolvers
```

**DNS Resolution Issues:**
```bash
# Check Tailscale DNS configuration
dig @100.100.100.100 <service-node-name>
nslookup <tailscale-hostname>

# Reset Tailscale if needed
sudo tailscale down
sudo tailscale up --accept-routes --accept-dns
```

### SSL Certificate Issues
**Symptoms:** HTTPS not working, certificate warnings, expired certificates

**Certificate Troubleshooting:**
```bash
# Check certificate status
caddy list-certificates
openssl s_client -connect hbohlen.io:443 -servername hbohlen.io

# Certificate renewal
curl -X POST http://localhost:2019/config/apps/http/servers/srv0/routes/0/handle/0/issues
```

**Common Certificate Fixes:**
```bash
# Restart Caddy if certificate issues
sudo systemctl restart caddy

# Clear certificate cache if needed
sudo rm -rf /var/lib/caddy/.local/share/caddy/
sudo systemctl restart caddy

# Check Let's Encrypt rate limits
curl -s https://acme-v02.api.letsencrypt.org/directory
```

## Deployment and CI/CD Issues

### GitHub Actions Failures
**Common Failure Patterns:**

**Secret/Configuration Issues:**
```bash
# Verify GitHub secrets are properly configured
# Check repository settings > Secrets and variables
# Validate Doppler token access from Actions

# Test secret access locally
doppler secrets get --project hbohlen-io --config production
```

**Deployment Pipeline Failures:**
```yaml
# Debug deployment step
- name: Debug Deployment Environment
  run: |
    echo "Branch: ${{ github.ref }}"
    echo "Environment: ${{ github.event.deployment.environment }}"
    printenv | grep -E "(DOPPLER|GITHUB)" | sort
```

**Container Build Issues:**
```bash
# Test container build locally
docker build -t test-build .
docker run --rm test-build npm test

# Check GitHub Container Registry access
echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_ACTOR --password-stdin
```

### Service Discovery Problems
**Consul Service Registration Issues:**

```bash
# Check Consul cluster health
consul members
consul operator raft list-peers

# Service registration debugging
consul services list
consul health service <service-name>
consul catalog nodes -service <service-name>

# Re-register service manually if needed
consul services register service-definition.json
```

## Learning-Specific Troubleshooting

### Tool Integration Complexity
**When enterprise tools become overwhelming:**

1. **Simplification Strategy:**
   - Temporarily disable complex monitoring integrations
   - Focus on single tool mastery before re-adding complexity
   - Document simplified configuration alternatives

2. **Learning Pace Adjustment:**
   - Extend weekly objectives if tool complexity exceeds estimates
   - Focus on conceptual understanding before advanced features
   - Prioritize hands-on experience over comprehensive feature exploration

3. **Escape Hatch Activation:**
   - Switch to documented simpler alternatives if tools block learning
   - Maintain infrastructure patterns while reducing tool complexity
   - Plan return to enterprise tools when foundation is solid

### Knowledge Gap Management
**When infrastructure concepts become unclear:**

1. **Concept Reinforcement:**
   - Return to fundamental documentation and tutorials
   - Implement simplified versions of complex patterns
   - Use monitoring data to validate understanding

2. **Learning Resource Access:**
   - Leverage GitHub Education Pack training resources
   - Access vendor documentation and certification materials
   - Engage with tool communities and support channels

3. **Progressive Complexity:**
   - Break complex concepts into smaller learning increments
   - Validate understanding through practical implementation
   - Document learning progression for future reference

## Escalation Procedures

### Technical Escalation Path
1. **Level 1:** Self-troubleshooting using this runbook (30 minutes maximum)
2. **Level 2:** Community resources and documentation (1 hour maximum)
3. **Level 3:** GitHub Education Pack vendor support (enterprise tools)
4. **Level 4:** Infrastructure simplification and alternative approaches

### Learning Escalation Path
1. **Concept Review:** Return to fundamental documentation and tutorials
2. **Alternative Learning:** Video tutorials, online courses, community examples
3. **Simplification:** Reduce complexity and focus on core patterns
4. **Timeline Adjustment:** Extend learning timeline rather than compromise understanding

### Emergency Contact Information
- **GitHub Education Support:** education@github.com
- **Datadog Education Support:** education@datadoghq.com  
- **New Relic Education:** education@newrelic.com
- **VPS Provider Support:** Hetzner and DigitalOcean support channels

This runbook provides systematic approaches to common infrastructure issues while maintaining focus on learning objectives and enterprise tool integration throughout the troubleshooting process.