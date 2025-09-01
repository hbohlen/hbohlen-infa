#!/bin/bash

# Tailscale Authentication Script
# Handles authentication of nodes with Tailscale network

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
    echo "Authenticate Tailscale node with network"
    echo
    echo "OPTIONS:"
    echo "  -k, --auth-key KEY      Use reusable auth key for authentication"
    echo "  -e, --ephemeral         Use ephemeral node (auto-removes on disconnect)"
    echo "  -t, --tags TAGS         Node tags (comma-separated, requires auth key)"
    echo "  --advertise-routes      Advertise routes to subnet"
    echo "  --accept-routes         Accept routes from other nodes"
    echo "  --force-reauth          Force re-authentication even if already connected"
    echo "  -w, --wait              Wait for authentication to complete"
    echo "  -h, --help              Display this help message"
    echo
    echo "EXAMPLES:"
    echo "  $0  # Interactive authentication"
    echo "  $0 --auth-key tskey-abc123"
    echo "  $0 --ephemeral --auth-key tskey-abc123"
    echo "  $0 --auth-key tskey-abc123 --advertise-routes --tags tag:server"
}

# Function to check if already authenticated
check_auth_status() {
    log "Checking current authentication status..."

    if ! command -v tailscale >/dev/null 2>&1; then
        error "Tailscale is not installed"
        exit 1
    fi

    # Check if tailscaled is running
    if ! sudo systemctl is-active --quiet tailscaled; then
        error "Tailscale service is not running"
        exit 1
    fi

    # Check current status
    local status
    status=$(tailscale status 2>/dev/null | head -1 || echo "")

    if [[ "$status" == *"Logged in"* ]] || [[ "$status" == *"Tailscale is up"* ]]; then
        success "Node is already authenticated"
        return 0
    else
        log "Node is not authenticated"
        return 1
    fi
}

# Function to authenticate with auth key
authenticate_with_key() {
    local auth_key=$1
    local ephemeral=$2
    local tags=$3
    local advertise_routes=$4
    local accept_routes=$5

    log "Authenticating with auth key..."

    # Build tailscale up command
    local cmd="sudo tailscale up --auth-key=$auth_key"

    if [ "$ephemeral" = true ]; then
        cmd="$cmd --ephemeral"
    fi

    if [ -n "$tags" ]; then
        # Convert comma-separated tags to individual --advertise-tags flags
        IFS=',' read -ra TAG_ARRAY <<< "$tags"
        for tag in "${TAG_ARRAY[@]}"; do
            cmd="$cmd --advertise-tags=$tag"
        done
    fi

    if [ "$advertise_routes" = true ]; then
        # Auto-detect and advertise local subnet
        local subnet
        subnet=$(ip route | grep -E "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+" | head -1 | awk '{print $1}')
        if [ -n "$subnet" ]; then
            cmd="$cmd --advertise-routes=$subnet"
            log "Advertising subnet: $subnet"
        fi
    fi

    if [ "$accept_routes" = true ]; then
        cmd="$cmd --accept-routes"
    fi

    log "Running: $cmd"
    eval "$cmd"

    success "Authentication command executed"
}

# Function to authenticate interactively
authenticate_interactive() {
    local advertise_routes=$1
    local accept_routes=$2

    log "Starting interactive authentication..."

    echo
    warning "INTERACTIVE AUTHENTICATION REQUIRED"
    echo "=================================="
    echo
    echo "You will need to:"
    echo "1. Complete authentication in your web browser"
    echo "2. Authorize this node in your Tailscale admin console"
    echo "3. Return here and press Enter to continue"
    echo
    read -p "Press Enter when ready to start authentication..."

    # Build tailscale up command
    local cmd="sudo tailscale up"

    if [ "$advertise_routes" = true ]; then
        # Auto-detect and advertise local subnet
        local subnet
        subnet=$(ip route | grep -E "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+" | head -1 | awk '{print $1}')
        if [ -n "$subnet" ]; then
            cmd="$cmd --advertise-routes=$subnet"
            log "Advertising subnet: $subnet"
        fi
    fi

    if [ "$accept_routes" = true ]; then
        cmd="$cmd --accept-routes"
    fi

    log "Running: $cmd"
    eval "$cmd"

    echo
    success "Authentication initiated. Please complete the process in your browser."
}

