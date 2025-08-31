# Epic 3: Automated Service Deployment (GitOps)

### Trigger Conditions
- GitHub Actions deployment failures
- Service deployment breaking existing functionality
- Docker image build failures
- Configuration deployment errors

### Recovery Objectives
- **RTO:** 15 minutes
- **RPO:** Last known good deployment state

### Automated Rollback Script
```bash
#!/bin/bash
# rollback-epic3.sh - GitOps Deployment Rollback

echo "=== Epic 3 Rollback: GitOps Deployment ==="

# Get last successful deployment tag
LAST_GOOD_TAG=$(git tag --sort=-version:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -1)

if [ -z "$LAST_GOOD_TAG" ]; then
    echo "No previous version tag found, using main branch"
    LAST_GOOD_TAG="main"
fi

echo "Rolling back to: $LAST_GOOD_TAG"

# Checkout previous version
git checkout $LAST_GOOD_TAG

# Redeploy with previous configuration
docker-compose -f infrastructure/docker-compose.yml down
docker-compose -f infrastructure/docker-compose.yml up -d

# Verify deployment
docker-compose ps
echo "GitOps rollback to $LAST_GOOD_TAG complete."
```

### Manual Procedures
1. **Identify Last Good State:**
   ```bash
   git log --oneline -10  # Find last successful commit
   git tag --list  # Check for version tags
   ```

2. **Checkout Previous Version:**
   ```bash
   git checkout <last-good-commit-or-tag>
   ```

3. **Manual Redeploy:**
   ```bash
   docker-compose -f infrastructure/docker-compose.yml down
   docker-compose -f infrastructure/docker-compose.yml up -d
   ```

4. **Verify Services:**
   ```bash
   docker-compose ps
   curl http://localhost:8080/health  # FalkorDB
   ```

### Validation Steps
- [ ] All services running (docker-compose ps)
- [ ] Existing FalkorDB Browser functional
- [ ] GitHub Actions status shows successful deployment
- [ ] No deployment-related errors in logs