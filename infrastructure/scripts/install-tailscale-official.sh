#!/bin/bash

# Official Tailscale Installation Script
# Uses Tailscale's own installation script which handles everything

set -e

echo "=== Official Tailscale Installation ==="
echo

# Check if already installed
if command -v tailscale >/dev/null 2>&1; then
    echo "✅ Tailscale is already installed"
    echo "   Version: $(tailscale version)"
    echo
    echo "To reinstall, first run:"
    echo "sudo apt remove --purge tailscale"
    echo "sudo systemctl stop tailscaled"
    echo "sudo systemctl disable tailscaled"
    exit 0
fi

echo "Installing Tailscale using official installer..."
echo "This will download and run the official Tailscale installation script."
echo

# Run the official Tailscale installation script
curl -fsSL https://tailscale.com/install.sh | sh

echo
echo "=== Installation Complete ==="
echo

# Check if installation was successful
if command -v tailscale >/dev/null 2>&1; then
    echo "✅ Tailscale installed successfully!"
    echo "   Version: $(tailscale version)"
    echo
    echo "Next steps:"
    echo "1. Enable service: sudo systemctl enable tailscaled"
    echo "2. Start service: sudo systemctl start tailscaled"
    echo "3. Authenticate: sudo tailscale up"
    echo "4. Check status: tailscale status"
    echo
    echo "For gateway node:"
    echo "sudo hostnamectl set-hostname gateway-hetzner"
    echo
    echo "For service node:"
    echo "sudo hostnamectl set-hostname service-do-1"
else
    echo "❌ Installation failed"
    exit 1
fi
