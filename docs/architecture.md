# hbohlen.io Personal Cloud Full-Stack Architecture Document

## Introduction

This document outlines the complete full-stack architecture for the hbohlen.io Personal Cloud, including backend systems, frontend implementation, and their integration. It serves as the single source of truth for AI-driven development, ensuring consistency across the entire technology stack.

This unified approach combines what would traditionally be separate backend and frontend architecture documents, streamlining the development process for modern infrastructure applications where distributed systems, service discovery, and container orchestration are increasingly intertwined. The architecture emphasizes educational value while maintaining production viability, supporting your journey from manual VPS management to automated infrastructure excellence.

### Starter Template Analysis

**N/A - Greenfield Infrastructure Project**

This is a greenfield personal cloud infrastructure project that will be built from scratch using modern DevOps patterns. While not based on a specific starter template, the architecture draws inspiration from:

- **Production Hub-Spoke Patterns:** Similar to AWS Transit Gateway architectures
- **Service Mesh Learning:** Consul Connect patterns for future evolution
- **GitOps Best Practices:** Inspired by ArgoCD and Flux deployment patterns
- **Container Orchestration:** Docker Compose → Portainer → (future Kubernetes) progression

The phased approach allows for technology substitution at each boundary if learning objectives require different tools.

### Resource Enhancement with GitHub Education Pack

**Enhanced Capabilities:**
- **Enterprise Monitoring Stack:** Datadog Pro ($240/month) + New Relic ($300/month) + Sentry ($29/month) - Total $569/month value
- **Advanced Development Tools:** GitHub Codespaces, Travis CI private builds, CodeScene analysis
- **Quality & Testing:** BrowserStack, LambdaTest, Codecov, Blackfire performance profiling  
- **Cloud Experimentation:** Azure $100 credits + Visual Studio Dev Essentials
- **Total Value Accessed:** ~$945/month vs €50-100 actual budget

**Strategic Learning Path:**
- **Weeks 1-8:** Foundation (Core infrastructure + basic monitoring)
- **Weeks 9-16:** Enterprise Integration (Orchestration + advanced patterns)  
- **Weeks 17-24:** Production Excellence (Testing + portfolio development)

This transforms the project from personal infrastructure learning into enterprise-grade experience with industry-standard tooling, significantly enhancing career and portfolio value.

### Change Log

| Date | Version | Description | Author |
|------|---------|-------------|---------|
| 2025-08-30 | v1.0 | Initial architecture document creation with enhanced GitHub Education Pack integration | Winston (Architect) |

## High Level Architecture

### Technical Summary

The hbohlen.io Personal Cloud implements a hybrid multi-cloud learning platform with hub-spoke microservices architecture, leveraging both cost-effective European VPS infrastructure and enterprise-grade tooling through GitHub Education Pack resources. The frontend consists of web-based management interfaces (Portainer, Consul UI, Datadog dashboards, custom monitoring) while the backend employs containerized services with progressive orchestration from Docker Compose to Portainer multi-node management. Key integration points include Caddy reverse proxy with automatic SSL, Consul for service discovery, Doppler Team plan for advanced secrets management, and a comprehensive monitoring stack (Datadog Pro + New Relic + Sentry) providing enterprise-level observability. The infrastructure platform combines European VPS providers (Hetzner/DigitalOcean) for cost efficiency with Azure experimentation nodes for managed services learning, all unified through Tailscale mesh networking and domain-based routing via *.hbohlen.io subdomains. This architecture transforms personal infrastructure learning into enterprise-grade experience, achieving deep technical education while demonstrating production patterns valued in professional environments.

### Platform and Infrastructure Choice

**Selected Platform: Hybrid Multi-Cloud Learning Platform**

**Core Infrastructure:** European VPS (Hetzner primary gateway, DigitalOcean service nodes)
**Enhanced Monitoring:** Datadog Pro (10 servers) + New Relic ($300/month value) + Sentry education tier
**Cloud Experimentation:** Azure nodes with $100 credits for managed services comparison
**Development Platform:** GitHub Codespaces + Travis CI private builds + GitHub Actions
**Quality & Testing:** CodeScene, Codecov, BrowserStack, LambdaTest, Blackfire

**Key Services:** Hetzner (€8/month), DigitalOcean (€12/month), Tailscale mesh networking, Caddy reverse proxy, Consul service discovery, Portainer orchestration, Doppler Team secrets management
**Deployment Host and Regions:** EU-Central (Hetzner Falkenstein), EU-West (DigitalOcean Amsterdam), Azure West Europe (experimentation)

**Rationale:** This hybrid approach maximizes learning value by combining cost-effective self-managed infrastructure with enterprise-grade tooling experience. The ~$945/month in free enterprise tools transforms this from a personal project into professional skill development with industry-standard practices.

### Repository Structure

**Structure:** Enhanced Monorepo with Infrastructure-as-Code and Enterprise Patterns
**Monorepo Tool:** Native Git with npm workspaces for shared utilities and comprehensive tooling integration
**Package Organization:** Service-based packages with shared infrastructure libraries and enterprise-grade practices

```
hbohlen-io/
├── infrastructure/              # Infrastructure as Code
│   ├── docker-compose/         # Service orchestration files
│   │   ├── development/        # Local development stacks
│   │   ├── staging/           # Staging environment (Education Pack enabled)
│   │   └── production/        # Production environment
│   ├── caddy/                 # Reverse proxy configurations
│   ├── consul/                # Service discovery configs
│   ├── portainer/             # Container orchestration
│   ├── monitoring/            # Datadog, New Relic, Sentry configs
│   ├── azure/                 # Azure experimentation resources
│   └── terraform/             # Infrastructure provisioning (future)
├── services/                  # Individual service implementations  
│   ├── falkordb-browser/      # Existing FalkorDB Browser
│   ├── mcp-servers/           # Custom MCP server implementations
│   ├── monitoring-dashboard/  # Custom monitoring interfaces
│   └── shared/                # Shared service utilities
├── environments/              # Environment-specific configurations
│   ├── development/           # Local + Codespaces development
│   ├── staging/               # Full staging environment
│   └── production/            # Production environment
├── quality/                   # Quality assurance and testing
│   ├── codecov/              # Code coverage configurations
│   ├── codescene/            # Code quality analysis
│   ├── browser-tests/        # BrowserStack/LambdaTest configs
│   └── performance/          # Blackfire performance tests
├── ci-cd/                    # CI/CD pipeline configurations
│   ├── github-actions/       # Primary CI/CD workflows
│   ├── travis-ci/           # Travis CI configurations for comparison
│   └── deployment/          # Deployment automation scripts
├── docs/                     # All project documentation
│   ├── architecture/         # Technical architecture docs
│   ├── learning/            # Educational content and guides
│   ├── operations/          # Runbooks and troubleshooting
│   ├── decisions/           # Architecture Decision Records
│   └── api/                 # API documentation (Bump.sh integration)
└── scripts/                 # Automation and deployment scripts
```

### High Level Architecture Diagram

```mermaid
graph TB
    subgraph "Development & CI/CD Ecosystem"
        Codespaces[GitHub Codespaces<br/>Cloud Development]
        TravisCI[Travis CI<br/>Private Builds]
        GitHub[GitHub Actions<br/>Primary CI/CD]
        Codecov[Codecov<br/>Coverage Analysis]
        CodeScene[CodeScene<br/>Code Quality]
    end
    
    subgraph "External Access & Analytics"
        User[Users/Developers]
        Domain[*.hbohlen.io DNS] 
        SimpleAnalytics[SimpleAnalytics<br/>Privacy-friendly Analytics]
        BumpSH[Bump.sh<br/>API Documentation]
    end
    
    subgraph "Hub Node - Hetzner Primary Gateway"
        Caddy[Caddy Reverse Proxy<br/>SSL + Domain Routing]
        Portainer[Portainer Server<br/>Multi-Node Management]
        ConsulServer[Consul Server<br/>Service Discovery<br/>Health Checks]
        DatadogAgent[Datadog Agent<br/>Infrastructure Metrics]
    end
    
    subgraph "Enterprise Monitoring & Observability"
        Datadog[Datadog Pro<br/>10 Servers Free<br/>Infrastructure + APM]
        NewRelic[New Relic<br/>$300/month Value<br/>Performance Insights] 
        Sentry[Sentry Education<br/>Error Tracking<br/>50K Errors + Team Features]
        Honeybadger[Honeybadger<br/>Uptime & Cron<br/>Monitoring]
    end
    
    subgraph "Service Nodes - Distributed Infrastructure"
        ServiceNode1[DigitalOcean Node<br/>FalkorDB + MCP Services<br/>Portainer Agent]
        ServiceNode2[Azure Experiment Node<br/>Managed Services<br/>Learning Platform]
        ServiceNode3[Future VPS Node<br/>Additional Services<br/>Scalability Testing]
    end
    
    subgraph "Tailscale Mesh Network"
        TailscaleHub[Tailscale Hub]
        TailscaleSpoke1[Tailscale Spoke 1]
        TailscaleSpoke2[Tailscale Spoke 2]
        TailscaleSpoke3[Tailscale Spoke 3]
    end
    
    subgraph "Configuration & Secrets Management"
        Doppler[Doppler Team<br/>Advanced Secrets<br/>Multi-Environment<br/>Audit Logs]
    end
    
    subgraph "Quality & Testing Platform"
        BrowserStack[BrowserStack<br/>Cross-Browser Testing<br/>Real Device Cloud]
        LambdaTest[LambdaTest<br/>Live Testing Platform]
        Blackfire[Blackfire<br/>Performance Profiling]
    end
    
    User --> SimpleAnalytics
    User --> Domain
    Domain --> Caddy
    
    Caddy --> TailscaleHub
    TailscaleHub -.->|Secure Mesh| TailscaleSpoke1
    TailscaleHub -.->|Secure Mesh| TailscaleSpoke2
    TailscaleHub -.->|Secure Mesh| TailscaleSpoke3
    
    TailscaleSpoke1 --> ServiceNode1
    TailscaleSpoke2 --> ServiceNode2
    TailscaleSpoke3 --> ServiceNode3
    
    ServiceNode1 --> Datadog
    ServiceNode1 --> NewRelic
    ServiceNode1 --> Sentry
    ServiceNode2 --> Datadog
    ServiceNode2 --> NewRelic
    
    Portainer --> ServiceNode1
    Portainer --> ServiceNode2
    Portainer --> ServiceNode3
    
    ConsulServer --> ServiceNode1
    ConsulServer --> ServiceNode2
    ConsulServer --> ServiceNode3
    
    GitHub --> TravisCI
    GitHub --> Codecov
    GitHub --> CodeScene
    Codespaces --> GitHub
    
    Doppler --> Caddy
    Doppler --> ServiceNode1 
    Doppler --> ServiceNode2
    Doppler --> ServiceNode3
    
    BrowserStack --> ServiceNode1
    LambdaTest --> ServiceNode1
    Blackfire --> ServiceNode1
    
    BumpSH --> GitHub
    Honeybadger --> ServiceNode1
    Honeybadger --> ServiceNode2
```

### Architectural Patterns

The enhanced resource availability enables implementation of enterprise-grade patterns from the beginning, providing comprehensive learning in production-level practices:

