# Epic 1: Secure Network Foundation (Tailscale)

### Trigger Conditions
- Tailscale connectivity failures affecting >50% of nodes
- SSH access lost to critical infrastructure nodes
- Network latency >500ms consistently
- Tailscale daemon crashes preventing service communication

### Recovery Objectives
- **RTO:** 10 minutes
- **RPO:** No data loss (network configuration only)

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic1.sh - Tailscale Network Rollback

echo "=== Epic 1 Rollback: Tailscale Network ==="

# Stop Tailscale daemon
sudo systemctl stop tailscaled

# Remove current Tailscale configuration
sudo tailscale down
sudo rm -f /var/lib/tailscale/tailscaled.state

# Restore previous network configuration
sudo cp /etc/netplan/backup/01-netcfg.yaml /etc/netplan/01-netcfg.yaml
sudo netplan apply

# Restart networking
sudo systemctl restart networking

# Verify connectivity
ping -c 3 8.8.8.8
echo "Network rollback complete. Verify service access manually."
```

### Manual Procedures
1. **Stop Tailscale Service:**
   ```bash
   sudo systemctl stop tailscaled
   sudo tailscale down
   ```

2. **Restore Network Configuration:**
   ```bash
   sudo cp /etc/netplan/backup/01-netcfg.yaml /etc/netplan/01-netcfg.yaml
   sudo netplan apply
   ```

3. **Restart Networking:**
   ```bash
   sudo systemctl restart networking
   ```

4. **Verify Connectivity:**
   ```bash
   ping -c 3 8.8.8.8
   ssh user@hetzner-ip  # Test SSH access
   ```

### Validation Steps
- [ ] Internet connectivity restored
- [ ] SSH access to all VPS nodes working
- [ ] Existing services accessible via direct IPs
- [ ] No Tailscale-related errors in system logs