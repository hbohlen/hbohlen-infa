# Current System Configuration

### Infrastructure Baseline
- **Primary VPS (Hetzner):** CX11 (2 vCPU, 4GB RAM, 40GB SSD)
- **Secondary VPS (DigitalOcean):** Basic Droplet (1 vCPU, 1GB RAM, 25GB SSD)
- **Network:** Tailscale mesh networking
- **Services:** FalkorDB Browser, basic infrastructure

### Service Baseline
- **FalkorDB Browser:** Containerized web interface
- **Access Pattern:** HTTPS via Caddy reverse proxy
- **Expected Load:** 1-10 concurrent users
- **Geographic Distribution:** EU-based users