- **Hub-Spoke Architecture:** Central gateway managing external access with distributed service nodes - *Rationale: Provides single point of control while enabling distributed services and learning multi-node coordination patterns*

- **Enterprise Observability Pattern:** Multi-tool monitoring stack (Datadog + New Relic + Sentry + Honeybadger) - *Rationale: Learn different approaches to monitoring with $500+/month in professional tools, compare strengths/trade-offs*

- **Mesh Networking:** Tailscale-based secure communication between all nodes including Azure - *Rationale: Modern zero-trust networking that scales across cloud providers while eliminating VPN complexity*

- **Multi-Cloud Learning Pattern:** European VPS primary + Azure experimentation nodes - *Rationale: Compare self-managed vs managed services without committing to expensive cloud-first approach*

- **Progressive Container Orchestration:** Docker Compose → Portainer → (future Kubernetes) with enterprise monitoring throughout - *Rationale: Staged learning with production observability from day one*

- **Advanced GitOps Pattern:** GitHub Actions primary + Travis CI comparison with quality gates - *Rationale: Learn different CI/CD platforms while maintaining code quality with professional tools*

- **Quality-First Development:** CodeScene + Codecov + BrowserStack integration from start - *Rationale: Learn enterprise code quality and testing practices with infrastructure code*

- **Service Discovery at Scale:** Consul-based automatic service registration with comprehensive health monitoring - *Rationale: Production distributed systems pattern with enterprise-grade observability*

- **Advanced Reverse Proxy:** Caddy with domain routing, SSL automation, and performance analytics - *Rationale: Modern alternative to nginx with integrated SimpleAnalytics for usage insights*

- **Enterprise Secrets Management:** Doppler Team with multi-environment, audit logs, and team features - *Rationale: Production security patterns with advanced features typically seen in enterprise environments*

- **Performance Engineering Pattern:** Blackfire integration for continuous performance optimization - *Rationale: Learn performance analysis and optimization with professional tooling*

- **Infrastructure as Code:** Version-controlled infrastructure with quality gates and automated documentation - *Rationale: Essential DevOps practice with enterprise tooling for quality assurance*

**Learning Resource Optimization:**
- **Weeks 1-8:** Foundation tier (core infrastructure + basic monitoring)
- **Weeks 9-16:** Enterprise integration tier (orchestration + advanced monitoring) 
- **Weeks 17-24:** Production excellence tier (testing + performance + portfolio)

## Tech Stack

This is the DEFINITIVE technology selection for the entire project, leveraging GitHub Education Pack resources to provide enterprise-grade experience while maintaining cost efficiency. This stack transforms personal infrastructure learning into professional skill development with industry-standard tools.

### Technology Stack Table

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| **Infrastructure Foundation** |
| VPS Provider (Hub) | Hetzner Cloud | Latest | Primary gateway, reverse proxy, orchestration | Cost-effective EU hosting (€8/month), excellent performance, GDPR compliant |
| VPS Provider (Spoke) | DigitalOcean | Latest | Service nodes, application hosting | GitHub Education credits available, reliable performance, good documentation |
| Cloud Experimentation | Microsoft Azure | Latest | Managed services learning, comparison studies | $100 education credits + $200 Visual Studio credits for hands-on cloud learning |
| **Networking & Security** |
| Mesh Networking | Tailscale | Latest | Secure inter-VPS communication | Zero-config mesh VPN, free tier sufficient, modern zero-trust approach |
| Reverse Proxy | Caddy | v2.7+ | Domain routing, SSL termination, load balancing | Automatic HTTPS, simple configuration, modern alternative to nginx |
| DNS Management | Cloudflare | Latest | Domain management, DNS optimization | Free tier with excellent performance, integrates well with Caddy |
| SSL Certificates | Let's Encrypt | Latest | Automated certificate management | Free, automated, integrated with Caddy |
| **Container & Orchestration** |
| Containerization | Docker | v24+ | Service containerization, local development | Industry standard, extensive ecosystem, GitHub Education support |
| Container Registry | GitHub Container Registry | Latest | Private image storage and distribution | Free with GitHub, integrated with Actions, no additional cost |
| Orchestration | Portainer | v2.19+ | Multi-node container management | Web-based interface, simpler than Kubernetes for learning |
| Service Discovery | Consul | v1.16+ | Service registration, health checks, configuration | Production-grade service mesh preparation, HashiCorp ecosystem |
| **Configuration & Secrets** |
| Secrets Management | Doppler | Team Plan | Environment variables, secrets, multi-env config | GitHub Education Team plan ($240/year value), advanced features |
| **Monitoring & Observability** |
| Infrastructure Monitoring | Datadog | Pro Plan | Server metrics, container monitoring, dashboards | Education pack: 10 servers free ($240/month value) |
| Application Performance | New Relic | Full Platform | APM, performance insights, alerting | Education pack: $300/month value, comprehensive APM |
| Error Tracking | Sentry | Education Tier | Error monitoring, performance tracking, team features | 50K errors/month, team features, $29/month value |
| Uptime Monitoring | Honeybadger | Small Plan | Service availability, cron monitoring | Free small account for 1 year, $39/month value |
| Analytics | SimpleAnalytics | Starter Plan | Privacy-friendly usage analytics | 100K pageviews/month free for students, GDPR compliant |
| **Development & CI/CD** |
| Version Control | GitHub | Pro | Code repository, project management | GitHub Education Pro features |
| Development Environment | GitHub Codespaces | Pro | Cloud development, consistent environments | Pro level access with Education pack |
| Primary CI/CD | GitHub Actions | Latest | Automated deployment, testing, building | Integrated with repository, generous free tier |
| CI/CD Comparison | Travis CI | Latest | Alternative CI/CD learning, private builds | Private builds free for students |
| Code Coverage | Codecov | Latest | Test coverage analysis and reporting | Free on public/private repos with Education pack |
| Code Quality | CodeScene | Student Plan | Code health, technical debt analysis | Free student account for private repos |
| **Testing & Quality** |
| Cross-Browser Testing | BrowserStack | Automate Mobile | Real device testing, browser compatibility | Free 1 parallel, 1 user for 1 year |
| Live Testing | LambdaTest | Live Plan | Interactive cross-platform testing | Free plan for one year |
| Performance Profiling | Blackfire | Developer Plan | Code performance analysis, bottleneck detection | Free developer subscription |
| **Documentation & API** |
| API Documentation | Bump.sh | Standard Plan | Automated API docs, OpenAPI integration | $149/month value free with Education pack |
| **Languages & Frameworks** |
| Frontend Language | TypeScript | v5+ | Type-safe frontend development | Enhanced developer experience, error prevention |
| Frontend Framework | React | v18+ | Component-based UI development | Industry standard, extensive ecosystem |
| UI Component Library | shadcn/ui | Latest | Consistent UI components, accessibility | Modern, customizable, built on Radix UI |
| State Management | Zustand | Latest | Lightweight state management | Simpler than Redux, TypeScript-first |
| Backend Language | TypeScript/Node.js | v20 LTS | Unified language stack, rapid development | Shared types, familiar syntax, extensive ecosystem |
| Backend Framework | Fastify | v4+ | High-performance API development | Faster than Express, TypeScript support, schema validation |
| API Style | REST + OpenAPI | v3.0+ | Standardized API design, documentation | Industry standard, Bump.sh integration |
| **Data & Storage** |
| Primary Database | PostgreSQL | v15+ | Relational data, ACID compliance | Industry standard, excellent performance, JSON support |
| Cache | Redis | v7+ | Session storage, application caching | Fast in-memory storage, pub/sub capabilities |
| File Storage | Local + Object Storage | Latest | Document storage, backups | Local for development, cloud storage for production |
| **Build & Deployment** |
| Package Manager | npm | Latest | Dependency management, workspace support | Integrated with Node.js, workspace support |
| Build Tool | Vite | Latest | Fast development builds, HMR | Faster than Webpack, optimized for modern development |
| Bundler | Vite | Latest | Production optimizations, code splitting | Integrated with build tool, excellent performance |
| IaC Tool | Docker Compose | Latest | Infrastructure definition, service orchestration | Declarative, version-controlled, portable |
| **Runtime & Hosting** |
| Runtime Environment | Node.js | v20 LTS | JavaScript execution, server runtime | LTS stability, excellent performance |
| Process Management | Docker | Latest | Container lifecycle, resource management | Industry standard, integrated with orchestration |

### Implementation Strategy: Graduated Enterprise Integration

**Phase 1 (Weeks 1-8): Essential Enterprise Foundation**
- **Core Stack:** Hetzner + DigitalOcean VPS, Tailscale, Caddy, Docker, Doppler
- **Monitoring:** Datadog Pro + Sentry only (avoid tool overload)
- **Development:** GitHub + Codespaces for consistent environments
- **Focus:** Master fundamental infrastructure patterns with professional monitoring feedback

**Phase 2 (Weeks 9-16): Expanded Enterprise Experience**
- **Add:** New Relic APM, Portainer orchestration, Consul service discovery
- **CI/CD:** GitHub Actions + CodeScene quality gates
- **Azure:** Experimentation node for managed services comparison
- **Focus:** Learn enterprise orchestration and observability patterns

**Phase 3 (Weeks 17-24): Full Professional Toolstack**
- **Complete Stack:** All testing tools (BrowserStack, LambdaTest, Blackfire)
- **Documentation:** Bump.sh API docs, comprehensive portfolio development
- **Comparison Studies:** Travis CI vs GitHub Actions, different monitoring approaches
- **Focus:** Production optimization and professional portfolio development

**Success Metrics:**
- **Tool Integration Time:** Each new tool setup should not exceed 4-8 hours
- **Learning Velocity:** Maintain 2-3 infrastructure concepts mastered per week
- **Quality Maintenance:** CodeScene scores improve throughout development
- **Professional Readiness:** Can explain enterprise patterns and tool trade-offs

**Risk Mitigation:**
- **Complexity Gates:** Remove tools that don't provide clear learning value within 2 weeks
- **Time Boxing:** Maximum 20% of weekly time on tool configuration
- **Simplification Reviews:** Monthly assessment of tool necessity vs learning objectives
- **Escape Hatches:** Simpler alternatives documented for each enterprise tool

This technology stack provides ~$945/month in enterprise tool value while maintaining €25-40/month actual costs, transforming personal infrastructure learning into professional skill development with industry-standard practices.

## Data Models

The hbohlen.io Personal Cloud requires infrastructure-centric data models that integrate monitoring, service discovery, and operational data across the enterprise toolstack. These models focus on infrastructure entities, service metadata, and operational intelligence rather than traditional application data.

### Infrastructure Node

**Purpose:** Represents VPS instances, containers, and service deployment targets in the hub-spoke architecture with comprehensive monitoring integration.

**Key Attributes:**
- id: string - Unique identifier for infrastructure tracking
- type: "hub" | "spoke" | "experimentation" - Node classification in architecture
- provider: "hetzner" | "digitalocean" | "azure" - Cloud provider integration
- resources: ResourceSpec - CPU, memory, storage for capacity planning
- networking: NetworkConfig - Tailscale IPs, domains, connectivity
- status: NodeStatus - Current operational state with health integration

