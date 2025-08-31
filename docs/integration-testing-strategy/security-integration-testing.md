# Security Integration Testing

### Authentication & Authorization Tests

```bash
#!/bin/bash
# security-integration-test.sh

echo "Running Security Integration Tests..."

# Test 1: SSL/TLS validation
echo "1. SSL/TLS validation..."
SSL_LABS=$(curl -s "https://api.ssllabs.com/api/v3/analyze?host=falkordb.hbohlen.io" | jq -r '.endpoints[0].grade')
if [ "$SSL_LABS" = "A" ] || [ "$SSL_LABS" = "A+" ]; then
    echo "✅ SSL grade: $SSL_LABS"
else
    echo "❌ SSL grade too low: $SSL_LABS"
    exit 1
fi

# Test 2: Network security
echo "2. Network security..."
nmap -sV --script ssl-enum-ciphers falkordb.hbohlen.io

# Test 3: Container security
echo "3. Container security..."
docker scan hbohlen/falkordb-browser

# Test 4: Access control
echo "4. Access control..."
curl -I http://localhost:8080  # Should redirect to HTTPS
curl -I https://falkordb.hbohlen.io/admin  # Should require auth if configured

echo "Security integration tests complete."
```