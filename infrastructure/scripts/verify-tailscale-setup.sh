#!/bin/bash

# Tailscale Setup Verification Script
# Verifies that Tailscale nodes are properly configured and connected

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Verify Tailscale node setup and connectivity"
    echo
    echo "OPTIONS:"
    echo "  -n, --node-name NAME    Expected node name"
    echo "  -p, --peer-ips IPS      Comma-separated list of expected peer IPs"
    echo "  -t, --test-connectivity Test connectivity to peer nodes"
    echo "  -r, --report-only       Only generate report, don't fix issues"
    echo "  -h, --help              Display this help message"
    echo
    echo "EXAMPLES:"
    echo "  $0 --node-name gateway-hetzner"
    echo "  $0 --test-connectivity --peer-ips 100.64.0.2,100.64.0.3"
}

# Function to check Tailscale installation
check_installation() {
    log "Checking Tailscale installation..."

    if ! command -v tailscale >/dev/null 2>&1; then
        error "Tailscale is not installed"
        return 1
    fi

    success "Tailscale is installed (version: $(tailscale version))"

    # Check if service is running
    if ! sudo systemctl is-active --quiet tailscaled; then
        error "Tailscale service is not running"
        return 1
    fi

    success "Tailscale service is running"
    return 0
}

# Function to check authentication status
check_authentication() {
    log "Checking authentication status..."

    local status
    status=$(tailscale status 2>/dev/null | head -1 || echo "")

    if [[ "$status" == *"Logged in"* ]] || [[ "$status" == *"Tailscale is up"* ]]; then
        success "Node is authenticated"
        return 0
    else
        error "Node is not authenticated"
        return 1
    fi
}

# Function to verify node name
verify_node_name() {
    local expected_name=$1

    if [ -z "$expected_name" ]; then
        log "Skipping node name verification (not specified)"
        return 0
    fi

    log "Verifying node name..."

    local current_name
    current_name=$(hostname)

    if [ "$current_name" = "$expected_name" ]; then
        success "Node name is correct: $current_name"
        return 0
    else
        error "Node name mismatch. Expected: $expected_name, Current: $current_name"
        return 1
    fi
}

# Function to check IP addresses
check_ip_addresses() {
    log "Checking IP addresses..."

    local ipv4
    local ipv6

    ipv4=$(tailscale ip -4 2>/dev/null || echo "")
    ipv6=$(tailscale ip -6 2>/dev/null || echo "")

    if [ -n "$ipv4" ]; then
        success "IPv4 address: $ipv4"
    else
        error "No IPv4 address assigned"
        return 1
    fi

    if [ -n "$ipv6" ]; then
        success "IPv6 address: $ipv6"
    else
        warning "No IPv6 address assigned (this is normal)"
    fi

    return 0
}

