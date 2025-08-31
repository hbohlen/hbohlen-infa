# Epic 2: Professional Service Access

**Epic Goal:** Deploy Caddy reverse proxy with domain-based routing (*.hbohlen.io) and SSL automation while deploying the first real service, demonstrating modern web service access patterns and distributed service routing. This epic transforms basic infrastructure into a professional-grade service platform with live, accessible services.

### Story 2.1: Caddy Deployment and SSL Foundation

As an infrastructure learning developer,
I want to deploy Caddy as a reverse proxy with automated SSL certificate management,
so that I can establish professional domain-based service access with HTTPS automation.

#### Acceptance Criteria
1. Caddy installed and configured on primary gateway VPS (Hetzner)
2. DNS A record configured pointing *.hbohlen.io to gateway VPS public IP
3. Basic Caddyfile configuration created for domain routing with SSL automation
4. Simple test service accessible via test.hbohlen.io with automatic HTTPS from Let's Encrypt
5. SSL certificate automatically obtained and verified as valid with proper chain
6. HTTP to HTTPS redirection working correctly for all configured domains
7. Caddy access and error logs configured and accessible for troubleshooting

### Story 2.2: First Service Deployment and Routing

As an infrastructure learning developer,
I want to deploy FalkorDB Browser on my service node and route traffic to it through Caddy,
so that I can learn distributed service deployment and cross-node routing patterns with a real application.

#### Acceptance Criteria
1. FalkorDB Browser container deployed and running on service node VPS (Digital Ocean)
2. Caddy configured to route falkordb.hbohlen.io to FalkorDB Browser via Tailscale network
3. FalkorDB Browser accessible externally through HTTPS with proper SSL termination
4. Service health verification and basic connectivity testing procedures documented
5. Traffic flow documentation created showing external request → Caddy → Tailscale → service path
6. Container deployment procedures documented for future service deployments
7. Basic service monitoring configured (container status, response time logging)

### Story 2.3: Advanced Routing Patterns and Monitoring

As an infrastructure learning developer,
I want to implement advanced routing patterns and comprehensive monitoring,
so that I can learn production-grade reverse proxy configuration and operational observability.

#### Acceptance Criteria
1. Load balancing configuration documented and tested with multiple backend scenarios
2. Health check configuration implemented for upstream service availability monitoring
3. Advanced routing scenarios documented (subdomain routing, path-based routing, upstream failures)
4. Traffic flow diagrams created showing different routing patterns and failure modes
5. Performance monitoring configured (response times, error rates, traffic patterns)
6. Caddy configuration validation and zero-downtime reload procedures documented and tested
7. Troubleshooting runbook created for common routing and SSL issues

### Story 2.4: Certificate Management and Operations Automation

As an infrastructure learning developer,
I want fully automated certificate management and operational procedures,
so that I can maintain production-grade HTTPS services with minimal manual intervention.

#### Acceptance Criteria
1. Let's Encrypt certificate renewal automation configured and tested with staging environment
2. Certificate expiration monitoring configured with alerts (30-day and 7-day warnings)
3. Certificate backup and recovery procedures documented and validated
4. Graceful service restart and configuration reload procedures documented
5. Caddy log analysis procedures and tools documented for operational troubleshooting
6. Integration with infrastructure-as-code repository for version-controlled configuration management
7. Service dependency documentation created (DNS, Let's Encrypt, Tailscale, upstream services)