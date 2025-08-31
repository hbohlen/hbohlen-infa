# 📁 Repository Structure

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