#### TypeScript Interface
```typescript
interface InfrastructureNode {
  id: string;
  name: string;
  type: 'hub' | 'spoke' | 'experimentation';
  provider: 'hetzner' | 'digitalocean' | 'azure';
  region: string;
  resources: {
    cpu: number;        // vCPU count
    memory: number;     // GB
    storage: number;    // GB
    bandwidth: number;  // GB/month
  };
  networking: {
    tailscaleIP: string;
    publicIP?: string;
    hostname: string;
  };
  status: 'active' | 'maintenance' | 'degraded' | 'offline';
  monitoring: {
    datadogHost: string;
    newRelicAgentId?: string;
    lastHealthCheck: string;
    uptime: number;
  };
  metadata: {
    createdAt: string;
    lastSeen: string;
    osVersion: string;
    dockerVersion: string;
  };
}
```

#### Relationships
- One-to-many with ServiceInstance (hosts multiple services)
- One-to-many with MonitoringMetric (generates infrastructure metrics)
- Many-to-one with InfrastructureCluster (belongs to hub-spoke cluster)

### Service Instance

**Purpose:** Represents deployed services with Consul service discovery, Portainer management, and comprehensive monitoring integration.

**Key Attributes:**
- id: string - Service instance identifier for tracking
- serviceId: string - Logical service grouping (multiple instances)
- type: ServiceType - Classification for monitoring and management
- nodeId: string - Host infrastructure node reference
- container: ContainerSpec - Docker container configuration
- networking: NetworkConfig - Caddy routing, health checks, domains
- monitoring: MonitoringConfig - Integration with Datadog, New Relic, Sentry

#### TypeScript Interface
```typescript
interface ServiceInstance {
  id: string;
  serviceId: string;
  name: string;
  type: 'web' | 'api' | 'database' | 'cache' | 'monitoring' | 'utility';
  nodeId: string;
  container: {
    image: string;
    tag: string;
    ports: Array<{
      container: number;
      host?: number;
      protocol: 'tcp' | 'udp';
    }>;
    environment: string[];  // Doppler configuration keys
    volumes: Array<{
      source: string;
      target: string;
      readonly?: boolean;
    }>;
  };
  networking: {
    internalPort: number;
    domains: string[];      // e.g., ["falkordb.hbohlen.io"]
    caddyConfig: string;    // Caddy routing configuration
    healthCheck: {
      path: string;
      interval: number;
      timeout: number;
    };
  };
  monitoring: {
    datadogService: string;
    newRelicAppId?: string;
    sentryProject?: string;
    consulServiceId: string;
    alerts: string[];       // Alert rule IDs
  };
  status: {
    deployment: 'deploying' | 'running' | 'stopped' | 'failed' | 'updating';
    health: 'healthy' | 'unhealthy' | 'unknown';
    lastHealthCheck: string;
    uptime: number;
  };
  metadata: {
    version: string;
    deployedAt: string;
    deployedBy: string;
    gitCommit?: string;
  };
}
```

#### Relationships
- Many-to-one with InfrastructureNode (deployed on specific node)
- One-to-many with MonitoringAlert (generates operational alerts)
- Many-to-one with ServiceDefinition (instance of logical service)
- One-to-many with DeploymentEvent (deployment history tracking)

### Monitoring Metric

**Purpose:** Unified metric aggregation across Datadog, New Relic, Sentry, and Consul for comprehensive observability and learning analysis.

#### TypeScript Interface
```typescript
interface MonitoringMetric {
  id: string;
  source: 'datadog' | 'newrelic' | 'sentry' | 'consul' | 'portainer' | 'caddy';
  type: 'infrastructure' | 'application' | 'business' | 'security';
  category: 'cpu' | 'memory' | 'disk' | 'network' | 'response_time' | 'error_rate' | 'throughput';
  entityId: string;        // InfrastructureNode.id or ServiceInstance.id
  entityType: 'node' | 'service' | 'container' | 'endpoint';
  metric: {
    name: string;          // e.g., "cpu.usage.percent", "http.response.time"
    value: number;
    unit: string;          // e.g., "percent", "milliseconds", "bytes"
    aggregation?: 'sum' | 'avg' | 'min' | 'max' | 'count';
  };
  dimensions: {
    timestamp: string;
    interval: number;      // collection interval in seconds
    tags: Record<string, string>;
  };
  thresholds?: {
    warning: number;
    critical: number;
    comparison: 'greater_than' | 'less_than' | 'equals';
  };
  correlation: {
    sourceMetricId?: string;  // Original tool-specific metric ID
    relatedMetrics: string[]; // Related metrics for analysis
  };
}
```

#### Relationships
- Many-to-one with InfrastructureNode or ServiceInstance
- One-to-many with MonitoringAlert (metrics trigger alerts)
- Many-to-many with Dashboard (metrics displayed across tools)

### Deployment Event

**Purpose:** Comprehensive deployment tracking across GitHub Actions, Travis CI, and manual deployments for GitOps learning and operational intelligence.

#### TypeScript Interface
```typescript
interface DeploymentEvent {
  id: string;
  serviceInstanceId: string;
  deployment: {
    trigger: 'github_actions' | 'travis_ci' | 'manual' | 'rollback';
    pipeline: string;      // workflow/job name
    initiatedBy: string;   // user or automation
    environment: 'development' | 'staging' | 'production';
  };
  changes: {
    type: 'create' | 'update' | 'delete' | 'scale' | 'config_change';
    fromVersion?: string;
    toVersion: string;
    configChanges: Array<{
      key: string;
      oldValue?: string;
      newValue: string;
      source: 'doppler' | 'environment' | 'docker_compose';
    }>;
    imageChanges?: {
      oldImage?: string;
      newImage: string;
      registry: string;
    };
  };
  status: {
    state: 'initiated' | 'building' | 'deploying' | 'testing' | 'completed' | 'failed' | 'rolled_back';
    progress: number;      // 0-100 percentage
    message?: string;
    logs: string[];
  };
  timing: {
    startedAt: string;
    completedAt?: string;
    duration?: number;     // milliseconds
    phases: Array<{
      name: string;
      duration: number;
      status: 'success' | 'failed' | 'skipped';
    }>;
  };
  monitoring: {
    preDeploy: {
      healthChecks: boolean;
      performanceBaseline: Record<string, number>;
    };
    postDeploy: {
      healthVerification: boolean;
      performanceComparison: Record<string, number>;
      alertsTriggered: string[];
    };
  };
  git?: {
    repository: string;
    branch: string;
    commit: string;
    commitMessage: string;
    author: string;
  };
}
```

#### Relationships
- Many-to-one with ServiceInstance (deployments target services)
- One-to-many with MonitoringAlert (deployments trigger alerts)
- Many-to-one with ConfigurationTemplate (deployments use templates)

### Configuration Template

**Purpose:** Doppler-based configuration management with multi-environment support and enterprise-grade validation.

#### TypeScript Interface
```typescript
interface ConfigurationTemplate {
  id: string;
  name: string;
  environment: 'development' | 'staging' | 'production';
  scope: 'global' | 'service' | 'node';
  doppler: {
    project: string;
    config: string;
    lastSync: string;
    teamAccess: string[];
  };
  variables: Array<{
    key: string;
    type: 'string' | 'number' | 'boolean' | 'json' | 'secret';
    required: boolean;
    defaultValue?: string;
    description: string;
    validation?: {
      pattern?: string;
      minLength?: number;
      maxLength?: number;
      allowedValues?: string[];
    };
  }>;
  validation: {
    schema: string;        // JSON schema for validation
    testCases: Array<{
      name: string;
      input: Record<string, any>;
      expected: 'valid' | 'invalid';
    }>;
  };
  metadata: {
    createdAt: string;
    updatedAt: string;
    version: string;
    usedBy: string[];      // ServiceInstance IDs
    auditLog: Array<{
      timestamp: string;
      user: string;
      action: 'create' | 'update' | 'delete' | 'deploy';
      changes: Record<string, any>;
    }>;
  };
}
```

#### Relationships
- One-to-many with ServiceInstance (templates used by services)
- Many-to-one with Environment (templates belong to environments)
- One-to-many with DeploymentEvent (template changes trigger deployments)

### Critical Assumption Validations

**Implementation Validation Requirements:**

**Week 1-2: Tool Integration Validation**
- Validate actual API schemas from Datadog, New Relic, Sentry match model structures
- Test data transformation performance and accuracy across monitoring tools
- Confirm Doppler Team plan API capabilities align with ConfigurationTemplate model

**Week 3-4: Service Discovery Integration**
- Test Consul service registration data mapping to ServiceInstance model
- Validate Portainer API metadata consistency with container specifications
- Confirm health check integration between Consul and container status

**Week 5-8: Operational Data Validation** 
- Test deployment tracking completeness across GitHub Actions and Travis CI
- Validate metric aggregation performance with high-frequency data collection
- Confirm resource utilization tracking accuracy across VPS providers

**Model Evolution Strategy:**
- Monthly model reviews based on actual tool usage patterns
- Bi-weekly assumption validation against real operational data
- Quarterly simplification reviews to prevent over-engineering

These infrastructure data models provide the foundation for unified monitoring, automated deployment tracking, and comprehensive learning analysis across the entire enterprise toolstack while maintaining focus on infrastructure learning objectives.

## API Specification

The hbohlen.io Personal Cloud uses a REST API approach with comprehensive OpenAPI 3.0 specification to enable integration between infrastructure management, monitoring aggregation, and service orchestration. The API serves both internal system integration and external learning/management interfaces.

### REST API Specification

