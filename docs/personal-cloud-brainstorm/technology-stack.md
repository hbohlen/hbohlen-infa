# 🛠️ Technology Stack

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