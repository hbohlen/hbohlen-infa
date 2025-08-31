# Technical Assumptions

### Repository Structure: Monorepo
The hbohlen-io repository will contain all infrastructure code, service configurations, and documentation in a single repository structure. This approach supports the learning objectives by keeping all related components visible and accessible, while simplifying CI/CD pipeline management and cross-service dependency tracking.

**Structure:**
```
infrastructure/          # Infrastructure as Code configs
├── docker-compose/     # Service orchestration files
├── caddy/             # Reverse proxy configurations
├── consul/            # Service discovery configs (Phase 3)
└── tailscale/         # Network configuration

services/               # Individual service implementations
├── falkordb-browser/  # Existing FalkorDB Browser
├── mcp-servers/       # Custom MCP server implementations
└── monitoring/        # Custom monitoring dashboards

docs/                  # All project documentation
├── infrastructure/    # Technical architecture docs
├── learning/         # Educational content and guides
└── operations/       # Runbooks and troubleshooting
```

### Service Architecture
**Hub-Spoke Microservices with Staged Complexity:** The infrastructure implements a distributed microservices pattern that evolves through three phases to prevent cognitive overload while building production-pattern understanding.

**Phase 1:** Simple containerized services with Caddy routing and Tailscale networking
**Phase 2:** Add Portainer orchestration layer for multi-node container management
**Phase 3:** Introduce Consul service discovery when service count (5+) justifies complexity

**Rationale:** This staged approach balances learning efficiency with production pattern exposure, allowing mastery of core concepts before introducing additional complexity layers.

### Testing Requirements
**Continuous Infrastructure Validation:** Testing strategy emphasizes operational reliability through monitoring-as-testing rather than traditional test pyramid approaches, aligning with infrastructure focus and time constraints.

**Validation Priorities by Phase:**
- **Phase 1:** Network connectivity, SSL certificate automation, basic health checks
- **Phase 2:** Container deployment automation, resource utilization monitoring
- **Phase 3:** Service discovery validation, inter-service communication testing, backup/recovery procedures

**Rationale:** This approach teaches infrastructure reliability patterns while remaining achievable within the 10-15 hour weekly time commitment.

### Technology Introduction Strategy

**Phase 1 Foundation (Months 1-2):**
- **Core Technologies:** Tailscale networking + Caddy reverse proxy
- **Learning Focus:** Secure networking and modern reverse proxy patterns
- **Success Criteria:** Services accessible via *.hbohlen.io with automatic SSL
- **Escape Hatch:** Fall back to traditional nginx + Let's Encrypt if Caddy proves problematic

**Phase 2 Orchestration (Months 3-4):**
- **Add:** Portainer for web-based container management
- **Learning Focus:** Multi-node Docker orchestration and container lifecycle management
- **Success Criteria:** 5+ services deployable and manageable through web interface
- **Migration Path:** Docker Compose → Portainer → (future Kubernetes if needed)

**Phase 3 Service Discovery (Months 5-6):**
- **Add:** Consul for service discovery and health checking
- **Learning Focus:** Production service discovery patterns and distributed system health
- **Success Criteria:** Automatic service registration and health-based routing
- **Alternative:** DNS-based discovery if Consul proves too complex or resource-intensive

### Additional Technical Assumptions and Requests

**Container Strategy:**
- Docker and Docker Compose for all service definitions and local development
- GitHub Container Registry for image hosting (free tier, integrated with repository)
- Standardized container health checks and resource limits

**Security and Configuration Management:**
- Tailscale mesh networking eliminating complex firewall management
- Caddy automatic SSL/TLS certificate management via Let's Encrypt
- Docker secrets for sensitive configuration (Phase 1-2), migrating to Consul KV (Phase 3)

**Development and Deployment:**
- GitOps deployment triggered by repository webhooks
- Development environment full replication through Docker Compose
- Infrastructure as Code principles with version-controlled declarative configurations

**Monitoring and Observability Evolution:**
- **Phase 1:** Caddy access logs and Docker container stats
- **Phase 2:** Portainer dashboards and resource monitoring
- **Phase 3:** Consul health checking and custom learning dashboards
- **Future:** Centralized logging approach (details TBD by Architect based on actual usage patterns)

**Data Persistence:**
- PostgreSQL for structured data requirements
- Redis for caching and session management
- File-based configuration with Git version control integration
- Backup strategy evolution: manual scripts → automated backups → disaster recovery procedures

**Technology Evolution Decision Points:**
- **Add Portainer:** When managing 3+ services becomes unwieldy with Docker Compose alone
- **Add Consul:** When service count reaches 5+ or service-to-service communication requires discovery
- **Consider Kubernetes:** If container orchestration needs exceed Portainer capabilities (likely post-MVP)
- **Upgrade monitoring:** When basic health checks prove insufficient for troubleshooting

**Technology Evolution Decision Points:**
- **Add Portainer:** When managing 3+ services becomes unwieldy with Docker Compose alone
- **Add Consul:** When service count reaches 5+ or service-to-service communication requires discovery
- **Consider Kubernetes:** If container orchestration needs exceed Portainer capabilities (likely post-MVP)
- **Upgrade monitoring:** When basic health checks prove insufficient for troubleshooting