```yaml
openapi: 3.0.0
info:
  title: hbohlen.io Personal Cloud Infrastructure API
  version: 1.0.0
  description: |
    Comprehensive infrastructure management API integrating monitoring, service discovery, 
    deployment tracking, and configuration management across the entire enterprise toolstack.
    
    **Key Integration Points:**
    - Datadog, New Relic, Sentry monitoring aggregation
    - Consul service discovery and health management  
    - Portainer container orchestration
    - Doppler configuration management
    - GitHub Actions / Travis CI deployment tracking
  contact:
    name: Infrastructure Learning Project
    url: https://hbohlen.io
servers:
  - url: https://api.hbohlen.io/v1
    description: Production API Gateway (via Caddy)
  - url: https://staging-api.hbohlen.io/v1  
    description: Staging Environment
  - url: http://localhost:3000/v1
    description: Local Development

paths:
  # Infrastructure Management
  /infrastructure/nodes:
    get:
      summary: List all infrastructure nodes
      description: Retrieve all VPS instances with current status, monitoring integration, and resource utilization
      tags: [Infrastructure]
      parameters:
        - name: provider
          in: query
          schema:
            type: string
            enum: [hetzner, digitalocean, azure]
        - name: type
          in: query
          schema:
            type: string
            enum: [hub, spoke, experimentation]
        - name: status
          in: query
          schema:
            type: string
            enum: [active, maintenance, degraded, offline]
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  nodes:
                    type: array
                    items:
                      $ref: '#/components/schemas/InfrastructureNode'
                  metadata:
                    type: object
                    properties:
                      total: { type: integer }
                      active: { type: integer }
                      monitoring_integrated: { type: integer }

  /services:
    get:
      summary: List all service instances
      description: Retrieve services across all nodes with health status, monitoring data, and deployment information
      tags: [Services]
      parameters:
        - name: nodeId
          in: query
          schema:
            type: string
        - name: type
          in: query
          schema:
            type: string
            enum: [web, api, database, cache, monitoring, utility]
        - name: status
          in: query
          schema:
            type: string
            enum: [running, stopped, failed, deploying, updating]
      responses:
        '200':
          description: Service instances with comprehensive monitoring
          content:
            application/json:
              schema:
                type: object
                properties:
                  services:
                    type: array
                    items:
                      $ref: '#/components/schemas/ServiceInstance'
                  aggregated_health:
                    type: object
                    properties:
                      healthy: { type: integer }
                      unhealthy: { type: integer }
                      unknown: { type: integer }

    post:
      summary: Deploy new service instance
      description: Create and deploy new service with automatic monitoring integration and service discovery registration
      tags: [Services]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ServiceDeploymentRequest'
      responses:
        '201':
          description: Service deployment initiated
          content:
            application/json:
              schema:
                type: object
                properties:
                  deployment_id: { type: string }
                  service_instance: 
                    $ref: '#/components/schemas/ServiceInstance'
                  monitoring_setup:
                    type: object
                    properties:
                      datadog_configured: { type: boolean }
                      newrelic_configured: { type: boolean }
                      sentry_configured: { type: boolean }
                      consul_registered: { type: boolean }

  # Monitoring and Metrics
  /monitoring/metrics:
    get:
      summary: Aggregate monitoring metrics
      description: Unified metrics from Datadog, New Relic, Sentry with correlation and comparison capabilities
      tags: [Monitoring]
      parameters:
        - name: source
          in: query
          schema:
            type: array
            items:
              type: string
              enum: [datadog, newrelic, sentry, consul, portainer, caddy]
        - name: entity_id
          in: query
          schema:
            type: string
        - name: time_range
          in: query
          schema:
            type: string
            enum: [1h, 24h, 7d, 30d]
      responses:
        '200':
          description: Aggregated metrics with cross-tool correlation
          content:
            application/json:
              schema:
                type: object
                properties:
                  metrics:
                    type: array
                    items:
                      $ref: '#/components/schemas/MonitoringMetric'
                  correlation_analysis:
                    type: object
                    properties:
                      cross_tool_consistency: { type: number }
                      data_quality_score: { type: number }

  # Deployment Management
  /deployments:
    get:
      summary: List deployment events
      description: Deployment history across GitHub Actions, Travis CI, and manual deployments with performance analysis
      tags: [Deployments]
      parameters:
        - name: service_id
          in: query
          schema:
            type: string
        - name: trigger
          in: query
          schema:
            type: string
            enum: [github_actions, travis_ci, manual, rollback]
        - name: environment
          in: query
          schema:
            type: string
            enum: [development, staging, production]
      responses:
        '200':
          description: Deployment events with comprehensive CI/CD integration
          content:
            application/json:
              schema:
                type: object
                properties:
                  deployments:
                    type: array
                    items:
                      $ref: '#/components/schemas/DeploymentEvent'
                  analytics:
                    type: object
                    properties:
                      success_rate: { type: number }
                      average_duration: { type: number }

components:
  schemas:
    InfrastructureNode:
      type: object
      properties:
        id: { type: string }
        name: { type: string }
        type: { type: string, enum: [hub, spoke, experimentation] }
        provider: { type: string, enum: [hetzner, digitalocean, azure] }
        resources:
          type: object
          properties:
            cpu: { type: integer }
            memory: { type: integer }
            storage: { type: integer }
        networking:
          type: object
          properties:
            tailscaleIP: { type: string }
            publicIP: { type: string }
            hostname: { type: string }
        status: { type: string, enum: [active, maintenance, degraded, offline] }

    ServiceInstance:
      type: object
      properties:
        id: { type: string }
        serviceId: { type: string }
        name: { type: string }
        type: { type: string, enum: [web, api, database, cache, monitoring, utility] }
        nodeId: { type: string }
        status:
          type: object
          properties:
            deployment: { type: string, enum: [deploying, running, stopped, failed, updating] }
            health: { type: string, enum: [healthy, unhealthy, unknown] }

    MonitoringMetric:
      type: object
      properties:
        id: { type: string }
        source: { type: string, enum: [datadog, newrelic, sentry, consul, portainer, caddy] }
        type: { type: string, enum: [infrastructure, application, business, security] }
        entityId: { type: string }
        metric:
          type: object
          properties:
            name: { type: string }
            value: { type: number }
            unit: { type: string }

    DeploymentEvent:
      type: object
      properties:
        id: { type: string }
        serviceInstanceId: { type: string }
        deployment:
          type: object
          properties:
            trigger: { type: string, enum: [github_actions, travis_ci, manual, rollback] }
            environment: { type: string, enum: [development, staging, production] }
        status:
          type: object
          properties:
            state: { type: string, enum: [initiated, building, deploying, completed, failed] }

  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key

security:
  - BearerAuth: []
  - ApiKeyAuth: []
```

### API Integration Strategy

**Internal System Integration:**
- **Monitoring Aggregation:** Unified endpoints for Datadog, New Relic, Sentry data correlation
- **Service Discovery:** Consul integration for automatic service registration and health checks
- **Container Management:** Portainer API integration for deployment and lifecycle management
- **Configuration Management:** Doppler API integration for secure configuration deployment

**External Interface Support:**
- **Custom Dashboards:** React-based interfaces consuming aggregated monitoring data
- **CI/CD Integration:** GitHub Actions and Travis CI webhook endpoints for deployment tracking
- **Learning Documentation:** API-driven documentation generation with Bump.sh integration

**Authentication and Security:**
- **Bearer Token Authentication:** JWT-based authentication for service-to-service communication
- **API Key Authentication:** Simple key-based access for monitoring tool integrations
- **Rate Limiting:** Caddy-based rate limiting to prevent abuse and ensure stability
- **CORS Configuration:** Proper CORS setup for web interface integration

**API Evolution and Documentation:**
- **Automated Documentation:** Bump.sh integration for live API documentation updates
- **Version Management:** Semantic versioning with backward compatibility guarantees
- **Testing Integration:** BrowserStack and LambdaTest for API endpoint testing
- **Performance Monitoring:** New Relic APM integration for API performance tracking

This REST API specification provides comprehensive integration capabilities while maintaining focus on infrastructure learning objectives and enterprise tool integration patterns.

## Components

The hbohlen.io Personal Cloud consists of distributed components across the hub-spoke architecture, each with clear responsibilities and well-defined interfaces. The component design emphasizes learning visibility, enterprise integration, and stakeholder value alignment.

### Infrastructure Gateway Component

**Responsibility:** Central access point managing external traffic, SSL termination, domain-based routing, and primary coordination for the entire personal cloud infrastructure.

**Key Interfaces:**
- External HTTP/HTTPS traffic handling via Caddy reverse proxy with automatic SSL
- Tailscale mesh network coordination and secure routing
- Primary Consul server for service discovery coordination
- Portainer server for multi-node container orchestration management
- Datadog infrastructure monitoring integration

**Dependencies:** Cloudflare DNS, Let's Encrypt certificates, Tailscale control plane, Doppler configuration management

**Technology Stack:** Caddy v2.7+, Consul v1.16+ (server mode), Portainer v2.19+ (server), Datadog Agent, Node.js/Fastify API services

**Stakeholder Value:** Demonstrates reverse proxy patterns (career), service discovery coordination (enterprise), central orchestration management (learning), professional SSL automation (portfolio)

### Service Runtime Component

**Responsibility:** Container execution environment on spoke nodes, handling service lifecycle, local health monitoring, and integration with central infrastructure management.

**Key Interfaces:**
- Container lifecycle management via Docker and Portainer agents
- Service health reporting to Consul agents with comprehensive health checks
- Local monitoring data collection for Datadog/New Relic APM integration
- Configuration synchronization with Doppler Team plan
- Service registration and discovery with automatic failover

**Dependencies:** Docker runtime, Portainer agent, Consul agent, Tailscale mesh connectivity, infrastructure gateway component

**Technology Stack:** Docker v24+, Portainer Agent, Consul Agent, Datadog/New Relic agents, service-specific runtimes (Node.js, Python, etc.)

**Stakeholder Value:** Container orchestration expertise (career), service mesh participation (enterprise), health monitoring patterns (learning), distributed system coordination (portfolio)

### Monitoring Aggregation Component

**Responsibility:** Unified monitoring data collection, correlation, and analysis across all enterprise monitoring tools, providing comprehensive observability and learning insights with cross-tool comparison capabilities.

**Key Interfaces:**
- Datadog API integration for infrastructure and application metrics ($240/month value)
- New Relic API integration for performance monitoring and APM ($300/month value)
- Sentry API integration for error tracking and performance monitoring ($29/month value)
- Honeybadger integration for uptime and cron monitoring ($39/month value)
- Consul health check integration for service discovery correlation
- Custom dashboard API serving aggregated monitoring data for learning analysis

**Dependencies:** Datadog Pro account, New Relic full platform, Sentry education tier, Honeybadger small plan, Consul service discovery, monitoring metric data models

**Technology Stack:** TypeScript/Node.js, Fastify API framework, React dashboard interfaces, Datadog/New Relic/Sentry SDKs, Redis for metric caching

**Stakeholder Value:** Enterprise monitoring expertise ($568/month tools), observability patterns (career), data correlation techniques (enterprise), performance analysis skills (learning)

### Deployment Orchestration Component

**Responsibility:** Automated deployment pipeline management across GitHub Actions and Travis CI, with comprehensive deployment tracking, monitoring integration, and rollback capabilities for GitOps learning.

**Key Interfaces:**
- GitHub Actions webhook integration for automated deployments
- Travis CI integration for comparative CI/CD learning and pattern analysis
- Container registry integration (GitHub Container Registry)
- Service discovery registration automation via Consul
- Deployment event tracking API for learning analysis and performance measurement
- CodeScene and Codecov integration for quality gates

**Dependencies:** GitHub Actions, Travis CI, GitHub Container Registry, Doppler configuration management, service runtime components, monitoring systems

**Technology Stack:** GitHub Actions workflows, Travis CI configurations, Docker container building, Portainer deployment APIs, custom deployment tracking services

**Stakeholder Value:** GitOps expertise (career), CI/CD pipeline design (enterprise), automated testing integration (learning), deployment monitoring patterns (portfolio)

### Configuration Management Component

**Responsibility:** Centralized configuration and secrets management using Doppler Team plan, with multi-environment support, audit logging, and secure distribution across all infrastructure components.

**Key Interfaces:**
- Doppler API integration for configuration synchronization with team features
- Multi-environment configuration template management (dev/staging/production)
- Secure configuration distribution to service runtime components
- Configuration change audit logging and deployment correlation
- Environment promotion workflows with approval gates

**Dependencies:** Doppler Team plan ($240/year value), configuration template data models, deployment orchestration component, service runtime environments

**Technology Stack:** Doppler CLI and APIs, TypeScript configuration validation, environment-specific Docker Compose templates, secure configuration distribution mechanisms

**Stakeholder Value:** Enterprise secrets management (career), configuration as code (enterprise), multi-environment patterns (learning), security best practices (portfolio)

