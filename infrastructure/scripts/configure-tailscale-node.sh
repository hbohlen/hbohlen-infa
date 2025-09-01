#!/bin/bash

# Tailscale Node Configuration Script
# Configures node naming, authentication, and basic settings

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
    echo "Configure Tailscale node settings"
    echo
    echo "OPTIONS:"
    echo "  -n, --node-name NAME    Set the node name (hostname)"
    echo "  -a, --auth-key KEY      Use auth key for authentication (non-interactive)"
    echo "  -t, --tags TAGS         Set node tags (comma-separated)"
    echo "  --advertise-routes      Advertise routes to other nodes"
    echo "  --accept-routes          Accept routes from other nodes"
    echo "  --reset                  Reset Tailscale configuration"
    echo "  -h, --help              Display this help message"
    echo
    echo "EXAMPLES:"
    echo "  $0 --node-name gateway-hetzner"
    echo "  $0 --auth-key tskey-abc123 --node-name service-do-1"
    echo "  $0 --advertise-routes --accept-routes"
}

# Function to set node name
set_node_name() {
    local node_name=$1

    if [ -z "$node_name" ]; then
        error "Node name cannot be empty"
        exit 1
    fi

    log "Setting node name to '$node_name'..."

    # Set system hostname
    sudo hostnamectl set-hostname "$node_name"

    # Update /etc/hosts if needed
    if ! grep -q "$node_name" /etc/hosts; then
        echo "127.0.0.1 $node_name" | sudo tee -a /etc/hosts >/dev/null
    fi

    success "Node name set to '$node_name'"
}

# Function to authenticate with auth key
authenticate_with_key() {
    local auth_key=$1

    if [ -z "$auth_key" ]; then
        error "Auth key cannot be empty"
        exit 1
    fi

    log "Authenticating with provided auth key..."

    # Bring up Tailscale with auth key
    sudo tailscale up --auth-key="$auth_key"

    success "Authentication initiated with auth key"
}

# Function to authenticate interactively
authenticate_interactive() {
    log "Starting interactive authentication..."

    echo
    warning "You will need to:"
    echo "1. Visit the authentication URL that will be displayed"
    echo "2. Sign in to your Tailscale account"
    echo "3. Authorize this node in your Tailscale admin console"
    echo
    read -p "Press Enter to continue with authentication..."

    # Bring up Tailscale (will show auth URL)
    sudo tailscale up

    success "Interactive authentication initiated"
}

# Function to set node tags
set_tags() {
    local tags=$1

    if [ -z "$tags" ]; then
        error "Tags cannot be empty"
        exit 1
    fi

    log "Setting node tags: $tags"

    # Convert comma-separated tags to space-separated with --advertise-tags
    tag_args=""
    IFS=',' read -ra TAG_ARRAY <<< "$tags"
    for tag in "${TAG_ARRAY[@]}"; do
        tag_args="$tag_args --advertise-tags=$tag"
    done

    # Re-authenticate with tags
    sudo tailscale up $tag_args

    success "Node tags configured"
}

# Function to advertise routes
advertise_routes() {
    log "Configuring route advertisement..."

    # Get current Tailscale IP
    local ts_ip
    ts_ip=$(tailscale ip -4 2>/dev/null || echo "")

    if [ -z "$ts_ip" ]; then
        error "Cannot determine Tailscale IP. Is the node authenticated?"
        exit 1
    fi

    # For gateway node, advertise default route
    # For service nodes, advertise their local subnet
    if [[ "$NODE_NAME" == *"gateway"* ]]; then
        sudo tailscale up --advertise-routes=0.0.0.0/0
        success "Gateway node configured to advertise default route"
    else
        # Get local subnet (assuming /24)
        local subnet
        subnet=$(ip route | grep -E "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+" | head -1 | awk '{print $1}')
        if [ -n "$subnet" ]; then
            sudo tailscale up --advertise-routes="$subnet"
            success "Service node configured to advertise subnet: $subnet"
        else
            warning "Could not determine local subnet for route advertisement"
        fi
    fi
}

# Function to accept routes
accept_routes() {
    log "Configuring to accept routes from other nodes..."

    sudo tailscale up --accept-routes

    success "Node configured to accept routes from other nodes"
}

# Function to reset configuration
reset_config() {
    log "Resetting Tailscale configuration..."

    warning "This will disconnect the node from your Tailscale network"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo tailscale down
        success "Tailscale configuration reset"
    else
        log "Reset cancelled"
    fi
}

# Function to display node status
show_status() {
    echo
    log "Current Tailscale Status:"
    echo "========================"

    if command -v tailscale >/dev/null 2>&1; then
        echo "Service Status:"
        sudo systemctl status tailscaled --no-pager -l | head -10

        echo
        echo "Tailscale Status:"
        tailscale status

        echo
        echo "IP Addresses:"
        tailscale ip -4
        tailscale ip -6 2>/dev/null || true
    else
        error "Tailscale is not installed"
    fi
}

# Parse command line arguments
NODE_NAME=""
AUTH_KEY=""
TAGS=""
ADVERTISE_ROUTES=false
ACCEPT_ROUTES=false
RESET=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--node-name)
            NODE_NAME="$2"
            shift 2
            ;;
        -a|--auth-key)
            AUTH_KEY="$2"
            shift 2
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
        --reset)
            RESET=true
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
    echo "  Tailscale Node Configuration"
    echo "==================================="
    echo

    # Handle reset first if requested
    if [ "$RESET" = true ]; then
        reset_config
        exit 0
    fi

    # Set node name if provided
    if [ -n "$NODE_NAME" ]; then
        set_node_name "$NODE_NAME"
    fi

    # Handle authentication
    if [ -n "$AUTH_KEY" ]; then
        authenticate_with_key "$AUTH_KEY"
    elif [ "$ADVERTISE_ROUTES" = true ] || [ "$ACCEPT_ROUTES" = true ] || [ -n "$TAGS" ]; then
        # If we need to re-authenticate, do it
        authenticate_interactive
    fi

    # Set tags if provided
    if [ -n "$TAGS" ]; then
        set_tags "$TAGS"
    fi

    # Configure route advertisement
    if [ "$ADVERTISE_ROUTES" = true ]; then
        advertise_routes
    fi

    # Configure route acceptance
    if [ "$ACCEPT_ROUTES" = true ]; then
        accept_routes
    fi

    # Show final status
    show_status

    echo
    success "Node configuration completed!"
}

# Run main function
main "$@"