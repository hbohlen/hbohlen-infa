#!/bin/bash

# Manual step-by-step Tailscale installation for Ubuntu 24.04
# Run this if the automated script fails

set -e

echo "=== Manual Tailscale Installation for Ubuntu 24.04 ==="
echo

# Step 1: Clean up any previous attempts
echo "Step 1: Cleaning up previous attempts..."
sudo rm -f /etc/apt/sources.list.d/tailscale*
sudo rm -f /usr/share/keyrings/tailscale*
echo "✅ Cleanup complete"
echo

# Step 2: Update package list
echo "Step 2: Updating package list..."
sudo apt update
echo "✅ Package list updated"
echo

# Step 3: Install prerequisites
echo "Step 3: Installing prerequisites..."
sudo apt install -y curl apt-transport-https gnupg
echo "✅ Prerequisites installed"
echo

# Step 4: Create keyrings directory if it doesn't exist
echo "Step 4: Ensuring keyrings directory exists..."
sudo mkdir -p /usr/share/keyrings
echo "✅ Keyrings directory ready"
echo

# Step 5: Add Tailscale GPG key
echo "Step 5: Adding Tailscale GPG key..."
sudo curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.gpg | sudo gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg
echo "✅ GPG key added"
echo

# Step 6: Add Tailscale repository
echo "Step 6: Adding Tailscale repository..."
echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/tailscale.list
echo "✅ Repository added"
echo

# Step 7: Update package list with new repository
echo "Step 7: Updating package list with Tailscale repository..."
sudo apt update
echo "✅ Package list updated with Tailscale repo"
echo

# Step 8: Install Tailscale
echo "Step 8: Installing Tailscale..."
sudo apt install -y tailscale
echo "✅ Tailscale installed"
echo

# Step 9: Enable and start service
echo "Step 9: Enabling and starting Tailscale service..."
sudo systemctl enable tailscaled
sudo systemctl start tailscaled
echo "✅ Service enabled and started"
echo

# Step 10: Verify installation
echo "Step 10: Verifying installation..."
if command -v tailscale >/dev/null 2>&1; then
    echo "✅ Tailscale command available"
    echo "   Version: $(tailscale version)"
else
    echo "❌ Tailscale command not found"
    exit 1
fi

if sudo systemctl is-active --quiet tailscaled; then
    echo "✅ Tailscale service is running"
else
    echo "❌ Tailscale service is not running"
    exit 1
fi

echo
echo "=== Installation Complete! ==="
echo "🎉 Tailscale has been successfully installed on Ubuntu 24.04"
echo
echo "Next steps:"
echo "1. Authenticate: sudo tailscale up"
echo "2. Check status: tailscale status"
echo "3. Get IP: tailscale ip -4"
echo
echo "For gateway node, also run:"
echo "sudo hostnamectl set-hostname gateway-hetzner"