### Learning Analytics Component

**Responsibility:** Educational data collection, analysis, and presentation, transforming infrastructure operations into structured learning experiences with progress tracking, knowledge documentation, and community contribution capabilities.

**Key Interfaces:**
- Infrastructure event correlation for learning pattern identification
- Deployment success/failure analysis for CI/CD learning insights
- Monitoring data analysis for performance optimization learning with SimpleAnalytics integration
- Documentation generation from operational data and architecture decisions
- Learning progress tracking and milestone achievement with portfolio artifact creation

**Dependencies:** All other components for data collection, monitoring aggregation component for operational insights, deployment orchestration for CI/CD data, SimpleAnalytics for usage tracking

**Technology Stack:** TypeScript analytics services, React-based learning dashboards, SimpleAnalytics integration, Bump.sh for API documentation, custom learning data models

**Stakeholder Value:** Knowledge management systems (career), operational analytics (enterprise), learning progress demonstration (learning), documentation automation (community)

### External Integration Component

**Responsibility:** Integration with external services and enterprise tools, including cloud experimentation (Azure), testing platforms (BrowserStack, LambdaTest), quality analysis tools (CodeScene, Codecov), and multi-cloud pattern learning.

**Key Interfaces:**
- Azure cloud services integration for managed services experimentation ($100 credits + $200 Visual Studio)
- BrowserStack/LambdaTest integration for cross-platform testing
- CodeScene integration for code quality analysis and technical debt tracking
- Codecov integration for test coverage analysis and improvement
- External API management and rate limiting through Caddy

**Dependencies:** Azure credits, BrowserStack/LambdaTest education accounts, CodeScene student plan, Codecov education integration, API gateway capabilities

**Technology Stack:** Azure SDK integration, testing platform APIs, code quality analysis tools, TypeScript integration services, Caddy-based API gateway

**Stakeholder Value:** Multi-cloud competency (career), automated testing expertise (enterprise), code quality engineering (learning), external integration patterns (portfolio)

### Security Management Component (Stakeholder-Driven Addition)

**Responsibility:** Cross-cutting security concerns including authentication, authorization, audit logging, and compliance patterns distributed across all other components.

**Key Interfaces:**
- JWT-based authentication for inter-component communication
- API key management for external tool integrations
- Audit logging integration with Doppler for configuration changes
- Security scanning integration with GitHub Actions and CodeScene
- Compliance reporting for enterprise patterns learning

**Dependencies:** All other components, Doppler audit features, GitHub security features, enterprise monitoring tools

**Technology Stack:** JWT libraries, security scanning tools, audit logging systems, compliance reporting mechanisms

**Stakeholder Value:** Security engineering skills (career), compliance patterns (enterprise), security best practices (learning), audit trail capabilities (portfolio)

### Stakeholder Alignment Matrix

| Component | Learning Value | Career Value | Enterprise Value | Community Value |
|-----------|---------------|--------------|------------------|-----------------|
| Infrastructure Gateway | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Monitoring Aggregation | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Deployment Orchestration | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Service Runtime | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Configuration Management | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| Learning Analytics | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| External Integration | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Security Management | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ |

### Component Integration Recommendations

**Phase 1 Implementation Priority:** 
1. Infrastructure Gateway + Service Runtime (foundation)
2. Basic Monitoring Aggregation (immediate feedback)
3. Configuration Management (security from start)

**Phase 2 Enhancement:**
1. Full Monitoring Aggregation (enterprise patterns)
2. Deployment Orchestration (automation)
3. Learning Analytics (progress tracking)

**Phase 3 Excellence:**
1. External Integration (multi-cloud learning)
2. Security Management (compliance patterns)
3. Advanced Learning Analytics (portfolio generation)

This stakeholder-aligned component architecture maximizes value for all concerned parties while maintaining clear learning progression and enterprise relevance.

### Component Diagrams

```mermaid
C4Context
    title System Context - hbohlen.io Personal Cloud Components

    Person(developer, "Infrastructure Learning Developer", "Primary user learning production patterns")
    Person(community, "Developer Community", "Learning resource consumers")
    
    System_Boundary(personalcloud, "hbohlen.io Personal Cloud") {
        System(gateway, "Infrastructure Gateway", "Central access, reverse proxy, coordination")
        System(monitoring, "Monitoring Aggregation", "Enterprise monitoring integration")
        System(deployment, "Deployment Orchestration", "CI/CD pipeline management")
        System(services, "Service Runtime", "Container execution environment")
        System(config, "Configuration Management", "Centralized secrets and config")
        System(learning, "Learning Analytics", "Educational data analysis")
        System(security, "Security Management", "Cross-cutting security concerns")
        System(external, "External Integration", "Multi-cloud and enterprise tools")
    }
    
    System_Ext(github, "GitHub Ecosystem", "Source, Actions, Registry, Education Pack")
    System_Ext(monitoring_tools, "Enterprise Monitoring", "Datadog Pro, New Relic, Sentry")
    System_Ext(cloud_providers, "Cloud Providers", "Hetzner, DigitalOcean, Azure")
    
    Rel(developer, gateway, "Accesses via", "HTTPS")
    Rel(community, learning, "Consumes resources", "HTTPS")
    Rel(gateway, services, "Routes to", "Tailscale")
    Rel(monitoring, monitoring_tools, "Aggregates from", "APIs")
    Rel(deployment, github, "Triggered by", "Webhooks")
    Rel(config, github, "Syncs with", "Doppler APIs")
```

## External APIs

The hbohlen.io Personal Cloud integrates extensively with external services through GitHub Education Pack benefits, requiring comprehensive API integration patterns and management.

### Datadog API

- **Purpose:** Infrastructure and application monitoring with 10 server Pro plan
- **Documentation:** https://docs.datadoghq.com/api/latest/
- **Base URL(s):** https://api.datadoghq.com/api/v1, https://api.datadoghq.com/api/v2
- **Authentication:** API Key + Application Key
- **Rate Limits:** 300 requests per hour per organization

**Key Endpoints Used:**
- `GET /api/v1/metrics` - Retrieve infrastructure metrics for aggregation
- `POST /api/v1/events` - Create deployment and infrastructure events
- `GET /api/v1/hosts` - List monitored infrastructure nodes
- `POST /api/v1/logs` - Send custom log data for correlation

**Integration Notes:** Critical for infrastructure monitoring learning, provides baseline for comparison with other tools

### New Relic API

- **Purpose:** Application performance monitoring and observability ($300/month education value)
- **Documentation:** https://docs.newrelic.com/docs/apis/
- **Base URL(s):** https://api.newrelic.com/v2, https://api.eu.newrelic.com/v2
- **Authentication:** API Key
- **Rate Limits:** 1000 requests per minute

**Key Endpoints Used:**
- `GET /v2/applications` - List monitored applications for service correlation
- `GET /v2/applications/{id}/metrics` - Application performance metrics
- `POST /v2/deployments` - Track deployment events and performance impact
- `GET /v2/alerts` - Alert management and correlation

**Integration Notes:** Provides APM perspective complementing Datadog infrastructure focus, essential for performance learning

### Sentry API

- **Purpose:** Error tracking and performance monitoring with education tier benefits
- **Documentation:** https://docs.sentry.io/api/
- **Base URL(s):** https://sentry.io/api/0/
- **Authentication:** Bearer Token
- **Rate Limits:** 20,000 requests per hour

**Key Endpoints Used:**
- `GET /api/0/projects/{org}/{project}/events/` - Error event correlation
- `POST /api/0/projects/{org}/{project}/releases/` - Track deployment releases
- `GET /api/0/organizations/{org}/issues/` - Issue tracking and resolution patterns
- `GET /api/0/projects/{org}/{project}/stats/` - Error statistics for learning analysis

**Integration Notes:** Critical for error pattern learning, integrates with deployment tracking for impact analysis

### Azure Management API

- **Purpose:** Cloud experimentation and managed services learning with $100 + $200 credits
- **Documentation:** https://docs.microsoft.com/en-us/rest/api/azure/
- **Base URL(s):** https://management.azure.com/
- **Authentication:** Azure AD OAuth 2.0
- **Rate Limits:** 15,000 requests per hour per subscription

**Key Endpoints Used:**
- `GET /subscriptions/{id}/resourceGroups` - Resource group management for experimentation
- `POST /subscriptions/{id}/providers/Microsoft.ContainerInstance/containerGroups` - Container instances for comparison
- `GET /subscriptions/{id}/providers/Microsoft.Monitor/metrics` - Azure Monitor integration
- `POST /subscriptions/{id}/providers/Microsoft.Resources/deployments` - ARM template deployments

**Integration Notes:** Enables managed services vs self-hosted comparison learning, multi-cloud pattern experience

### Doppler API

- **Purpose:** Advanced secrets and configuration management with Team plan features
- **Documentation:** https://docs.doppler.com/reference
- **Base URL(s):** https://api.doppler.com/v3
- **Authentication:** Bearer Token
- **Rate Limits:** 240 requests per minute

**Key Endpoints Used:**
- `GET /v3/configs/{config}/secrets` - Configuration retrieval for service deployment
- `POST /v3/configs/{config}/secrets` - Configuration updates with audit logging
- `GET /v3/projects/{project}/environments` - Environment management
- `GET /v3/configs/{config}/logs` - Audit log integration for learning analysis

**Integration Notes:** Team plan provides advanced features like audit logging essential for enterprise learning patterns

## Core Workflows

The following sequence diagrams illustrate critical system workflows that demonstrate enterprise patterns and integration between components:

```mermaid
sequenceDiagram
    participant User as Infrastructure Developer
    participant GitHub as GitHub Actions
    participant Doppler as Doppler Config
    participant Gateway as Infrastructure Gateway
    participant Consul as Consul Discovery
    participant ServiceNode as Service Runtime
    participant Monitoring as Monitoring Stack
    
    Note over User,Monitoring: Service Deployment Workflow
    
    User->>GitHub: Push service update
    GitHub->>Doppler: Fetch production config
    GitHub->>GitHub: Build container image
    GitHub->>Gateway: Deploy via API
    
    Gateway->>ServiceNode: Deploy container via Portainer
    ServiceNode->>Consul: Register service + health check
    Consul->>Gateway: Update service discovery
    Gateway->>Gateway: Update Caddy routing config
    
    ServiceNode->>Monitoring: Report service metrics
    Monitoring->>Monitoring: Correlate across Datadog/New Relic/Sentry
    Monitoring->>User: Deployment success notification
    
    Note over User,Monitoring: Monitoring and Alerting Workflow
    
    ServiceNode->>Consul: Health check failure
    Consul->>Gateway: Service unhealthy notification
    Gateway->>Monitoring: Service degradation event
    
    Monitoring->>Monitoring: Correlate across monitoring tools
    Monitoring->>User: Alert via multiple channels
    
    User->>Gateway: Investigate via monitoring dashboard
    Gateway->>Monitoring: Fetch correlated metrics
    Monitoring-->>User: Comprehensive health analysis
    
    Note over User,Monitoring: Configuration Update Workflow
    
    User->>Doppler: Update service configuration
    Doppler->>Doppler: Audit log configuration change
    Doppler->>ServiceNode: Sync new configuration
    ServiceNode->>ServiceNode: Restart service with new config
    ServiceNode->>Consul: Re-register with updated health check
    ServiceNode->>Monitoring: Report configuration change impact
    Monitoring->>User: Configuration change confirmation
```

