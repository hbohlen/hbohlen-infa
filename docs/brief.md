# Project Brief: hbohlen.io Personal Cloud

## Executive Summary

The hbohlen.io Personal Cloud is a semi-production level multi-VPS infrastructure project designed as a learning platform to understand production system interworkings. This solution creates a robust personal cloud environment for hosting development tools and services, with an emphasis on educational value and practical application for personal projects.

The primary problem being solved is the need for a structured approach to managing personal cloud infrastructure while learning production-level concepts and best practices. Rather than building enterprise-grade systems, the focus is on creating functional, educational infrastructure that demonstrates key production patterns.

The target users are primarily the project owner (a developer interested in infrastructure) who wants to learn production concepts through hands-on implementation, while also providing practical cloud services for personal development projects.

The key value proposition is a learning-focused infrastructure that balances production-like reliability with educational insights, enabling the exploration of modern cloud patterns, service discovery, container orchestration, and automated deployment workflows in a personal context.

## Problem Statement

**Current State and Pain Points:**
The project owner currently maintains multiple VPS instances (Hetzner primary gateway, Digital Ocean service node, with plans for additional VPS) that are managed in isolation. Each VPS requires individual configuration, manual service deployment, and separate networking setup. Personal development services like FalkorDB Browser and custom MCP servers are deployed ad-hoc without unified management, leading to inconsistent configurations and maintenance overhead.

**Impact of the Problem:**
This fragmented approach creates significant operational complexity and learning barriers. Without proper service discovery, automated deployment, and unified networking, scaling personal projects becomes cumbersome. The lack of production-like patterns means valuable learning opportunities are missed, and the infrastructure becomes increasingly difficult to maintain as more services are added. There's also no clear "story" or narrative connecting the various infrastructure components, making it harder to understand the system as a cohesive whole.

**Why Existing Solutions Fall Short:**
Traditional VPS management tools focus on enterprise-scale deployments and are overkill for personal learning projects. Simple hosting solutions lack the educational depth needed to understand production interworkings. Personal cloud platforms are either too abstracted (hiding learning opportunities) or too complex for individual developers wanting to learn infrastructure patterns. Most solutions don't provide the narrative context needed to understand how infrastructure components interconnect and evolve.

**Urgency and Importance:**
As personal projects grow in complexity (adding GraphITI MCP server integration, multiple development databases, and custom services), the current approach becomes unsustainable. Learning production concepts through hands-on implementation is time-sensitive, and establishing proper infrastructure patterns now will prevent technical debt accumulation and enable faster future development. The need for better infrastructure storytelling becomes more critical as the system grows beyond simple VPS management.

## Proposed Solution

**Core Concept and Approach:**
The hbohlen.io Personal Cloud implements a hub-spoke architecture with a primary gateway VPS managing external access and multiple spoke nodes handling specific services. This creates a resilient, scalable infrastructure that tells a clear "infrastructure story" - from external requests through secure networking to individual service execution.

**Key Differentiators from Existing Solutions:**
Unlike traditional VPS management or simple hosting platforms, this solution provides:
- **Infrastructure Storytelling:** Visual narratives showing how services interconnect and evolve
- **Learning-Focused Design:** Production patterns implemented with educational transparency
- **Hybrid Development Workflow:** Production-like local development with rapid iteration
- **Domain-Based Service Access:** Clean URLs (falkordb.hbohlen.io, mcp.hbohlen.io/{service}) instead of IP addresses

**Why This Solution Will Succeed:**
The hub-spoke pattern ensures no single point of failure while maintaining centralized management. Tailscale provides secure mesh networking without complex VPN configuration. The domain-based approach creates professional service access patterns. Most importantly, the infrastructure tells its own story through clear service discovery, automated deployment, and visual monitoring - making it an excellent learning platform for production concepts.

**High-Level Vision:**
Imagine pushing code to your repository and watching as:
1. Your commit triggers automated container builds
2. Services register themselves with the discovery system
3. The reverse proxy automatically routes traffic to the new service
4. Everything becomes accessible at a clean domain name
5. The infrastructure "remembers" this story for future reference and debugging

