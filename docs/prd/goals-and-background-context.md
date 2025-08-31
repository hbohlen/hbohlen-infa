# Goals and Background Context

### Goals
- Master production infrastructure patterns through hands-on personal cloud implementation
- Create a reliable, scalable platform for hosting personal development tools and services
- Establish professional-grade infrastructure that demonstrates key production concepts
- Build a learning-focused environment that balances educational value with practical functionality
- Develop portfolio-worthy infrastructure projects for future consulting opportunities
- Reduce infrastructure maintenance time from current manual processes to automated workflows

### Background Context
The hbohlen.io Personal Cloud addresses the critical need for structured personal cloud infrastructure management while learning production-level concepts. Currently, multiple VPS instances (Hetzner primary gateway, Digital Ocean service node) are managed in isolation with manual configuration, ad-hoc service deployment, and inconsistent networking setup. Personal development services like FalkorDB Browser and custom MCP servers are deployed without unified management, creating operational complexity and maintenance overhead.

This solution implements a hub-spoke architecture with a primary gateway managing external access and spoke nodes handling specific services, creating a resilient infrastructure that demonstrates production patterns. The focus is on educational value (70%) while maintaining production reliability (30%), using modern tools like Tailscale for secure networking, Consul for service discovery, and domain-based access for professional service presentation.

### Change Log

| Date | Version | Description | Author |
|------|---------|-------------|---------|
| 2025-08-30 | v1.0 | Initial PRD creation based on project brief | John (PM Agent) |