```mermaid
sequenceDiagram
    participant External as External User
    participant Cloudflare as Cloudflare DNS
    participant Gateway as Infrastructure Gateway
    participant Tailscale as Tailscale Mesh
    participant ServiceNode as Service Runtime
    participant Monitoring as Enterprise Monitoring
    
    Note over External,Monitoring: External Service Access Workflow
    
    External->>Cloudflare: Request falkordb.hbohlen.io
    Cloudflare->>Gateway: Route to gateway VPS
    Gateway->>Gateway: Caddy SSL termination
    Gateway->>Consul: Service discovery lookup
    Consul-->>Gateway: Service location + health status
    
    Gateway->>Tailscale: Route via mesh network
    Tailscale->>ServiceNode: Secure tunnel to service
    ServiceNode->>ServiceNode: Process request
    ServiceNode-->>Gateway: Response via Tailscale
    Gateway-->>External: HTTPS response
    
    par Monitoring Collection
        ServiceNode->>Monitoring: Request metrics to Datadog
        ServiceNode->>Monitoring: Performance data to New Relic
        ServiceNode->>Monitoring: Error tracking to Sentry
        Gateway->>Monitoring: Proxy metrics to SimpleAnalytics
    end
    
    Note over External,Monitoring: Failure Handling Workflow
    
    Gateway->>ServiceNode: Service request
    ServiceNode-->>Gateway: Service unavailable
    Gateway->>Consul: Check service health
    Consul-->>Gateway: Service marked unhealthy
    
    Gateway->>Monitoring: Log failure event
    Monitoring->>Monitoring: Correlate across monitoring tools
    Monitoring->>User: Alert via Honeybadger + Sentry
    
    Gateway-->>External: 503 Service Temporarily Unavailable
```

This component architecture successfully serves all key stakeholders:
- **Learning Developer:** Progressive complexity with enterprise tool experience
- **Career Development:** Demonstrable experience with production patterns and professional tools
- **Enterprise Relevance:** Integration patterns and monitoring approaches used in production environments
- **Community Value:** Open documentation and reusable patterns for knowledge sharing

The workflows demonstrate end-to-end system operation while highlighting the educational value and enterprise integration capabilities of each component.

## Database Schema

The hbohlen.io Personal Cloud uses PostgreSQL as the primary database for operational data, configuration tracking, and learning analytics, with Redis for caching and session management.

### PostgreSQL Schema

```sql
-- Infrastructure Nodes
CREATE TABLE infrastructure_nodes (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(20) CHECK (type IN ('hub', 'spoke', 'experimentation')),
    provider VARCHAR(20) CHECK (provider IN ('hetzner', 'digitalocean', 'azure')),
    region VARCHAR(50),
    resources JSONB,
    networking JSONB,
    status VARCHAR(20) DEFAULT 'active',
    monitoring JSONB,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Service Instances  
CREATE TABLE service_instances (
    id VARCHAR(255) PRIMARY KEY,
    service_id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(20) CHECK (type IN ('web', 'api', 'database', 'cache', 'monitoring', 'utility')),
    node_id VARCHAR(255) REFERENCES infrastructure_nodes(id),
    container_config JSONB,
    networking_config JSONB,
    monitoring_config JSONB,
    status JSONB,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Monitoring Metrics
CREATE TABLE monitoring_metrics (
    id VARCHAR(255) PRIMARY KEY,
    source VARCHAR(50) CHECK (source IN ('datadog', 'newrelic', 'sentry', 'consul', 'portainer', 'caddy')),
    type VARCHAR(50) CHECK (type IN ('infrastructure', 'application', 'business', 'security')),
    entity_id VARCHAR(255),
    entity_type VARCHAR(20) CHECK (entity_type IN ('node', 'service', 'container', 'endpoint')),
    metric_data JSONB,
    dimensions JSONB,
    thresholds JSONB,
    correlation JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Deployment Events
CREATE TABLE deployment_events (
    id VARCHAR(255) PRIMARY KEY,
    service_instance_id VARCHAR(255) REFERENCES service_instances(id),
    deployment_config JSONB,
    changes JSONB,
    status JSONB,
    timing JSONB,
    monitoring_impact JSONB,
    git_metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Configuration Templates
CREATE TABLE configuration_templates (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    environment VARCHAR(20) CHECK (environment IN ('development', 'staging', 'production')),
    scope VARCHAR(20) CHECK (scope IN ('global', 'service', 'node')),
    doppler_config JSONB,
    variables JSONB,
    validation_rules JSONB,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Learning Progress
CREATE TABLE learning_milestones (
    id VARCHAR(255) PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    milestone VARCHAR(255) NOT NULL,
    description TEXT,
    completed_at TIMESTAMP WITH TIME ZONE,
    evidence JSONB,
    related_services TEXT[],
    difficulty_level INTEGER CHECK (difficulty_level BETWEEN 1 AND 5),
    time_invested_hours DECIMAL(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_service_instances_node_id ON service_instances(node_id);
CREATE INDEX idx_monitoring_metrics_entity ON monitoring_metrics(entity_id, entity_type);
CREATE INDEX idx_monitoring_metrics_timestamp ON monitoring_metrics(timestamp);
CREATE INDEX idx_deployment_events_service ON deployment_events(service_instance_id);
CREATE INDEX idx_deployment_events_timestamp ON deployment_events(created_at);
CREATE INDEX idx_learning_milestones_category ON learning_milestones(category);
```

## Unified Project Structure

The monorepo structure accommodates both infrastructure code and enterprise tool integration while supporting the staged learning approach:

```
hbohlen-io/
├── .github/                           # CI/CD workflows and GitHub integration
│   └── workflows/
│       ├── ci.yaml                    # GitHub Actions primary pipeline
│       ├── deploy.yaml                # Deployment automation
│       ├── quality-gates.yaml         # CodeScene + Codecov integration
│       └── azure-experiments.yaml     # Azure experimentation workflows
├── apps/                              # Application packages
│   ├── infrastructure-api/            # Infrastructure management API
│   │   ├── src/
│   │   │   ├── routes/                # API endpoints (nodes, services, monitoring)
│   │   │   ├── services/              # Business logic for infrastructure management
│   │   │   ├── integrations/          # External API integrations (Datadog, New Relic, etc.)
│   │   │   ├── middleware/            # Authentication, rate limiting, CORS
│   │   │   ├── models/                # Database models and validation
│   │   │   └── server.ts              # Fastify server setup
│   │   ├── tests/                     # API tests with BrowserStack integration
│   │   └── package.json
│   ├── monitoring-dashboard/          # React-based monitoring interface
│   │   ├── src/
│   │   │   ├── components/            # UI components for monitoring visualization
│   │   │   ├── pages/                 # Dashboard pages (nodes, services, deployments)
│   │   │   ├── hooks/                 # Custom hooks for API integration
│   │   │   ├── services/              # API client for infrastructure API
│   │   │   ├── stores/                # Zustand state management
│   │   │   └── utils/                 # Dashboard utilities
│   │   ├── public/                    # Static assets
│   │   ├── tests/                     # Frontend tests with BrowserStack
│   │   └── package.json
│   └── learning-analytics/            # Learning progress tracking
│       ├── src/
│       │   ├── collectors/            # Data collection from operational systems
│       │   ├── analyzers/             # Learning pattern analysis
│       │   ├── generators/            # Documentation and portfolio generation
│       │   └── interfaces/            # Learning dashboard components
│       └── package.json
├── packages/                          # Shared packages
│   ├── shared-types/                  # TypeScript interfaces for all systems
│   │   ├── src/
│   │   │   ├── infrastructure/        # Infrastructure data models
│   │   │   ├── monitoring/            # Monitoring and metrics types
│   │   │   ├── deployment/            # Deployment and CI/CD types
│   │   │   └── api/                   # API request/response types
│   │   └── package.json
│   ├── monitoring-sdk/                # Shared monitoring integration
│   │   ├── src/
│   │   │   ├── datadog/              # Datadog integration utilities
│   │   │   ├── newrelic/             # New Relic integration utilities
│   │   │   ├── sentry/               # Sentry integration utilities
│   │   │   └── correlator/           # Cross-tool metric correlation
│   │   └── package.json
│   └── deployment-utils/              # Shared deployment utilities
│       ├── src/
│       │   ├── github-actions/       # GitHub Actions integration
│       │   ├── travis-ci/            # Travis CI integration
│       │   ├── portainer/            # Portainer API utilities
│       │   └── health-checks/        # Service health verification
│       └── package.json
├── infrastructure/                    # Infrastructure as Code
│   ├── docker-compose/               # Service orchestration
│   │   ├── development/              # Local development environment
│   │   ├── staging/                  # Staging environment with full monitoring
│   │   └── production/               # Production environment
│   ├── caddy/                        # Reverse proxy configurations
│   │   ├── Caddyfile.production      # Production routing configuration
│   │   ├── Caddyfile.staging         # Staging environment
│   │   └── modules/                  # Custom Caddy modules
│   ├── consul/                       # Service discovery configurations
│   │   ├── server/                   # Consul server configuration
│   │   ├── agents/                   # Consul agent configurations
│   │   └── policies/                 # ACL and security policies
│   ├── monitoring/                   # Enterprise monitoring configurations
│   │   ├── datadog/                  # Datadog dashboards and alerts
│   │   ├── newrelic/                 # New Relic configuration and alerts
│   │   ├── sentry/                   # Sentry project configurations
│   │   └── honeybadger/              # Uptime monitoring configuration
│   ├── azure/                        # Azure experimentation resources
│   │   ├── arm-templates/            # Azure Resource Manager templates
│   │   ├── container-instances/      # Azure Container Instance configs
│   │   └── monitoring/               # Azure Monitor integration
│   └── security/                     # Security configurations
│       ├── tailscale/                # Mesh network security policies
│       ├── ssl-certificates/         # Certificate management
│       └── access-controls/          # Authentication and authorization
├── services/                         # Individual service implementations
│   ├── falkordb-browser/            # Existing FalkorDB Browser service
│   ├── mcp-servers/                 # Custom MCP server implementations
│   │   ├── graphiti-mcp/            # GraphITI MCP server
│   │   └── custom-mcp/              # Additional MCP services
│   ├── monitoring-services/         # Custom monitoring and analytics
│   └── learning-platform/           # Learning progress and documentation services
├── environments/                     # Environment-specific configurations
│   ├── development/                  # Local development with Docker Compose
│   ├── staging/                      # Full staging environment with monitoring
│   └── production/                   # Production environment configuration
├── quality/                          # Quality assurance and testing
│   ├── codecov/                     # Code coverage configurations
│   ├── codescene/                   # Code quality analysis
│   ├── browser-tests/               # BrowserStack/LambdaTest configurations
│   ├── performance/                 # Blackfire performance test configurations
│   └── security/                    # Security scanning and validation
├── docs/                            # Comprehensive documentation
│   ├── architecture/                # Technical architecture documentation
│   │   ├── decisions/               # Architecture Decision Records
│   │   ├── patterns/                # Infrastructure pattern documentation
│   │   └── integration/             # Tool integration guides
│   ├── learning/                    # Educational content and progress tracking
│   │   ├── milestones/              # Learning milestone documentation
│   │   ├── tutorials/               # Step-by-step learning guides
│   │   └── comparisons/             # Tool and approach comparisons
│   ├── operations/                  # Operational runbooks and procedures
│   │   ├── runbooks/                # Incident response and maintenance
│   │   ├── troubleshooting/         # Common issues and solutions
│   │   └── monitoring/              # Monitoring and alerting procedures
│   └── api/                         # API documentation (Bump.sh generated)
├── scripts/                         # Automation and deployment scripts
│   ├── setup/                       # Initial environment setup
│   ├── deployment/                  # Deployment automation
│   ├── monitoring/                  # Monitoring setup and configuration
│   └── backup/                      # Backup and recovery scripts
├── .env.example                     # Environment variable template
├── package.json                     # Root package.json with workspace configuration
├── docker-compose.yml               # Local development environment
└── README.md                        # Project overview and setup instructions
```