**Resource and Architecture Approach:**
The solution implements a hub-spoke architecture with Hetzner as the cost-effective primary gateway (2 vCPU, 4GB RAM) and service nodes (1-2 vCPU, 2-4GB RAM each), balancing learning opportunities with practical resource allocation. This approach prioritizes educational value (70% focus) while maintaining production reliability (30% focus), using Tailscale for secure networking and domain-based access for professional service presentation.

The solution balances automation with manual learning opportunities, embracing some complexity as an investment in understanding production interworkings through hands-on experience.

## Target Users

### Primary User Segment: Infrastructure Learning Developer

**Demographic/Firmographic Profile:**
- Individual developer with 5+ years of software development experience
- Self-employed or working on personal projects
- Technical background with interest in DevOps/infrastructure
- Age 25-40, located in technical communities/hubs

**Current Behaviors and Workflows:**
- Maintains multiple VPS instances across different providers manually
- Deploys personal projects using ad-hoc methods (direct server access, basic Docker)
- Learns new technologies through personal projects and experimentation
- Documents learnings through personal notes and code repositories
- Balances learning time with project delivery needs

**Specific Needs and Pain Points:**
- Need structured way to learn production infrastructure patterns without enterprise complexity
- Struggle with managing multiple VPS instances consistently
- Want to understand service discovery, container orchestration, and automated deployment
- Frustrated by fragmented infrastructure that becomes unmanageable as projects grow
- Desire professional-grade tooling without enterprise pricing/licensing

**Goals They're Trying to Achieve:**
- Build comprehensive understanding of modern infrastructure patterns
- Create reliable platform for personal development projects
- Develop portfolio-worthy infrastructure projects
- Establish foundation for potential future consulting/freelance work
- Maintain work-life balance while pursuing technical growth

### Secondary User Segment: Fellow Developers (Optional)

**Demographic/Firmographic Profile:**
- Other developers in personal network or online communities
- Similar technical background (3-10 years experience)
- Interest in infrastructure but not primary focus
- May include collaborators on shared projects

**Current Behaviors and Workflows:**
- Use simple hosting solutions or single VPS for personal projects
- Learn infrastructure concepts through tutorials and documentation
- Participate in open source projects with varying infrastructure complexity
- Share knowledge through blogs, talks, or community discussions

**Specific Needs and Pain Points:**
- Want to see real-world infrastructure examples without enterprise context
- Need accessible learning resources for production concepts
- Struggle to find balance between learning and project delivery
- Limited access to production-like environments for experimentation

**Goals They're Trying to Achieve:**
- Learn modern infrastructure patterns through practical examples
- Build confidence in infrastructure decision-making
- Contribute to or learn from open infrastructure projects
- Network with other developers interested in infrastructure

## Goals & Success Metrics

### Learning Journey + OKR Hybrid Framework

**Overall Objective:** Master production infrastructure patterns through personal cloud implementation

**Phase 1 (Foundation - Months 1-2):** Establish core infrastructure and learn fundamental patterns
**Phase 2 (Integration - Months 3-4):** Deploy services and automate workflows
**Phase 3 (Optimization - Months 5-6):** Refine systems and document learnings

### Key Results by Phase

**Phase 1 Key Results:**
- Deploy functional hub-spoke infrastructure with Tailscale networking
- Successfully implement service discovery with Consul
- Achieve domain-based access for core services
- Document 6 infrastructure concepts with practical examples

**Phase 2 Key Results:**
- Launch 5 services with automated deployment pipelines
- Reduce manual deployment time from 2 hours to 15 minutes
- Maintain 99% uptime for core infrastructure services
- Create troubleshooting guides for common issues

**Phase 3 Key Results:**
- Optimize resource usage and reduce management time by 60%
- Implement monitoring and alerting for all services
- Document complete infrastructure setup and operation procedures
- Apply learned patterns to new service deployments

### Technical & Learning Metrics

