# Tailscale Infrastructure Scripts

This directory contains scripts for setting up and managing Tailscale mesh networking across VPS instances.

## Scripts Overview

### Installation Scripts

#### `install-tailscale-gateway.sh`
Installs and configures Tailscale on the Hetzner gateway VPS.

**Usage:**
```bash
# Run on Hetzner gateway VPS
sudo ./install-tailscale-gateway.sh
```

**What it does:**
- Detects OS and architecture
- Installs Tailscale from official repositories
- Configures systemd service
- Sets hostname to `gateway-hetzner`
- Provides next steps for authentication

#### `install-tailscale-service.sh`
Installs and configures Tailscale on the DigitalOcean service node VPS.

**Usage:**
```bash
# Run on DigitalOcean service node VPS
sudo ./install-tailscale-service.sh
```

**What it does:**
- Detects OS and architecture
- Installs Tailscale from official repositories
- Configures systemd service
- Sets hostname to `service-do-1`
- Provides next steps for authentication

### Configuration Scripts

#### `configure-tailscale-node.sh`
Configures Tailscale node settings including naming, tags, and routing.

**Usage:**
```bash
# Set node name
sudo ./configure-tailscale-node.sh --node-name gateway-hetzner

# Configure with auth key and tags
sudo ./configure-tailscale-node.sh --auth-key tskey-abc123 --tags tag:server,tag:gateway

# Configure route advertisement
sudo ./configure-tailscale-node.sh --advertise-routes --accept-routes

# Reset configuration
sudo ./configure-tailscale-node.sh --reset
```

**Options:**
- `-n, --node-name NAME`: Set the node hostname
- `-a, --auth-key KEY`: Use auth key for non-interactive authentication
- `-t, --tags TAGS`: Set node tags (comma-separated)
- `--advertise-routes`: Advertise local subnet routes
- `--accept-routes`: Accept routes from other nodes
- `--reset`: Reset Tailscale configuration

### Authentication Scripts

#### `authenticate-tailscale.sh`
Handles Tailscale authentication with various options.

**Usage:**
```bash
# Interactive authentication
sudo ./authenticate-tailscale.sh

# Authentication with reusable key
sudo ./authenticate-tailscale.sh --auth-key tskey-abc123

# Ephemeral node with tags
sudo ./authenticate-tailscale.sh --ephemeral --auth-key tskey-abc123 --tags tag:server

# Authentication with route advertisement
sudo ./authenticate-tailscale.sh --auth-key tskey-abc123 --advertise-routes --accept-routes

# Force re-authentication
sudo ./authenticate-tailscale.sh --force-reauth --auth-key tskey-abc123

# Wait for authentication to complete
sudo ./authenticate-tailscale.sh --auth-key tskey-abc123 --wait
```

**Options:**
- `-k, --auth-key KEY`: Use reusable auth key
- `-e, --ephemeral`: Create ephemeral node
- `-t, --tags TAGS`: Node tags (requires auth key)
- `--advertise-routes`: Advertise local subnet
- `--accept-routes`: Accept routes from peers
- `--force-reauth`: Force re-authentication
- `-w, --wait`: Wait for auth completion

### Verification Scripts

#### `verify-tailscale-setup.sh`
Verifies Tailscale setup and connectivity.

**Usage:**
```bash
# Basic verification
sudo ./verify-tailscale-setup.sh

# Verify specific node
sudo ./verify-tailscale-setup.sh --node-name gateway-hetzner

# Test connectivity to peers
sudo ./verify-tailscale-setup.sh --test-connectivity --peer-ips 100.64.0.2,100.64.0.3

# Generate report only
sudo ./verify-tailscale-setup.sh --report-only
```

**Options:**
- `-n, --node-name NAME`: Expected node name
- `-p, --peer-ips IPS`: Comma-separated peer IPs for connectivity testing
- `-t, --test-connectivity`: Test ping connectivity to peers
- `-r, --report-only`: Generate report without attempting fixes

## Deployment Workflow

### Step 1: Install Tailscale on Gateway VPS
```bash
# On Hetzner gateway VPS
sudo ./install-tailscale-gateway.sh
# Follow the authentication URL and authorize the node
```

### Step 2: Install Tailscale on Service Node VPS
```bash
# On DigitalOcean service node VPS
sudo ./install-tailscale-service.sh
# Follow the authentication URL and authorize the node
```

### Step 3: Verify Installation
```bash
# On each node, verify the setup
sudo ./verify-tailscale-setup.sh --node-name gateway-hetzner
sudo ./verify-tailscale-setup.sh --node-name service-do-1
```

### Step 4: Test Connectivity
```bash
# Get IP addresses from both nodes
tailscale ip -4

# Test connectivity between nodes
sudo ./verify-tailscale-setup.sh --test-connectivity --peer-ips <other-node-ip>
```

## Node Naming Convention

- **Gateway Node (Hetzner)**: `gateway-hetzner`
- **Service Node (DigitalOcean)**: `service-do-1`

## Security Considerations

- Use reusable auth keys for automated deployment
- Configure appropriate node tags for access control
- Enable route advertisement only when necessary
- Regularly rotate auth keys
- Monitor node status and connectivity

## Troubleshooting

### Common Issues

1. **Authentication fails**
   - Check internet connectivity
   - Verify Tailscale account permissions
   - Ensure auth key is valid and not expired

2. **Nodes can't communicate**
   - Verify both nodes are authorized in Tailscale admin console
   - Check firewall rules allow Tailscale traffic
   - Ensure nodes are in the same Tailscale network

3. **Service won't start**
   - Check systemd status: `sudo systemctl status tailscaled`
   - Review logs: `sudo journalctl -u tailscaled`
   - Verify system requirements are met

### Diagnostic Commands

```bash
# Check Tailscale status
tailscale status

# View IP addresses
tailscale ip -4
tailscale ip -6

# Check service status
sudo systemctl status tailscaled

# View logs
sudo journalctl -u tailscaled -f

# Test connectivity
ping <tailscale-ip>

# Check firewall
sudo ufw status
sudo firewall-cmd --list-all
```

## File Structure

```
infrastructure/scripts/
├── install-tailscale-gateway.sh     # Gateway VPS installation
├── install-tailscale-service.sh     # Service node installation
├── configure-tailscale-node.sh      # Node configuration
├── authenticate-tailscale.sh        # Authentication handling
├── verify-tailscale-setup.sh        # Setup verification
└── README.md                        # This documentation
```

## Requirements

- Linux VPS instances (Ubuntu, Debian, CentOS, RHEL, Fedora)
- Root or sudo access
- Internet connectivity
- Tailscale account with network access
- SSH access to VPS instances

## Integration with Infrastructure

These scripts are designed to work with the broader infrastructure setup defined in:
- `docs/architecture.md` - Overall architecture specifications
- `infrastructure/docker-compose/` - Container orchestration
- `infrastructure/caddy/` - Reverse proxy configuration
- `infrastructure/security/` - Security configurations