## Development Workflow

The development workflow integrates enterprise tools and patterns while maintaining focus on infrastructure learning objectives.

### Local Development Setup

#### Prerequisites
```bash
# Install required tools
node --version  # v20 LTS required
docker --version  # v24+ required
npm install -g @doppler/cli

# Verify GitHub Education Pack access
gh auth status
doppler --version
```

#### Initial Setup
```bash
# Clone repository and setup workspace
git clone https://github.com/hbohlen/hbohlen-io.git
cd hbohlen-io
npm install

# Setup Doppler configuration
doppler setup --project hbohlen-io --config development
doppler secrets download --no-file --format env > .env.local

# Setup Tailscale for local development
sudo tailscale up --accept-routes

# Initialize local infrastructure
docker-compose up -d postgres redis
npm run setup:infrastructure
```

#### Development Commands
```bash
# Start all services for full-stack development
npm run dev:all

# Start infrastructure API only
npm run dev:api

# Start monitoring dashboard only  
npm run dev:dashboard

# Start learning analytics service
npm run dev:learning

# Run comprehensive tests
npm run test:all
npm run test:integration
npm run test:e2e:browserstack

# Quality checks
npm run lint:codescene
npm run coverage:codecov
npm run performance:blackfire
```

### Environment Configuration

#### Required Environment Variables

```bash
# Frontend (.env.local)
VITE_API_BASE_URL=http://localhost:3000/v1
VITE_SIMPLE_ANALYTICS_ID=your_analytics_id
VITE_SENTRY_DSN=your_sentry_dsn

# Backend (.env)
DATABASE_URL=postgresql://user:pass@localhost:5432/hbohlen_io
REDIS_URL=redis://localhost:6379
DOPPLER_TOKEN=your_doppler_token

# Monitoring Integration
DATADOG_API_KEY=your_datadog_api_key
DATADOG_APP_KEY=your_datadog_app_key  
NEW_RELIC_LICENSE_KEY=your_newrelic_key
SENTRY_DSN=your_sentry_dsn
HONEYBADGER_API_KEY=your_honeybadger_key

# Infrastructure
TAILSCALE_AUTHKEY=your_tailscale_auth_key
CONSUL_HTTP_TOKEN=your_consul_token

# Azure Experimentation
AZURE_CLIENT_ID=your_azure_client_id
AZURE_CLIENT_SECRET=your_azure_client_secret
AZURE_TENANT_ID=your_azure_tenant_id

# Testing Integration
BROWSERSTACK_USERNAME=your_browserstack_user
BROWSERSTACK_ACCESS_KEY=your_browserstack_key
LAMBDATEST_USERNAME=your_lambdatest_user  
LAMBDATEST_ACCESS_KEY=your_lambdatest_key
```

This development workflow enables rapid iteration while maintaining enterprise-grade practices and comprehensive monitoring integration throughout the development process.

## Deployment Architecture

The deployment strategy leverages the hybrid multi-cloud approach with comprehensive CI/CD integration across GitHub Actions and Travis CI.

### Deployment Strategy

**Frontend Deployment:**
- **Platform:** GitHub Pages for documentation, Caddy reverse proxy for dashboards
- **Build Command:** `npm run build:dashboard && npm run build:learning`
- **Output Directory:** `dist/` (Vite optimized builds)
- **CDN/Edge:** Cloudflare for static assets, SimpleAnalytics for usage tracking

**Backend Deployment:**
- **Platform:** Docker containers across VPS nodes via Portainer
- **Build Command:** `docker build -t ghcr.io/hbohlen/infrastructure-api:latest`
- **Deployment Method:** GitOps via GitHub Actions with Portainer API integration

**Infrastructure Deployment:**
- **Platform:** Multi-VPS with Hetzner (hub) + DigitalOcean (spokes) + Azure (experimentation)
- **Orchestration:** Portainer multi-node management with Consul service discovery
- **Configuration:** Doppler Team plan with environment-specific templates

### CI/CD Pipeline

```yaml
name: Infrastructure Deployment Pipeline
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality-gates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      # Quality checks with enterprise tools
      - name: CodeScene Analysis
        uses: empear-analytics/codescene-ci-cd@v1
        with:
          codescene-delta-analysis: true
          
      - name: Test Coverage
        run: |
          npm run test:coverage
          npx codecov
          
      # Build and test
      - name: Build Infrastructure API
        run: npm run build:api
        
      - name: Build Monitoring Dashboard  
        run: npm run build:dashboard
        
      # Cross-platform testing
      - name: BrowserStack Tests
        run: npm run test:browserstack
        env:
          BROWSERSTACK_USERNAME: ${{ secrets.BROWSERSTACK_USERNAME }}
          BROWSERSTACK_ACCESS_KEY: ${{ secrets.BROWSERSTACK_ACCESS_KEY }}

  deploy-staging:
    needs: quality-gates
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Staging
        run: |
          # Deploy via Portainer API to staging environment
          npm run deploy:staging
        env:
          DOPPLER_TOKEN: ${{ secrets.DOPPLER_STAGING_TOKEN }}
          
      - name: Staging Health Checks
        run: npm run health-check:staging

  deploy-production:
    needs: quality-gates
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Production
        run: |
          # Deploy via Portainer API with monitoring integration
          npm run deploy:production
        env:
          DOPPLER_TOKEN: ${{ secrets.DOPPLER_PRODUCTION_TOKEN }}
          
      - name: Production Health Verification
        run: npm run health-check:production
        
      - name: Update Documentation
        run: |
          # Auto-update API docs via Bump.sh
          npx bump-sh deploy docs/api/openapi.yaml
```

### Environments

| Environment | Frontend URL | Backend URL | Purpose | Monitoring Integration |
|-------------|--------------|-------------|---------|----------------------|
| Development | http://localhost:3000 | http://localhost:3001 | Local development with Docker Compose | Basic Datadog + Sentry |
| Staging | https://staging.hbohlen.io | https://staging-api.hbohlen.io | Pre-production testing with full monitoring | Full enterprise monitoring stack |
| Production | https://hbohlen.io | https://api.hbohlen.io | Live environment with comprehensive observability | Complete monitoring + analytics |

## Security and Performance

### Security Requirements

**Frontend Security:**
- **CSP Headers:** `default-src 'self'; script-src 'self' 'unsafe-inline' scripts.simpleanalyticscdn.com; connect-src 'self' api.hbohlen.io browser-stack.com`
- **XSS Prevention:** React built-in protection + Content Security Policy + input sanitization
- **Secure Storage:** Encrypted localStorage for auth tokens, secure cookie configuration

**Backend Security:**
- **Input Validation:** Fastify schema validation + custom sanitization middleware
- **Rate Limiting:** Caddy-based rate limiting (100 req/min per IP) + API-level throttling
- **CORS Policy:** `https://*.hbohlen.io, http://localhost:3000` with credentials support

**Enterprise Security Integration:**
- **Monitoring:** Sentry security error tracking + Datadog security monitoring
- **Audit Logging:** Doppler configuration change audit + deployment event tracking
- **Access Control:** GitHub-based authentication + Tailscale network security

**Authentication Security:**
- **Token Storage:** JWT tokens in httpOnly cookies + localStorage fallback for development
- **Session Management:** Redis-based session storage with 24-hour expiration
- **Multi-Environment:** Separate authentication domains per environment

### Performance Optimization

**Frontend Performance:**
- **Bundle Size Target:** <500KB initial load, <100KB per route
- **Loading Strategy:** Route-based code splitting + React.lazy for dashboard components
- **Caching Strategy:** Browser caching + Cloudflare CDN + ServiceWorker for offline capability

**Backend Performance:**  
- **Response Time Target:** <200ms for API endpoints, <500ms for monitoring aggregation
- **Database Optimization:** PostgreSQL connection pooling + Redis caching for frequently accessed data
- **Monitoring Integration:** New Relic APM + Blackfire profiling for continuous optimization

**Enterprise Performance Monitoring:**
- **Real-time Metrics:** Datadog infrastructure monitoring + New Relic APM correlation
- **Performance Budgets:** Automated alerts when performance degrades beyond thresholds
- **Optimization Feedback:** Blackfire integration provides actionable performance recommendations

## Testing Strategy

### Testing Pyramid

```
           E2E Tests (BrowserStack/LambdaTest)
          /                                    \
    Integration Tests (API + Monitoring)
   /                                        \
Frontend Unit (Jest/RTL)              Backend Unit (Jest)
```

### Test Organization

#### Frontend Tests
```
apps/monitoring-dashboard/tests/
├── unit/                    # Component and utility tests
│   ├── components/         # React component tests with RTL
│   ├── hooks/              # Custom hook tests
│   ├── services/           # API client tests
│   └── utils/              # Utility function tests
├── integration/            # Cross-component integration tests
│   ├── dashboard/          # Dashboard integration tests
│   ├── api-integration/    # API client integration tests  
│   └── monitoring/         # Monitoring data integration tests
└── e2e/                    # End-to-end tests
    ├── browserstack/       # Cross-browser compatibility tests
    ├── lambdatest/         # Live testing scenarios
    └── user-journeys/      # Complete user workflow tests
```

#### Backend Tests
```
apps/infrastructure-api/tests/
├── unit/                   # Individual component tests
│   ├── routes/            # API endpoint tests
│   ├── services/          # Business logic tests
│   ├── integrations/      # External API integration tests
│   └── models/            # Data model tests
├── integration/           # Cross-component integration tests
│   ├── database/          # Database integration tests
│   ├── monitoring/        # Monitoring integration tests
│   ├── consul/            # Service discovery integration tests
│   └── doppler/           # Configuration management tests
└── e2e/                   # End-to-end API tests
    ├── deployment/        # Deployment workflow tests
    ├── monitoring/        # Monitoring data flow tests
    └── infrastructure/    # Infrastructure management tests
```