**Technical Performance:**
- **Service Availability:** 99.5% uptime for core infrastructure (Caddy, Consul, Portainer)
- **Deployment Success Rate:** 95% of automated deployments complete without intervention
- **Mean Time to Recovery:** < 30 minutes for critical service incidents
- **Resource Efficiency:** < 3 hours/week on infrastructure maintenance

**Learning Achievement:**
- **Concept Mastery:** Demonstrate practical understanding of 12 core infrastructure patterns
- **Documentation Quality:** Create comprehensive guides covering setup, operation, and troubleshooting
- **Knowledge Application:** Successfully apply patterns to 5+ new services
- **Problem-Solving Growth:** Reduce time to resolve novel infrastructure issues by 70%

**Infrastructure Maturity Progression:**
- **Current:** Manual VPS management and ad-hoc deployments
- **Phase 1 Target:** Automated container orchestration with basic monitoring
- **Phase 2 Target:** Full service discovery and domain-based routing
- **Phase 3 Target:** Self-documenting infrastructure with predictive maintenance

## MVP Scope

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

## Post-MVP Vision

### Phase 2 Features

**Advanced Service Capabilities:**
- Custom MCP server framework with dynamic routing (mcp.hbohlen.io/{mcp_name})
- GraphITI MCP server integration for enhanced AI tool capabilities
- Service health monitoring and basic alerting through Consul
- Automated backup and recovery procedures for critical services
- Enhanced deployment pipelines with testing and rollback capabilities

**Infrastructure Enhancements:**
- Multi-node Portainer deployment for better container management
- Advanced Caddy configurations with custom middleware and routing rules
- Doppler secrets management integration across all services
- Basic monitoring dashboard for infrastructure health and performance
- Documentation automation that updates with infrastructure changes

### Long-term Vision (1-2 Years)

**Intelligent Infrastructure:**
- AI-assisted infrastructure optimization recommendations
- Predictive scaling based on usage patterns and service demands
- Automated incident response and self-healing capabilities
- Infrastructure "storytelling" features that visualize system evolution
- Advanced security monitoring and threat detection

**Service Ecosystem:**
- Marketplace for personal infrastructure "recipes" and service templates
- Collaborative development environment for multi-developer projects
- Integration with development tools (IDEs, version control, project management)
- API gateway for service-to-service communication and external access
- Advanced networking features including VPN alternatives and network segmentation

**Learning and Knowledge Platform:**
- Interactive learning modules that evolve with infrastructure changes
- Community features for sharing infrastructure patterns and solutions
- Advanced documentation with AI-generated explanations and examples
- Portfolio generation tools that showcase infrastructure projects
- Mentorship and knowledge transfer capabilities for other developers

### Expansion Opportunities

**Service Integrations:**
- Development tool integrations (GitHub, VS Code, JetBrains IDEs)
- Communication platform integrations (Slack, Discord, email)
- Project management tool connections (Jira, Trello, Linear)
- Cloud service integrations (AWS, GCP, Azure for hybrid scenarios)
- Database and storage service expansions

**Platform Extensions:**
- Mobile application for infrastructure monitoring and management
- Browser extensions for service access and management
- Desktop applications for local development workflow integration
- API ecosystem for third-party tool integrations
- White-label solutions for other developers or organizations

**Advanced Infrastructure Patterns:**
- Multi-region deployment capabilities for global service distribution
- Serverless function integration for event-driven services
- Advanced container orchestration with Kubernetes exploration
- Edge computing capabilities for low-latency service delivery
- Blockchain integration for decentralized service management

**Community and Collaboration:**
- Open-source infrastructure pattern library
- Developer community platform for knowledge sharing
- Educational content creation and distribution
- Consulting and professional service offerings
- Partnership opportunities with infrastructure tool providers

## Technical Considerations

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

## Constraints & Assumptions

### Constraints

**Detailed Budget Breakdown:**
- **Monthly Infrastructure Costs:** €50-100 (Hetzner: €6-8, Digital Ocean: €12-15, domain: €10-15/year)
- **One-time Setup Costs:** €20-70 (VPS configuration, premium support if needed)
- **Ongoing Operational Costs:** €5-30/month (bandwidth, backups, tool upgrades)
- **Weekly Time Commitment:** 10-15 hours technical work, 3-5 hours learning/documentation, 2-3 hours planning/research

