#!/bin/bash

# Tailscale Installation Script for DigitalOcean Service Node VPS
# This script installs and configures Tailscale on the secondary service node

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

# Function to detect OS and architecture
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v lsb_release >/dev/null 2>&1; then
            OS=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
            VERSION=$(lsb_release -sr)
        elif [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            VERSION=$VERSION_ID
        elif [ -f /etc/debian_version ]; then
            OS="debian"
            VERSION=$(cat /etc/debian_version)
        elif [ -f /etc/redhat-release ]; then
            OS="rhel"
            VERSION=$(cat /etc/redhat-release | sed 's/.*release \([0-9]\+\).*/\1/')
        else
            error "Unable to detect OS"
            exit 1
        fi
    else
        error "This script is designed for Linux systems only"
        exit 1
    fi

    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            ARCH="amd64"
            ;;
        aarch64)
            ARCH="arm64"
            ;;
        armv7l)
            ARCH="arm"
            ;;
        *)
            error "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    log "Detected OS: $OS $VERSION on $ARCH architecture"
}

# Function to install Tailscale
install_tailscale() {
    log "Installing Tailscale..."

    # Check if Tailscale is already installed
    if command -v tailscale >/dev/null 2>&1; then
        warning "Tailscale is already installed. Version: $(tailscale version)"
        return 0
    fi

    # Install Tailscale based on OS
    case $OS in
        ubuntu|debian)
            log "Installing Tailscale on $OS using apt..."

            # Add Tailscale's GPG key
            curl -fsSL https://pkgs.tailscale.com/stable/${OS}/${VERSION}/noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null

            # Add the Tailscale repository
            curl -fsSL https://pkgs.tailscale.com/stable/${OS}/${VERSION}.sources | sudo tee /etc/apt/sources.list.d/tailscale.sources >/dev/null

            # Update package list and install
            sudo apt-get update
            sudo apt-get install -y tailscale
            ;;

        centos|rhel|fedora)
            log "Installing Tailscale on $OS using yum/dnf..."

            # Add the Tailscale repository
            sudo yum-config-manager --add-repo https://pkgs.tailscale.com/stable/${OS}/tailscale.repo

            # Install Tailscale
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y tailscale
            else
                sudo yum install -y tailscale
            fi
            ;;

        *)
            error "Unsupported OS: $OS. Please install Tailscale manually."
            error "Visit: https://tailscale.com/download"
            exit 1
            ;;
    esac

    success "Tailscale installed successfully"
}

# Function to configure Tailscale service
configure_service() {
    log "Configuring Tailscale service..."

    # Enable and start Tailscale service
    sudo systemctl enable tailscaled
    sudo systemctl start tailscaled

    # Verify service is running
    if sudo systemctl is-active --quiet tailscaled; then
        success "Tailscale service is running"
    else
        error "Failed to start Tailscale service"
        exit 1
    fi
}

# Function to set node name
set_node_name() {
    log "Setting node name to 'service-do-1'..."

    # Create Tailscale configuration directory if it doesn't exist
    sudo mkdir -p /etc/tailscale

    # Set hostname for Tailscale (this will be the node name)
    sudo hostnamectl set-hostname service-do-1

    success "Node name configured as 'service-do-1'"
}

# Function to display next steps
display_next_steps() {
    echo
    log "Installation completed successfully!"
    echo
    warning "NEXT STEPS:"
    echo "1. Run the following command to authenticate this node:"
    echo "   sudo tailscale up"
    echo
    echo "2. Follow the authentication URL in your browser"
    echo "3. Accept the node in your Tailscale admin console"
    echo
    echo "4. Verify the node appears in your Tailscale network"
    echo "   tailscale ip -4"
    echo
    echo "5. Test connectivity with the gateway node"
    echo "   ping <gateway-tailscale-ip>"
}

# Main execution
main() {
    echo "=========================================="
    echo "  Tailscale Service Node Installation"
    echo "=========================================="
    echo

    log "Starting Tailscale installation on DigitalOcean Service Node..."

    detect_os
    install_tailscale
    configure_service
    set_node_name

    echo
    success "Tailscale installation script completed successfully!"
    display_next_steps
}

# Run main function
main "$@"