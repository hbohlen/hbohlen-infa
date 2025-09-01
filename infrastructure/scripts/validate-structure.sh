#!/bin/bash

# Infrastructure Directory Structure Validation Script
# Validates that the project structure matches architecture specifications

echo "=== Infrastructure Directory Structure Validation ==="
echo "Validating against architecture specifications from docs/architecture.md"
echo

# Required directories
REQUIRED_DIRS=(
    "infrastructure/docker-compose"
    "infrastructure/caddy"
    "infrastructure/consul"
    "infrastructure/monitoring"
    "infrastructure/security"
    "infrastructure/security/tailscale"
)

echo "Checking required directories:"
ALL_PRESENT=true

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir - PRESENT"
    else
        echo "❌ $dir - MISSING"
        ALL_PRESENT=false
    fi
done

echo
echo "Checking docker-compose file location:"
if [ -f "infrastructure/docker-compose/docker-compose.isolated.yml" ]; then
    echo "✅ docker-compose.isolated.yml properly located in infrastructure/docker-compose/"
else
    echo "❌ docker-compose.isolated.yml not found in expected location"
    ALL_PRESENT=false
fi

echo
if [ "$ALL_PRESENT" = true ]; then
    echo "🎉 SUCCESS: All infrastructure directory structure requirements met!"
    echo "Project structure now aligns with architecture specifications."
    exit 0
else
    echo "❌ FAILURE: Some requirements not met. Please check missing items above."
    exit 1
fi