#### Enterprise Testing Integration
```
quality/
├── performance/           # Blackfire performance tests
│   ├── api-benchmarks/   # API performance benchmarks
│   ├── infrastructure/   # Infrastructure performance tests
│   └── monitoring/       # Monitoring overhead tests
├── security/             # Security testing with enterprise tools
│   ├── sentry-security/  # Security error pattern tests
│   ├── access-control/   # Authentication and authorization tests
│   └── audit-compliance/ # Audit log validation tests
└── cross-platform/       # BrowserStack/LambdaTest configurations
    ├── browser-matrix/   # Browser compatibility matrix
    ├── device-testing/   # Mobile device testing
    └── accessibility/    # WCAG compliance testing
```

### Test Examples

#### Frontend Component Test
```typescript
import { render, screen, waitFor } from '@testing-library/react';
import { vi } from 'vitest';
import { InfrastructureNodeCard } from '@/components/InfrastructureNodeCard';
import { mockInfrastructureNode } from '@/tests/mocks';

describe('InfrastructureNodeCard', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('displays node information with monitoring integration', async () => {
    const mockNode = mockInfrastructureNode({
      name: 'hetzner-gateway-01',
      status: 'active',
      monitoring: {
        datadogHost: 'gateway-01',
        lastHealthCheck: new Date().toISOString(),
        uptime: 99.95
      }
    });

    render(<InfrastructureNodeCard node={mockNode} />);
    
    expect(screen.getByText('hetzner-gateway-01')).toBeInTheDocument();
    expect(screen.getByText('99.95% uptime')).toBeInTheDocument();
    
    // Verify monitoring integration
    await waitFor(() => {
      expect(screen.getByTestId('datadog-status')).toHaveClass('status-healthy');
    });
  });

  it('handles monitoring data unavailable gracefully', () => {
    const mockNode = mockInfrastructureNode({
      monitoring: { lastHealthCheck: null }
    });
    
    render(<InfrastructureNodeCard node={mockNode} />);
    expect(screen.getByText('Monitoring data unavailable')).toBeInTheDocument();
  });
});
```

#### Backend API Test
```typescript
import { test, expect } from '@jest/globals';
import { build } from '../src/server';
import { setupTestDatabase, teardownTestDatabase } from './helpers/database';

describe('/infrastructure/nodes API', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    await setupTestDatabase();
    app = build({ logger: false });
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
    await teardownTestDatabase();
  });

  test('GET /infrastructure/nodes returns nodes with monitoring integration', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/v1/infrastructure/nodes',
      headers: {
        'Authorization': 'Bearer test-token'
      }
    });

    expect(response.statusCode).toBe(200);
    const data = JSON.parse(response.payload);
    
    expect(data.nodes).toHaveLength(2);
    expect(data.nodes[0]).toHaveProperty('monitoring.datadogHost');
    expect(data.metadata.monitoring_integrated).toBeGreaterThan(0);
  });

  test('POST /infrastructure/nodes creates node with monitoring setup', async () => {
    const newNode = {
      name: 'test-node-01',
      type: 'spoke',
      provider: 'digitalocean',
      region: 'eu-west',
      resources: { cpu: 1, memory: 2, storage: 25, bandwidth: 1000 }
    };

    const response = await app.inject({
      method: 'POST',
      url: '/v1/infrastructure/nodes',
      headers: { 'Authorization': 'Bearer test-token' },
      payload: newNode
    });

    expect(response.statusCode).toBe(201);
    const data = JSON.parse(response.payload);
    expect(data.node.monitoring.datadogHost).toBeDefined();
  });
});
```

#### E2E Test with Enterprise Integration
```typescript
import { test, expect } from '@playwright/test';

test.describe('Infrastructure Management E2E', () => {
  test('complete service deployment workflow', async ({ page }) => {
    // Navigate to monitoring dashboard
    await page.goto('https://staging.hbohlen.io/dashboard');
    
    // Verify enterprise monitoring integration
    await expect(page.locator('[data-testid="datadog-status"]')).toBeVisible();
    await expect(page.locator('[data-testid="newrelic-status"]')).toBeVisible();
    await expect(page.locator('[data-testid="sentry-status"]')).toBeVisible();
    
    // Test service deployment
    await page.click('[data-testid="deploy-service-button"]');
    await page.fill('[data-testid="service-name"]', 'test-service-e2e');
    await page.selectOption('[data-testid="target-node"]', 'digitalocean-spoke-01');
    
    await page.click('[data-testid="deploy-submit"]');
    
    // Wait for deployment completion
    await expect(page.locator('[data-testid="deployment-status"]')).toHaveText('completed', { timeout: 60000 });
    
    // Verify service is accessible
    const serviceUrl = await page.locator('[data-testid="service-url"]').textContent();
    const serviceResponse = await page.request.get(serviceUrl);
    expect(serviceResponse.status()).toBe(200);
    
    // Verify monitoring integration
    await expect(page.locator('[data-testid="service-health"]')).toHaveText('healthy');
    await expect(page.locator('[data-testid="consul-registered"]')).toBeVisible();
  });
});
```

## Coding Standards

### Critical Fullstack Rules

- **Type Sharing:** Always define types in packages/shared-types and import consistently across frontend/backend
- **API Integration:** Never make direct HTTP calls - use the monitoring-sdk and shared service layer
- **Environment Variables:** Access only through Doppler configuration objects, never process.env directly
- **Error Handling:** All API routes must use standardized error handler with Sentry integration
- **Monitoring Integration:** Every service must integrate with Datadog, New Relic, and Sentry from deployment
- **Service Discovery:** Services must register with Consul on startup and implement health checks
- **Configuration Management:** All configuration through Doppler with environment-specific templates
- **Container Standards:** All services must include proper health checks, resource limits, and monitoring agents

### Naming Conventions

| Element | Frontend | Backend | Example |
|---------|----------|---------|---------|
| Components | PascalCase | - | `InfrastructureNodeCard.tsx` |
| Hooks | camelCase with 'use' | - | `useMonitoringData.ts` |
| API Routes | - | kebab-case | `/api/infrastructure-nodes` |
| Database Tables | - | snake_case | `infrastructure_nodes` |
| Environment Variables | SCREAMING_SNAKE_CASE | SCREAMING_SNAKE_CASE | `DATADOG_API_KEY` |
| Docker Images | kebab-case | kebab-case | `infrastructure-api:latest` |
| Consul Services | kebab-case | kebab-case | `falkordb-browser-service` |

## Error Handling Strategy

### Error Flow

```mermaid
sequenceDiagram
    participant Client as Frontend/External
    participant API as Infrastructure API
    participant Service as Backend Service
    participant Monitoring as Enterprise Monitoring
    participant Consul as Service Discovery
    
    Client->>API: Request
    API->>Service: Process request
    Service-->>API: Error occurs
    
    par Error Tracking
        API->>Monitoring: Log to Sentry
        API->>Monitoring: Metric to Datadog
        API->>Monitoring: Event to New Relic
    end
    
    API->>Consul: Check service health
    Consul-->>API: Service status
    
    API->>API: Generate standardized error response
    API-->>Client: Structured error with correlation ID
    
    par Alerting
        Monitoring->>Monitoring: Correlate across tools
        Monitoring->>Developer: Alert via Honeybadger
    end
```

### Error Response Format

```typescript
interface ApiError {
  error: {
    code: string;           // e.g., "SERVICE_UNAVAILABLE", "VALIDATION_ERROR"
    message: string;        // Human-readable error message
    details?: Record<string, any>;  // Additional context
    timestamp: string;      // ISO timestamp
    requestId: string;      // Correlation ID for monitoring
    monitoring: {
      sentryEventId?: string;
      datadogTraceId?: string;
      newrelicTraceId?: string;
    };
  };
}
```

### Frontend Error Handling

```typescript
import { useMonitoringIntegration } from '@/hooks/useMonitoringIntegration';

export const useErrorHandler = () => {
  const { trackError } = useMonitoringIntegration();

  const handleApiError = useCallback((error: ApiError) => {
    // Log to multiple monitoring systems
    trackError({
      error: error.error,
      context: 'api_call',
      correlationId: error.error.requestId
    });

    // Display user-friendly error
    toast.error(error.error.message, {
      description: `Request ID: ${error.error.requestId}`,
      action: {
        label: 'Report Issue',
        onClick: () => reportToGitHub(error)
      }
    });
  }, [trackError]);

  return { handleApiError };
};
```

### Backend Error Handling

```typescript
import { FastifyRequest, FastifyReply } from 'fastify';
import * as Sentry from '@sentry/node';
import { v4 as uuidv4 } from 'uuid';

export const errorHandler = async (
  error: Error,
  request: FastifyRequest,
  reply: FastifyReply
) => {
  const requestId = uuidv4();
  
  // Enterprise monitoring integration
  const sentryEventId = Sentry.captureException(error, {
    tags: {
      requestId,
      endpoint: request.url,
      method: request.method
    }
  });

  // Datadog custom metric
  await datadogClient.increment('api.errors', 1, {
    endpoint: request.url,
    error_type: error.constructor.name
  });

  // New Relic error tracking
  newrelic.recordCustomEvent('ApiError', {
    requestId,
    endpoint: request.url,
    errorMessage: error.message
  });

  const apiError: ApiError = {
    error: {
      code: getErrorCode(error),
      message: getUserFriendlyMessage(error),
      timestamp: new Date().toISOString(),
      requestId,
      monitoring: {
        sentryEventId,
        datadogTraceId: request.headers['x-datadog-trace-id'],
        newrelicTraceId: request.headers['x-newrelic-trace-id']
      }
    }
  };

  reply.status(getStatusCode(error)).send(apiError);
};
```

## Monitoring and Observability

### Monitoring Stack

**Infrastructure Monitoring:** Datadog Pro (10 servers, $240/month value) - Server metrics, container monitoring, custom dashboards
**Application Performance:** New Relic Full Platform ($300/month value) - APM, performance insights, deployment tracking
**Error Tracking:** Sentry Education Tier (50K errors, team features, $29/month value) - Error monitoring, performance tracking
**Uptime Monitoring:** Honeybadger Small Plan ($39/month value) - Service availability, cron job monitoring, alert escalation
**Usage Analytics:** SimpleAnalytics Starter Plan (100K pageviews, $19/month value) - Privacy-friendly usage tracking

### Key Metrics

**Frontend Metrics:**
- Core Web Vitals (LCP, FID, CLS) tracked via SimpleAnalytics
- JavaScript errors and performance issues tracked via Sentry
- API response times monitored through New Relic browser agent
- User interaction patterns tracked via privacy-friendly analytics

**Backend Metrics:**
- Request rate, error rate, response time tracked via Datadog APM
- Database query performance monitored through New Relic APM
- Container resource utilization tracked via Datadog infrastructure monitoring
- Service discovery health tracked via Consul + Datadog integration

**Infrastructure Metrics:**
- VPS resource utilization (CPU, memory, disk, network) via Datadog
- Container orchestration metrics via Portainer + Datadog integration
- Network latency and connectivity via Tailscale + custom monitoring
- SSL certificate expiration and renewal tracking via Caddy + Honeybadger

**Learning Metrics:**
- Infrastructure pattern mastery progress tracked via custom Learning Analytics component
- Tool integration complexity and time investment tracked for optimization
- Deployment success rates and learning velocity measured across CI/CD tools
- Knowledge sharing and community contribution tracked via documentation analytics

This comprehensive architecture provides enterprise-grade infrastructure learning experience while maintaining practical implementation feasibility and clear progression toward professional competency.
