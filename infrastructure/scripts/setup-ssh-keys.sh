#!/bin/bash

# SSH Key Setup Script for Tailscale Nodes
# Sets up passwordless SSH between gateway and service nodes

set -e

echo "=== SSH Key Setup for Tailscale Nodes ==="
echo

# Function to generate SSH key if it doesn't exist
generate_ssh_key() {
    local key_file="$HOME/.ssh/id_rsa"
    
    if [ ! -f "$key_file" ]; then
        echo "Generating SSH key pair..."
        ssh-keygen -t rsa -b 4096 -f "$key_file" -N "" -C "tailscale-$(hostname)"
        echo "✅ SSH key generated"
    else
        echo "✅ SSH key already exists"
    fi
    
    # Ensure proper permissions
    chmod 600 "$key_file"
    chmod 644 "$key_file.pub"
    
    echo "Public key:"
    cat "$key_file.pub"
    echo
}

# Function to copy public key to remote host
copy_key_to_remote() {
    local remote_host=$1
    local key_file="$HOME/.ssh/id_rsa.pub"
    
    echo "Copying SSH key to $remote_host..."
    
    # Create .ssh directory on remote host if it doesn't exist
    ssh -o StrictHostKeyChecking=no root@$remote_host "mkdir -p ~/.ssh"
    
    # Append public key to authorized_keys on remote host
    cat "$key_file" | ssh -o StrictHostKeyChecking=no root@$remote_host "cat >> ~/.ssh/authorized_keys"
    
    # Set proper permissions on remote host
    ssh -o StrictHostKeyChecking=no root@$remote_host "chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh"
    
    echo "✅ SSH key copied to $remote_host"
}

# Function to test SSH connection
test_ssh_connection() {
    local remote_host=$1
    local expected_hostname=$2
    
    echo "Testing SSH connection to $remote_host..."
    
    # Test SSH connection
    local result
    result=$(ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no root@$remote_host "hostname" 2>/dev/null)
    
    if [ "$result" = "$expected_hostname" ]; then
        echo "✅ SSH connection to $remote_host successful"
        echo "   Remote hostname: $result"
        return 0
    else
        echo "❌ SSH connection to $remote_host failed"
        echo "   Expected: $expected_hostname"
        echo "   Got: $result"
        return 1
    fi
}

# Main script
echo "This script will set up SSH key authentication between your Tailscale nodes."
echo "Make sure both nodes are online and you can reach them via Tailscale IPs."
echo

# Detect current hostname to determine which node this is
CURRENT_HOSTNAME=$(hostname)
echo "Current hostname: $CURRENT_HOSTNAME"
echo

case $CURRENT_HOSTNAME in
    "gateway-hetzner")
        REMOTE_HOST="100.68.138.45"
        REMOTE_HOSTNAME="service-do-1"
        ;;
    "service-do-1")
        REMOTE_HOST="100.121.164.125"
        REMOTE_HOSTNAME="gateway-hetzner"
        ;;
    *)
        echo "❌ Unknown hostname: $CURRENT_HOSTNAME"
        echo "   This script should be run on either 'gateway-hetzner' or 'service-do-1'"
        exit 1
        ;;
esac

echo "Will configure SSH to: $REMOTE_HOST ($REMOTE_HOSTNAME)"
echo

# Generate SSH key
generate_ssh_key

# Copy key to remote host
copy_key_to_remote "$REMOTE_HOST"

# Test the connection
echo
if test_ssh_connection "$REMOTE_HOST" "$REMOTE_HOSTNAME"; then
    echo
    echo "🎉 SSH key setup completed successfully!"
    echo
    echo "You can now SSH between nodes without passwords:"
    echo "  ssh root@$REMOTE_HOST"
    echo
    echo "To complete the bidirectional setup, run this script on the other node as well."
else
    echo
    echo "❌ SSH setup failed. Please check:"
    echo "  - Both nodes are online (tailscale status)"
    echo "  - Tailscale IPs are correct"
    echo "  - SSH service is running on both nodes"
    exit 1
fi