# Function to wait for authentication completion
wait_for_auth() {
    local timeout=${1:-300}  # Default 5 minutes
    local interval=5

    log "Waiting for authentication to complete (timeout: ${timeout}s)..."

    local elapsed=0
    while [ $elapsed -lt $timeout ]; do
        if tailscale status >/dev/null 2>&1; then
            local status
            status=$(tailscale status | head -1)
            if [[ "$status" == *"Logged in"* ]] || [[ "$status" == *"Tailscale is up"* ]]; then
                success "Authentication completed successfully"
                return 0
            fi
        fi

        sleep $interval
        elapsed=$((elapsed + interval))

        # Progress indicator
        if [ $((elapsed % 30)) -eq 0 ]; then
            log "Still waiting... (${elapsed}s elapsed)"
        fi
    done

    error "Authentication timeout after ${timeout} seconds"
    return 1
}

# Function to display authentication status
show_auth_status() {
    echo
    log "Authentication Status:"
    echo "====================="

    if tailscale status >/dev/null 2>&1; then
        echo "Status: $(tailscale status | head -1)"
        echo
        echo "IP Addresses:"
        tailscale ip -4 2>/dev/null
        tailscale ip -6 2>/dev/null
        echo
        echo "Network: $(tailscale status | grep "Network" | head -1 || echo "N/A")"
    else
        error "Unable to get Tailscale status"
    fi
}

# Parse command line arguments
AUTH_KEY=""
EPHEMERAL=false
TAGS=""
ADVERTISE_ROUTES=false
ACCEPT_ROUTES=false
FORCE_REAUTH=false
WAIT=false
WAIT_TIMEOUT=300

while [[ $# -gt 0 ]]; do
    case $1 in
        -k|--auth-key)
            AUTH_KEY="$2"
            shift 2
            ;;
        -e|--ephemeral)
            EPHEMERAL=true
            shift
            ;;
        -t|--tags)
            TAGS="$2"
            shift 2
            ;;
        --advertise-routes)
            ADVERTISE_ROUTES=true
            shift
            ;;
        --accept-routes)
            ACCEPT_ROUTES=true
            shift
            ;;
        --force-reauth)
            FORCE_REAUTH=true
            shift
            ;;
        -w|--wait)
            WAIT=true
            shift
            ;;
        --wait-timeout)
            WAIT_TIMEOUT="$2"
            shift 2
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
    echo "================================"
    echo "  Tailscale Authentication"
    echo "================================"
    echo

    # Check if already authenticated (unless force reauth)
    if [ "$FORCE_REAUTH" = false ] && check_auth_status; then
        show_auth_status
        echo
        log "Node is already authenticated. Use --force-reauth to re-authenticate."
        exit 0
    fi

    # If force reauth, bring down first
    if [ "$FORCE_REAUTH" = true ]; then
        log "Forcing re-authentication..."
        sudo tailscale down 2>/dev/null || true
        sleep 2
    fi

    # Authenticate based on provided options
    if [ -n "$AUTH_KEY" ]; then
        authenticate_with_key "$AUTH_KEY" "$EPHEMERAL" "$TAGS" "$ADVERTISE_ROUTES" "$ACCEPT_ROUTES"
    else
        authenticate_interactive "$ADVERTISE_ROUTES" "$ACCEPT_ROUTES"
    fi

    # Wait for completion if requested
    if [ "$WAIT" = true ]; then
        if wait_for_auth "$WAIT_TIMEOUT"; then
            show_auth_status
        else
            error "Authentication failed or timed out"
            exit 1
        fi
    else
        echo
        warning "Authentication initiated. Use 'tailscale status' to check completion."
        show_auth_status
    fi

    echo
    success "Authentication process completed!"
}

# Run main function
main "$@"