# Test Data Management

### Test Data Strategy

1. **Ephemeral Test Data:** Use temporary databases for integration tests
2. **Seed Data:** Pre-populated test data for consistent testing
3. **Cleanup Procedures:** Automated cleanup after test completion
4. **Data Isolation:** Separate test data from production data

### Test Data Scripts

```bash
#!/bin/bash
# setup-test-data.sh

echo "Setting up test data..."

# Create test database
docker exec postgres createdb integration_test

# Seed test data
docker exec -i postgres psql integration_test << EOF
CREATE TABLE test_metrics (
    id SERIAL PRIMARY KEY,
    metric_name VARCHAR(255),
    value DECIMAL,
    timestamp TIMESTAMP DEFAULT NOW()
);

INSERT INTO test_metrics (metric_name, value) VALUES
('cpu_usage', 45.5),
('memory_usage', 67.8),
('response_time', 0.234);
EOF

echo "Test data setup complete."
```