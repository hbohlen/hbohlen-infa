# 🌐 Domain Strategy

### Service Access Patterns

• falkordb.hbohlen.io → FalkorDB Browser
• mcp.hbohlen.io/{mcp_name} → Custom MCP servers
• consul.hbohlen.io → Service discovery UI
• portainer.hbohlen.io → Container management UI

### SSL/TLS Management

• Wildcard certificates for *.hbohlen.io
• Let's Encrypt automatic certificate generation
• Caddy automatic HTTPS for all services