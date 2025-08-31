# ADR-002: Hub-Spoke vs Full Mesh Architecture

## Status
Accepted

## Context
For the hbohlen.io Personal Cloud, we need to decide between a hub-spoke architecture (central gateway + service nodes) versus a full mesh architecture (all nodes equal) for the VPS infrastructure design.

## Decision
We will implement a **hub-spoke architecture** with Hetzner as the primary gateway and DigitalOcean/Azure as service nodes.

## Options Considered

### Option 1: Hub-Spoke Architecture (Selected)
- **Structure:** Central gateway (Hetzner) + 2-3 service nodes (DigitalOcean, Azure)
- **Traffic Flow:** External → Gateway → Service Nodes via Tailscale
- **Management:** Centralized reverse proxy, service discovery server, orchestration

### Option 2: Full Mesh Architecture
- **Structure:** All nodes equal with distributed coordination
- **Traffic Flow:** External → Any Node → Service Location via mesh routing
- **Management:** Distributed coordination, multiple entry points

### Option 3: Hybrid Mesh
- **Structure:** Regional hubs with mesh interconnection
- **Traffic Flow:** Regional routing with cross-region mesh
- **Management:** Multi-hub coordination with regional optimization

## Rationale for Hub-Spoke Selection

### Learning Objectives Alignment
- **Complexity Management:** Single entry point simplifies initial learning while demonstrating production patterns
- **Clear Patterns:** Hub-spoke is common in enterprise environments (AWS Transit Gateway, Azure Hub-Spoke)
- **Troubleshooting:** Centralized routing makes network troubleshooting more approachable for learning
- **Progressive Complexity:** Can evolve toward mesh patterns as understanding develops

### Cost Efficiency
- **Resource Optimization:** Gateway node (2 vCPU, 4GB) handles coordination, service nodes (1-2 vCPU) optimized for workloads
- **Provider Selection:** Hetzner gateway (€8/month) + DigitalOcean services (credits available) maximizes value
- **SSL Termination:** Single point for certificate management reduces complexity and cost

### Operational Benefits
- **Single Configuration Point:** Caddy reverse proxy configuration centralized for easier management
- **Monitoring Simplification:** Primary monitoring agents on gateway with forwarding to service nodes
- **Security:** Single external access point simplifies security configuration and audit
- **Backup Strategy:** Centralized backup coordination from gateway node

### Technical Implementation
- **Tailscale Integration:** Hub-spoke works naturally with Tailscale mesh networking
- **Consul Deployment:** Single Consul server on gateway with agents on service nodes
- **Portainer Architecture:** Portainer server on gateway managing agents on service nodes
- **Load Balancing:** Gateway can implement load balancing across multiple service instances

## Consequences

### Positive
- **Learning Clarity:** Clear separation between coordination (gateway) and execution (service nodes)
- **Cost Efficiency:** Optimized resource allocation between gateway and service functions
- **Operational Simplicity:** Single point of external access and configuration management
- **Enterprise Relevance:** Common pattern in production environments provides transferable learning

### Negative
- **Single Point of Failure:** Gateway node failure affects all external access
- **Potential Bottleneck:** Gateway bandwidth and processing may limit scalability
- **Complexity Evolution:** May need to refactor toward mesh as system grows
- **Provider Dependency:** Gateway tied to specific provider (Hetzner) for cost optimization

### Risk Mitigation
- **High Availability Planning:** Document gateway failover procedures using DigitalOcean backup
- **Performance Monitoring:** Comprehensive gateway monitoring to detect bottlenecks early
- **Evolution Path:** Clear migration strategy to mesh architecture if hub-spoke limits growth
- **Provider Diversification:** Azure experimentation node provides multi-provider experience

## Implementation Details

### Gateway Node Responsibilities
- **External Access:** Caddy reverse proxy with SSL termination
- **Service Discovery:** Consul server for service coordination
- **Container Orchestration:** Portainer server for multi-node management
- **Monitoring Coordination:** Primary Datadog/New Relic agents with aggregation
- **Configuration Management:** Doppler integration point for secrets distribution

### Service Node Responsibilities
- **Service Execution:** Docker containers running actual services (FalkorDB, MCP servers)
- **Health Reporting:** Consul agents reporting to gateway server
- **Local Monitoring:** Monitoring agents sending data to enterprise tools
- **Configuration Consumption:** Doppler configuration synchronization

### Network Architecture
- **External Traffic:** Internet → Cloudflare DNS → Hetzner Gateway Public IP
- **Internal Traffic:** Gateway → Tailscale Mesh → Service Nodes
- **Management Traffic:** All management interfaces (Portainer, Consul) via gateway
- **Monitoring Traffic:** Service nodes → Enterprise monitoring tools via gateway coordination

## Evolution Strategy

### Phase 1: Basic Hub-Spoke (Weeks 1-8)
- Single gateway, single service node
- Basic routing and monitoring
- Learn fundamental patterns

### Phase 2: Multi-Node Hub-Spoke (Weeks 9-16)
- Add second service node (Azure experimentation)
- Load balancing across service nodes
- Advanced monitoring and alerting

### Phase 3: Mesh Preparation (Weeks 17-24)
- Document mesh migration path
- Implement distributed coordination experiments
- Evaluate migration triggers and benefits

### Future Evolution Triggers
- **Gateway Bottleneck:** When gateway CPU consistently >80% or latency >100ms
- **Provider Limitations:** When single provider limits expansion or learning
- **Learning Objectives:** When mesh patterns become primary learning focus
- **Service Complexity:** When service-to-service communication exceeds hub-spoke efficiency

## Review Criteria
- **Performance:** Gateway performance monitored via Datadog with alerting at 80% resource utilization
- **Learning Progress:** Hub-spoke patterns mastered before considering mesh evolution
- **Cost Efficiency:** Architecture maintains cost targets while delivering learning value
- **Operational Complexity:** Architecture remains manageable within time allocation

This hub-spoke decision provides optimal balance of learning value, cost efficiency, and operational simplicity while maintaining clear evolution paths as the system and understanding mature.