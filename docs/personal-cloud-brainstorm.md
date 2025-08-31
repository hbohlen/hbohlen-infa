# Personal Multi-VPS Infrastructure Brainstorming Session

Date: August 30, 2025 Goal: Design a robust personal cloud infrastructure
spanning multiple VPS instances with Tailscale networking, domain-based service
access, and automated deployment workflows.

## 🎯 Project Overview

### Objective

Create a seamless, secure personal cloud infrastructure spanning multiple VPS
instances with:

• Tailscale networking for security and connectivity
• Domain-based service access (*.hbohlen.io)
• Container orchestration and management
• Secrets management
• Easy deployment and scaling

### Current Resources

• Hetzner VPS (Primary Gateway)
• Digital Ocean Droplet (Service Node)
• Future VPS instances (Expandable)
• Domain: hbohlen.io with wildcard DNS
• Repository: github.com/hbohlen/hbohlen-io

### Key Use Cases

1. FalkorDB Browser: Accessible at falkordb.hbohlen.io for GraphITI MCP server
integration
2. Custom MCP Servers: Hosted at mcp.hbohlen.io/{mcp_name} with HTTPS access
3. Personal Development Services: Various tools and databases for projects

## 🏗️ Final Architecture Design

### Hybrid Hub-Spoke Pattern

                     Internet (*.hbohlen.io)
                            |
                    [Primary Gateway - Hetzner]
                    ┌─────────────────────────┐
                    │ • Caddy (SSL termination│
                    │ • TSDProxy coordinator  │
                    │ • DNS management        │
                    │ • Health monitoring     │
                    │ • Consul (service disc.)│
                    │ • Primary Portainer     │
                    └─────────────────────────┘
                            |
                    [Tailscale Mesh Network]
                    /           |           \
        [Hetzner Node 2]   [DO Droplet]   [Future VPS]
        ┌─────────────┐    ┌─────────────┐ ┌─────────────┐
        │ • Services  │    │ • Services  │ │ • Services  │
        │ • Local     │    │ • Local     │ │ • Local     │
        │   Caddy     │    │   Caddy     │ │   Caddy     │
        │ • Portainer │    │ • Portainer │ │ • Portainer │
        │   Agent     │    │   Agent     │ │   Agent     │
        │ • Consul    │    │ • Consul    │ │ • Consul    │
        │   Agent     │    │   Agent     │ │   Agent     │
        └─────────────┘    └─────────────┘ └─────────────┘

### Architecture Benefits

• No single point of failure - Services continue running even if primary gateway
has issues
• Graceful degradation - Can temporarily route traffic directly to secondary
nodes
• Independent scaling - Each VPS can handle its own load independently
• Easier maintenance - Update/restart nodes without full system downtime
• Logical service grouping - Related services on same VPS nodes
• Future-proof - Easy to add new VPS nodes as projects grow

## 🛠️ Technology Stack

### Selected Tools & Reasoning

 Component            │ Tool      │ Reasoning                    │ Fit
──────────────────────┼───────────┼──────────────────────────────┼────────────
 Reverse Proxy        │ Caddy +   │ Auto-HTTPS, Simple config,   │ ⭐⭐⭐⭐⭐
                      │  TSDProxy │ Tailscale                    │
                      │           │  integration                 │
                      │           │                              │
 Service Discovery    │ Consul    │ Self-healing, health         │ ⭐⭐⭐⭐⭐
                      │           │ monitoring, configuration    │
                      │           │  sharing                     │
                      │           │                              │
 Container Management │ Portainer │ Multi-node, excellent UI,    │ ⭐⭐⭐⭐⭐
                      │           │ stack                        │
                      │           │  deployment                  │
                      │           │                              │
 Secrets Management   │ Doppler   │ SaaS convenience, excellent  │ ⭐⭐⭐⭐⭐
                      │           │ Docker                       │
                      │           │  integration                 │
                      │           │                              │
 Networking           │ Tailscale │ Secure mesh, easy setup,     │ ⭐⭐⭐⭐⭐
                      │           │ great for personal           │
                      │           │  use                         │
                      │           │                              │


### Service Discovery with Consul

What Consul Does:

• Service Registry: Automatically tracks what services are running where
• Health Checking: Monitors service health and removes unhealthy instances
• Configuration Management: Shares configuration across all nodes
• Self-healing: Services appear/disappear without manual intervention

Example Flow:

1. Deploy FalkorDB with service registration
2. FalkorDB tells Consul: "I'm healthy at hetzner-node:8080"
3. Caddy asks Consul: "Where's FalkorDB?" and auto-updates routing
4. If FalkorDB fails, Consul removes it and Caddy stops routing there

## 🚀 Development Workflow

### Hybrid Approach: Production-like + Development Speed

• Production accuracy: Same containers, networks, and service discovery as
production
• Development speed: Volume mounts, hot reload, fast rebuilds, enhanced logging
• Best of both worlds: Confidence in deployments + rapid iteration

### Development Commands

# Start local development (production-like with hot reload)
./scripts/dev-start.sh falkordb-browser
# → Available at http://localhost via Caddy
# → Consul UI at http://localhost:8500
# → Hot reload enabled

# Test exactly like production
./scripts/dev-test.sh falkordb-browser
# → Builds production containers locally
# → Tests service registration with Consul
# → Validates routing through Caddy

# Deploy to production
git add . && git commit -m "feat: add falkordb browser"
git push origin main
# → Webhook triggers deployment
# → Available at https://falkordb.hbohlen.io

### Deployment Pipeline

Git Push → Webhook → Portainer → Deploy → Consul Registration → Live Service

## 📁 Repository Structure

### Monorepo Layout for github.com/hbohlen/hbohlen-io

hbohlen-io/
├── .bmad-core/                    # Existing agent system (keep as-is)
│   ├── agents/
│   └── [existing structure]
├── personal-cloud/                # New: Infrastructure code
│   ├── infrastructure/
│   │   ├── docker-compose.yml     # Core infrastructure stack
│   │   ├── consul/                # Service discovery config
│   │   ├── caddy/                 # Reverse proxy config
│   │   └── portainer/             # Container management
│   ├── services/
│   │   ├── falkordb-browser/
│   │   │   ├── docker-compose.dev.yml
│   │   │   ├── docker-compose.prod.yml
│   │   │   ├── Dockerfile.dev
│   │   │   └── config/
│   │   └── mcp-server/
│   │       ├── docker-compose.dev.yml
│   │       ├── docker-compose.prod.yml
│   │       ├── src/
│   │       └── Dockerfile
│   └── scripts/
│       ├── dev-start.sh           # Local development
│       ├── dev-test.sh            # Pre-deployment testing
│       ├── deploy.sh              # Production deployment
│       └── setup-infrastructure.sh # Initial setup
├── docs/                          # Documentation
│   └── personal-cloud-brainstorm.md # This document
└── [existing files]               # Keep as-is

## 🔧 Implementation Roadmap

### Phase 1: Foundation Setup (This Weekend)

1. Repository Setup
 • Create directory structure in existing hbohlen-io repo
 • Set up core infrastructure stack configuration
2. Core Infrastructure Stack
 • Consul server for service discovery
 • Caddy for reverse proxy with auto-HTTPS
 • Portainer for container management
 • Basic networking configuration
3. Local Development Environment
 • Docker Compose setup for local testing
 • Development scripts for easy service management


### Phase 2: First Service - FalkorDB Browser (Next Week)

1. Service Development
 • Create FalkorDB browser service structure
 • Configure both development and production environments
 • Implement service registration with Consul
2. Local Development Test
 • Test full local development workflow
 • Validate service discovery and routing
 • Ensure hot reload functionality works
3. Production Deployment
 • Deploy infrastructure to Hetzner VPS
 • Set up Tailscale mesh networking
 • Deploy first service end-to-end


### Phase 3: MCP Server (Week 3)

1. Custom MCP Server Development
 • Build custom MCP server application
 • Implement dynamic routing for multiple MCPs
 • Configure mcp.hbohlen.io/{mcp_name} pattern
2. Integration Testing
 • Test GraphITI MCP server integration
 • Validate HTTPS access patterns
 • End-to-end workflow validation


### Phase 4: Automation & Monitoring (Week 4)

1. Deployment Automation
 • Git webhook integration
 • Automated stack deployment via Portainer
 • Health monitoring and alerting
2. Service Management
 • Backup and recovery procedures
 • Configuration management
 • Monitoring and observability setup


## 🌐 Domain Strategy

### Service Access Patterns

• falkordb.hbohlen.io → FalkorDB Browser
• mcp.hbohlen.io/{mcp_name} → Custom MCP servers
• consul.hbohlen.io → Service discovery UI
• portainer.hbohlen.io → Container management UI

### SSL/TLS Management

• Wildcard certificates for *.hbohlen.io
• Let's Encrypt automatic certificate generation
• Caddy automatic HTTPS for all services

## 🔐 Security & Access Control

### Network Security

• Tailscale ACLs for network-level access control
• Private VPS communication via Tailscale mesh
• Public access only through primary gateway

### Service Security

• Doppler secrets management for environment variables
• Service-level authentication where needed
• Network isolation between services

## 🎯 Integration with Existing Agent System

### Synergy Opportunities

1. Agents can deploy services - Use existing agent system to trigger deployments
2. Services enhance agents - Hosted databases, APIs, tools for agent consumption
3. Shared configuration - Doppler secrets accessible to both systems
4. Unified documentation - Agent system documents personal cloud services

### Example Integration

# Existing agent deploys new MCP server
agent-dev: "Deploy my new MCP server to personal cloud"
# → Builds container
# → Pushes to infrastructure
# → Registers with Consul
# → Available at mcp.hbohlen.io/new-server

## 📋 Immediate Next Steps

### This Week

1. Create repository structure in existing hbohlen-io repo
2. Set up basic infrastructure stack locally to test concept
3. Configure domain DNS to point *.hbohlen.io to primary VPS

### Next Week

4. Deploy infrastructure stack to Hetzner VPS (primary gateway)
5. Set up Tailscale mesh between VPS instances
6. Deploy first service (FalkorDB browser) end-to-end

### Development Focus

• Production-like local development for deployment confidence
• Monorepo approach for unified management
• Service discovery automation with Consul
• Push-to-deploy workflow with local testing capability

## 🧠 Key Insights from Brainstorming

### Architecture Decisions

• Hub-spoke over centralized for resilience and future growth
• Consul over DNS-based discovery for robustness and automation
• Hybrid development approach balancing production accuracy with speed
• Monorepo structure for simplified management and integration

### Tool Selections

• Caddy chosen for simplicity and automatic HTTPS
• Portainer for excellent multi-node container management
• Doppler for SaaS convenience in secrets management
• Tailscale for secure, easy-to-manage mesh networking

### Development Philosophy

• Investment in upfront complexity for long-term stability and learning
• Production-like development to ensure deployment success
• Automation where valuable but manual control for experimentation
• Integration with existing tools rather than replacement