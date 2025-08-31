# 🏗️ Final Architecture Design

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
         │   Agent     │    │ • Consul    │ │   Agent     │
         │ • Consul    │    │   Agent     │ │ • Consul    │
         │   Agent     │    │             │ │   Agent     │
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