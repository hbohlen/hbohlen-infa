# MVP Scope

### Core Features (Must Have)

- **Hub-Spoke Architecture:** Primary gateway VPS managing external access with 2-3 spoke nodes for services - *Essential for demonstrating distributed infrastructure patterns and learning multi-VPS management*
- **Tailscale Mesh Networking:** Secure, automatic networking between all VPS instances - *Critical for understanding modern networking without VPN complexity*
- **Service Discovery with Consul:** Automatic service registration and discovery across nodes - *Fundamental production pattern for learning microservices architecture*
- **Domain-Based Access with Caddy:** *.hbohlen.io subdomain routing to services - *Enables professional access patterns and SSL termination*
- **Container Management with Portainer:** Web-based Docker management across all nodes - *Provides practical container orchestration learning without Kubernetes complexity*
- **Basic GitOps Deployment:** Automated deployment triggered by repository pushes - *Teaches CI/CD fundamentals through practical implementation*

### Out of Scope for MVP

- Advanced monitoring and alerting systems (DataDog, Prometheus/Grafana)
- Multi-region or multi-cloud deployment capabilities
- Enterprise security features (advanced access controls, audit logging)
- Complex scaling and load balancing beyond basic Docker features
- Integration with enterprise tools (Jira, Slack, etc.)
- Advanced backup and disaster recovery automation
- Performance optimization and caching layers
- User authentication and authorization systems
- API gateways and rate limiting
- Advanced networking features (VPC peering, advanced firewall rules)

### MVP Success Criteria

The MVP will be considered successful when:
1. **Infrastructure Foundation:** All core services (Caddy, Consul, Portainer) are operational across the hub-spoke architecture with 99% uptime
2. **Service Deployment:** At least 3 services (FalkorDB Browser, basic MCP server, and one additional service) can be deployed automatically via Git push
3. **Domain Access:** All services are accessible via clean domain names (*.hbohlen.io) with automatic SSL certificates
4. **Learning Documentation:** Core infrastructure concepts are documented with practical examples and troubleshooting guides
5. **Operational Stability:** Infrastructure requires less than 4 hours/week of manual maintenance and can recover from basic failures within 30 minutes