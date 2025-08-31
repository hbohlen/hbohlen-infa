# Technical Considerations

### Platform Requirements

- **Target Platforms:** Linux VPS instances (Hetzner primary, Digital Ocean secondary, future expandable)
- **Browser/OS Support:** Modern browsers (Chrome, Firefox, Safari, Edge) with HTTPS support; Linux server environments
- **Performance Requirements:**
  - Primary Gateway: 2 vCPU, 4GB RAM, 40GB SSD (handles routing, SSL termination, service coordination)
  - Service Nodes: 1-2 vCPU, 2-4GB RAM, 20-40GB SSD each (handles individual services and containers)
  - Network: 1Gbps+ connectivity for primary, 100Mbps+ for service nodes
  - Expected Load: 10-50 concurrent users, 100-500 requests/minute initially

### Technology Preferences

- **Frontend:** Web-based interfaces for service management (Portainer, Consul UI, custom service UIs)
- **Backend:** Docker containers with Node.js/Python/Go services, REST APIs, WebSocket support where needed
- **Database:** PostgreSQL for relational data, Redis for caching/session management, document databases for flexible schemas
- **Infrastructure:**
  - Reverse Proxy: Caddy with Tailscale integration (TSDProxy)
  - Service Discovery: Consul for automatic service registration and health checking
  - Container Management: Portainer for multi-node Docker orchestration
  - Secrets Management: Doppler for environment variables and sensitive configuration
  - Networking: Tailscale mesh VPN for secure inter-VPS communication

### Architecture Considerations

- **Repository Structure:** Monorepo approach in existing hbohlen-io repository with clear directory separation (infrastructure/, services/, docs/)
- **Service Architecture:** Microservices pattern with clear boundaries, API-first design, container-based deployment
- **Integration Requirements:** GitHub webhooks for automated deployment, domain DNS configuration for *.hbohlen.io routing, webhook integrations for CI/CD
- **Security Requirements:** Tailscale-based network security, SSL/TLS encryption for all public services, secrets management through Doppler, regular security updates and monitoring

**Note:** These are initial technical preferences based on your brainstorming document. They represent a balanced approach prioritizing learning opportunities while maintaining production viability. Final technology choices may evolve based on implementation experience and specific service requirements.