**Timeline Breakdown:**
- **Phase 1 (Months 1-2):** Repository setup, VPS configuration, basic service deployment
- **Phase 2 (Months 3-4):** Multiple services, automation, performance testing
- **Phase 3 (Months 5-6):** Optimization, monitoring, final documentation

**Technical Skill Requirements:**
- **Current Skills Assumed:** Basic Linux, Docker, Git, networking concepts
- **Skills to Develop:** Advanced Docker Compose, Consul configuration, Caddy setup, Tailscale networking, Infrastructure as Code

### Key Assumptions

- Technology choices (Caddy, Consul, Portainer) will prove suitable for learning production patterns without excessive complexity
- Personal learning pace will allow mastery of core infrastructure concepts within the 6-month timeframe
- VPS providers will maintain stable service levels and pricing
- Open-source tools will continue to be available and supported
- Domain and SSL certificate management will work reliably with chosen infrastructure
- Manual processes can be gradually automated as skills develop
- Community resources and documentation will be sufficient for troubleshooting
- Personal projects will provide adequate real-world testing scenarios

**Assumption Validation Checklist:**
- [ ] Caddy's learning curve is manageable for reverse proxy needs
- [ ] Portainer provides sufficient container orchestration for personal use
- [ ] Doppler's free tier meets secrets management requirements
- [ ] Tailscale's free tier supports the planned network topology
- [ ] 10-15 hours/week is sufficient for infrastructure learning and implementation
- [ ] Online documentation and community support will resolve most issues
- [ ] Personal projects will provide adequate testing scenarios
- [ ] VPS providers maintain 99.9% uptime for critical infrastructure

## Risks & Open Questions

### Key Risks

- **Learning Curve Overload:** Trying to master Consul, Caddy, Portainer, and Tailscale simultaneously - *Impact: Cognitive overload, incomplete understanding, project delays* - *Mitigation: Focus on one technology per week, use "spike" sessions for exploration*
- **Technology Choice Regrets:** Portainer proves insufficient for complex orchestration needs - *Impact: Need to migrate to Kubernetes mid-project, significant rework* - *Mitigation: Evaluate Kubernetes learning curve early, have migration plan ready*
- **Cost Creep:** Underestimating bandwidth costs for data-intensive services - *Impact: Unexpected monthly bills, budget overruns* - *Mitigation: Set bandwidth monitoring alerts, implement caching strategies*
- **Security Vulnerabilities:** Initial configurations prioritize functionality over security - *Impact: Exposed services, potential data breaches* - *Mitigation: Follow security checklists, implement least-privilege access*
- **Vendor Dependency:** Heavy reliance on third-party services (Tailscale, Doppler) creates single points of failure - *Impact: Service disruption if providers change terms or have outages* - *Mitigation: Monitor provider status, have backup networking options*
- **Time Commitment Underestimation:** Infrastructure learning and maintenance might require more time than allocated - *Impact: Burnout, delayed project completion* - *Mitigation: Regular progress reviews, flexible timeline adjustments*

### Open Questions

- How does Consul's performance compare when managing 10+ services?
- What are the operational overheads of Consul vs simpler DNS-based discovery?
- How reliable is Consul's self-healing in network partition scenarios?
- What are Tailscale's limitations for production service communication?
- How does Tailscale performance degrade with 5+ nodes?
- What are the real-world bandwidth costs for typical web services?
- At what point does the hub-spoke architecture become a bottleneck?
- How does Caddy performance scale with 20+ service routes?

### Areas Needing Further Research

- Comparative analysis of service discovery alternatives (Consul vs etcd vs ZooKeeper)
- Performance benchmarking of Tailscale vs traditional VPN solutions
- Cost optimization strategies for multi-VPS personal infrastructure
- Security best practices for personal cloud deployments
- Container orchestration learning paths and resource recommendations
- Domain management and SSL automation at scale
- Monitoring and alerting strategies for personal infrastructure
- VPS provider performance comparison for container workloads