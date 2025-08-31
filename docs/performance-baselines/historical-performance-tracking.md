# Historical Performance Tracking

### Baseline History Database

```sql
-- performance_baselines.sql
CREATE TABLE performance_baselines (
    id SERIAL PRIMARY KEY,
    collection_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    metric_name VARCHAR(100) NOT NULL,
    metric_value DECIMAL NOT NULL,
    unit VARCHAR(20),
    environment VARCHAR(20) DEFAULT 'production',
    notes TEXT
);

CREATE TABLE performance_regressions (
    id SERIAL PRIMARY KEY,
    baseline_id INTEGER REFERENCES performance_baselines(id),
    regression_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    metric_name VARCHAR(100),
    baseline_value DECIMAL,
    current_value DECIMAL,
    percentage_change DECIMAL,
    severity VARCHAR(20) CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    resolved BOOLEAN DEFAULT FALSE,
    resolution_notes TEXT
);

-- Index for performance
CREATE INDEX idx_baselines_date ON performance_baselines(collection_date);
CREATE INDEX idx_baselines_metric ON performance_baselines(metric_name);
CREATE INDEX idx_regressions_date ON performance_regressions(regression_date);
```

### Historical Analysis Script

```bash
#!/bin/bash
# analyze-performance-history.sh

echo "Analyzing Performance History..."
echo "==============================="

# Query baseline history
echo "Recent Baselines:"
psql -h localhost -d hbohlen_io -c "
SELECT
    collection_date,
    metric_name,
    metric_value,
    unit
FROM performance_baselines
WHERE collection_date >= NOW() - INTERVAL '30 days'
ORDER BY collection_date DESC, metric_name;
"

# Check for regressions
echo -e "\nPerformance Regressions:"
psql -h localhost -d hbohlen_io -c "
SELECT
    r.regression_date,
    r.metric_name,
    r.baseline_value,
    r.current_value,
    r.percentage_change,
    r.severity
FROM performance_regressions r
WHERE r.resolved = FALSE
ORDER BY r.regression_date DESC;
"

# Generate trend analysis
echo -e "\nPerformance Trends (Last 30 Days):"
psql -h localhost -d hbohlen_io -c "
SELECT
    metric_name,
    ROUND(AVG(metric_value), 2) as avg_value,
    ROUND(STDDEV(metric_value), 2) as std_dev,
    MIN(metric_value) as min_value,
    MAX(metric_value) as max_value,
    COUNT(*) as measurements
FROM performance_baselines
WHERE collection_date >= NOW() - INTERVAL '30 days'
GROUP BY metric_name
ORDER BY metric_name;
"
```