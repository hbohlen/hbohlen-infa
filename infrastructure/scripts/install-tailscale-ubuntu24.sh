#!/bin/bash

# Tailscale Installation Script for Ubuntu 24.04
# Uses working repository configuration for Noble Numbat

set -e

echo "=== Installing Tailscale on Ubuntu 24.04 ==="
echo

# Clean up any previous failed attempts
echo "Cleaning up previous attempts..."
sudo rm -f /etc/apt/sources.list.d/tailscale*
sudo rm -f /usr/share/keyrings/tailscale*

# Update package list
echo "Updating package list..."
sudo apt update

# Install prerequisites
echo "Installing prerequisites..."
sudo apt install -y curl apt-transport-https

# Add Tailscale GPG key
echo "Adding Tailscale GPG key..."
sudo curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.gpg | sudo gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg

# Add Tailscale repository (using Jammy for 24.04 compatibility)
echo "Adding Tailscale repository..."
echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/tailscale.list

# Update package list again
echo "Updating package list with Tailscale repository..."
sudo apt update

# Install Tailscale
echo "Installing Tailscale..."
sudo apt install -y tailscale

# Enable and start service
echo "Enabling and starting Tailscale service..."
sudo systemctl enable tailscaled
sudo systemctl start tailscaled

# Verify installation
echo
echo "=== Installation Complete ==="
echo "Tailscale version: $(tailscale version)"
echo
echo "Next steps:"
echo "1. Authenticate: sudo tailscale up"
echo "2. Check status: tailscale status"
echo "3. Get IP: tailscale ip -4"
echo
echo "✅ Tailscale installed successfully!"
