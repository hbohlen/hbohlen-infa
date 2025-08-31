# Manual Integration Testing Procedures

### Weekly Full Integration Test

**Preparation:**
1. Ensure staging environment is running
2. Verify all services are healthy
3. Check monitoring dashboards for baseline metrics

**Test Scenarios:**

#### Scenario 1: End-to-End Service Request
1. **Objective:** Validate complete request flow from external user to service
2. **Steps:**
   - Access https://falkordb.hbohlen.io from external network
   - Verify SSL certificate validity
   - Confirm service responds correctly
   - Check monitoring shows request in logs
3. **Success Criteria:**
   - Response time < 500ms
   - SSL certificate valid
   - Monitoring data captured
   - No errors in service logs

#### Scenario 2: Service Deployment Integration
1. **Objective:** Test GitOps deployment with monitoring integration
2. **Steps:**
   - Make configuration change in Git
   - Push change to trigger deployment
   - Monitor deployment progress in Portainer
   - Verify service health after deployment
   - Check monitoring alerts (if any)
3. **Success Criteria:**
   - Deployment completes within 5 minutes
   - Service remains accessible during deployment
   - Monitoring captures deployment metrics
   - No false positive alerts

#### Scenario 3: Multi-Node Orchestration
1. **Objective:** Validate container orchestration across nodes
2. **Steps:**
   - Deploy test service to specific node via Portainer
   - Verify service appears in correct node
   - Test inter-node communication
   - Check resource allocation
3. **Success Criteria:**
   - Service deploys to correct node
   - Inter-node communication works
   - Resource limits respected
   - Portainer shows correct status

#### Scenario 4: Monitoring Integration
1. **Objective:** Validate monitoring tools work together
2. **Steps:**
   - Generate test traffic to services
   - Check Datadog metrics collection
   - Verify New Relic APM data
   - Review Sentry error tracking
   - Compare data consistency across tools
3. **Success Criteria:**
   - All monitoring tools collect data
   - Metrics are consistent across tools
   - No data gaps or duplicates
   - Alert thresholds working