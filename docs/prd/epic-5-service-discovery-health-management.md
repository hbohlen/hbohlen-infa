# Epic 5: Service Discovery & Health Management

**Epic Goal:** Introduce Consul for automatic service discovery and health checking when service count reaches 5+ services, demonstrating production-grade distributed system patterns and operational monitoring. This epic transforms manual service coordination into automated service mesh patterns while providing deep learning in distributed systems architecture.

### Story 5.1: Consul Deployment and Service Registry Foundation

As an infrastructure learning developer,
I want to deploy Consul for service discovery and establish a service registry,
so that I can learn distributed system coordination patterns and automated service registration in production-like environments.

#### Acceptance Criteria
1. Consul server deployed on primary gateway VPS with persistent storage and clustering preparation
2. Consul agents installed on all VPS nodes with secure communication via Tailscale network
3. Basic service registration configured for existing services (FalkorDB Browser, Portainer, test services)
4. Consul web UI accessible via consul.hbohlen.io with SSL termination through Caddy reverse proxy
5. Service discovery DNS interface configured and tested for basic service name resolution
6. Consul security configuration implemented with ACL system and encryption for production patterns
7. Service registration automation documented and integrated with existing deployment workflows

### Story 5.2: Health Checking and Service Monitoring Integration

As an infrastructure learning developer,
I want comprehensive health checking and service monitoring through Consul,
so that I can learn production service reliability patterns and automated failure detection across distributed infrastructure.

#### Acceptance Criteria
1. Health checks configured for all registered services with HTTP, TCP, and script-based validation methods
2. Service health status integrated with Portainer monitoring dashboards for unified operational view
3. Health check failure alerting configured with notification workflows for service degradation
4. Service dependency mapping documented showing inter-service communication patterns and health relationships
5. Automatic service deregistration configured for failed services with manual override capabilities
6. Health check performance optimization implemented to minimize monitoring overhead on VPS resources
7. Health monitoring best practices documented with troubleshooting procedures for common failure scenarios

### Story 5.3: Advanced Service Discovery and Load Balancing

As an infrastructure learning developer,
I want advanced service discovery patterns integrated with load balancing and traffic management,
so that I can learn enterprise-grade service mesh concepts while maintaining infrastructure simplicity.

#### Acceptance Criteria
1. Caddy reverse proxy integrated with Consul service discovery for automatic routing configuration
2. Load balancing patterns implemented and documented for services with multiple instances
3. Service discovery integration with GitOps deployment pipeline for automatic service registration
4. Traffic management policies configured for service routing, failover, and maintenance scenarios
5. Service-to-service communication patterns documented and implemented via Consul Connect preparation
6. Performance monitoring integrated to track service discovery latency and resolution accuracy
7. Service mesh learning documentation created comparing Consul patterns with enterprise solutions

### Story 5.4: Operations Excellence and Distributed Systems Learning

As an infrastructure learning developer,
I want comprehensive operational procedures and advanced distributed systems learning documentation,
so that I can master service discovery operations and share knowledge about production-grade service coordination.

#### Acceptance Criteria
1. Consul cluster operations documented including backup, recovery, and scaling procedures for multi-node scenarios
2. Distributed systems troubleshooting runbook created for service discovery failures and network partitions
3. Service discovery performance optimization documented with capacity planning for service growth
4. Security best practices implemented and documented for service-to-service authentication and authorization
5. Disaster recovery procedures created and tested for complete Consul infrastructure restoration
6. Advanced service discovery patterns documented comparing DNS, service mesh, and API gateway approaches
7. Knowledge sharing documentation prepared showing distributed systems patterns and production lessons learned