# Function to test connectivity to peers
test_peer_connectivity() {
    local peer_ips=$1

    if [ -z "$peer_ips" ]; then
        log "Skipping peer connectivity test (no peers specified)"
        return 0
    fi

    log "Testing connectivity to peer nodes..."

    local failed_peers=()

    IFS=',' read -ra PEER_ARRAY <<< "$peer_ips"
    for peer_ip in "${PEER_ARRAY[@]}"; do
        peer_ip=$(echo "$peer_ip" | xargs)  # Trim whitespace

        log "Testing connection to $peer_ip..."

        if ping -c 3 -W 5 "$peer_ip" >/dev/null 2>&1; then
            success "Connectivity to $peer_ip: OK"
        else
            error "Connectivity to $peer_ip: FAILED"
            failed_peers+=("$peer_ip")
        fi
    done

    if [ ${#failed_peers[@]} -eq 0 ]; then
        success "All peer connectivity tests passed"
        return 0
    else
        error "Failed to connect to ${#failed_peers[@]} peer(s): ${failed_peers[*]}"
        return 1
    fi
}

# Function to check network status
check_network_status() {
    log "Checking network status..."

    local status_output
    status_output=$(tailscale status 2>/dev/null || echo "")

    if [ -z "$status_output" ]; then
        error "Unable to get network status"
        return 1
    fi

    # Check for common issues
    if echo "$status_output" | grep -q "stopped"; then
        error "Tailscale is stopped"
        return 1
    fi

    if echo "$status_output" | grep -q "NeedsLogin"; then
        error "Node needs to log in"
        return 1
    fi

    success "Network status: OK"
    return 0
}

# Function to check firewall rules
check_firewall() {
    log "Checking firewall configuration..."

    # Check if ufw is active
    if command -v ufw >/dev/null 2>&1; then
        if sudo ufw status | grep -q "Status: active"; then
            log "UFW firewall is active"

            # Check if Tailscale interface is allowed
            if sudo ufw status | grep -q "tailscale0"; then
                success "Tailscale interface is configured in firewall"
            else
                warning "Tailscale interface not found in firewall rules"
                warning "You may need to add: sudo ufw allow in on tailscale0"
            fi
        else
            success "UFW firewall is not active"
        fi
    elif command -v firewall-cmd >/dev/null 2>&1; then
        log "firewalld detected"

        if sudo firewall-cmd --state 2>/dev/null | grep -q "running"; then
            # Check if tailscale zone exists
            if sudo firewall-cmd --get-zones | grep -q "tailscale"; then
                success "Tailscale zone exists in firewalld"
            else
                warning "Tailscale zone not found in firewalld"
            fi
        else
            success "firewalld is not running"
        fi
    else
        log "No supported firewall detected"
    fi

    return 0
}

# Function to generate verification report
generate_report() {
    local node_name=$1
    local peer_ips=$2
    local connectivity_tested=$3

    echo
    echo "========================================"
    echo "  Tailscale Setup Verification Report"
    echo "========================================"
    echo
    echo "Verification Date: $(date)"
    echo "Node Name: $(hostname)"
    echo "Expected Name: ${node_name:-Not specified}"
    echo

    # Installation status
    if check_installation >/dev/null 2>&1; then
        echo "✅ Installation: PASS"
    else
        echo "❌ Installation: FAIL"
    fi

    # Authentication status
    if check_authentication >/dev/null 2>&1; then
        echo "✅ Authentication: PASS"
    else
        echo "❌ Authentication: FAIL"
    fi

    # Node name verification
    if [ -n "$node_name" ] && verify_node_name "$node_name" >/dev/null 2>&1; then
        echo "✅ Node Name: PASS"
    elif [ -z "$node_name" ]; then
        echo "⚠️  Node Name: SKIPPED (not specified)"
    else
        echo "❌ Node Name: FAIL"
    fi

    # IP addresses
    if check_ip_addresses >/dev/null 2>&1; then
        echo "✅ IP Addresses: PASS"
    else
        echo "❌ IP Addresses: FAIL"
    fi

    # Network status
    if check_network_status >/dev/null 2>&1; then
        echo "✅ Network Status: PASS"
    else
        echo "❌ Network Status: FAIL"
    fi

    # Peer connectivity
    if [ "$connectivity_tested" = true ] && test_peer_connectivity "$peer_ips" >/dev/null 2>&1; then
        echo "✅ Peer Connectivity: PASS"
    elif [ "$connectivity_tested" = false ]; then
        echo "⚠️  Peer Connectivity: SKIPPED"
    else
        echo "❌ Peer Connectivity: FAIL"
    fi

    echo
    echo "Detailed Status:"
    echo "================"

    echo "Tailscale Status:"
    tailscale status 2>/dev/null || echo "Unable to get status"

    echo
    echo "IP Addresses:"
    tailscale ip -4 2>/dev/null || echo "No IPv4"
    tailscale ip -6 2>/dev/null || echo "No IPv6"

    echo
    echo "Network Interfaces:"
    ip link show | grep -E "(tailscale|wg)" || echo "No Tailscale interfaces found"
}

# Parse command line arguments
NODE_NAME=""
PEER_IPS=""
TEST_CONNECTIVITY=false
REPORT_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--node-name)
            NODE_NAME="$2"
            shift 2
            ;;
        -p|--peer-ips)
            PEER_IPS="$2"
            shift 2
            ;;
        -t|--test-connectivity)
            TEST_CONNECTIVITY=true
            shift
            ;;
        -r|--report-only)
            REPORT_ONLY=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    echo "==================================="
    echo "  Tailscale Setup Verification"
    echo "==================================="
    echo

    local all_checks_pass=true

    # Run all checks
    if ! check_installation; then
        all_checks_pass=false
    fi

    if ! check_authentication; then
        all_checks_pass=false
    fi

    if [ -n "$NODE_NAME" ] && ! verify_node_name "$NODE_NAME"; then
        all_checks_pass=false
    fi

    if ! check_ip_addresses; then
        all_checks_pass=false
    fi

    if ! check_network_status; then
        all_checks_pass=false
    fi

    if [ "$TEST_CONNECTIVITY" = true ] && ! test_peer_connectivity "$PEER_IPS"; then
        all_checks_pass=false
    fi

    # Check firewall (warning only, doesn't fail verification)
    check_firewall

    # Generate report
    generate_report "$NODE_NAME" "$PEER_IPS" "$TEST_CONNECTIVITY"

    echo
    if [ "$all_checks_pass" = true ]; then
        success "All verification checks passed!"
        exit 0
    else
        error "Some verification checks failed. Please review the issues above."
        exit 1
    fi
}

# Run main function
main "$@"