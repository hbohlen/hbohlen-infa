# Rollback Testing Procedures

### Pre-Deployment Testing
1. **Test Rollback Scripts:**
   ```bash
   # Test in staging environment
   ./rollback-epic1.sh --dry-run
   ./rollback-epic2.sh --dry-run
   ```

2. **Validate Recovery Objectives:**
   - Time rollback execution
   - Verify data integrity
   - Test service functionality

3. **Document Test Results:**
   - Actual RTO vs target
   - Any issues encountered
   - Lessons learned

### Post-Rollback Validation
1. **Service Health Checks:**
   ```bash
   # Check all critical services
   curl -f http://localhost:8080/health || echo "FalkorDB health check failed"
   curl -f http://localhost:9000/api/system/status || echo "Portainer health check failed"
   ```

2. **Performance Validation:**
   ```bash
   # Basic performance checks
   time curl http://localhost:8080/api/status
   docker stats --no-stream
   ```

3. **Log Analysis:**
   ```bash
   # Check for errors during rollback
   docker-compose logs --tail=50
   journalctl -u docker --since "10 minutes ago"
   ```