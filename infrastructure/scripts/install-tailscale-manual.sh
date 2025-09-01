#!/bin/bash

# Manual Tailscale Installation Script
# Alternative installation method for systems where automated script fails

set -e

echo "=== Manual Tailscale Installation ==="
echo

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
else
    echo "Cannot detect OS"
    exit 1
fi

echo "Detected OS: $OS $VERSION"

# Install Tailscale using the official static binary method
echo "Installing Tailscale using static binary..."

# Download and install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

echo
echo "✅ Tailscale installed successfully!"
echo
echo "Next steps:"
echo "1. Start the service: sudo systemctl enable --now tailscaled"
echo "2. Authenticate: sudo tailscale up"
echo "3. Check status: tailscale status"
echo
echo "If you get a 'tailscale' command not found error, you may need to:"
echo "export PATH=$PATH:/usr/local/bin"
echo "or restart your shell session"
