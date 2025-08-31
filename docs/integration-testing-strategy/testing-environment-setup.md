# Testing Environment Setup

### Staging Environment Configuration

```yaml
# infrastructure/docker-compose.staging.yml
version: '3.8'
services:
  # Core infrastructure (always running)
  caddy:
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./caddy/Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
    networks:
      - hbohlen-network

  # Existing service (FalkorDB Browser)
  falkordb-browser:
    image: falkordb/falkordb-browser:latest
    ports:
      - "8080:8080"
    environment:
      - FALKORDB_URL=http://falkordb:6379
    networks:
      - hbohlen-network
    depends_on:
      - falkordb

  # Test services for integration validation
  integration-tester:
    image: curlimages/curl:latest
    networks:
      - hbohlen-network
    profiles:
      - testing

networks:
  hbohlen-network:
    driver: bridge

volumes:
  caddy_data:
```

### Test Data Setup

```bash
#!/bin/bash
# setup-integration-test-data.sh

echo "Setting up integration test data..."

# Create test database entries
docker exec falkordb redis-cli SET test:key "integration-test-value"

# Configure test domains
echo "test.hbohlen.io integration test service" >> /etc/hosts

# Set up test certificates
mkdir -p /opt/caddy/test-certs
openssl req -x509 -newkey rsa:4096 -keyout /opt/caddy/test-certs/key.pem \
  -out /opt/caddy/test-certs/cert.pem -days 365 -nodes \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=test.hbohlen.io"

echo "Integration test data setup complete."
```