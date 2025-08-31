# 🚀 Development Workflow

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