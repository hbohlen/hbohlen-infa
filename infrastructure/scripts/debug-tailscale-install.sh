#!/bin/bash

# Debug script for Tailscale installation issues

echo "=== Tailscale Installation Debug ==="
echo

echo "1. OS Information:"
cat /etc/os-release
echo

echo "2. Architecture:"
uname -m
echo

echo "3. Current package manager:"
if command -v apt >/dev/null 2>&1; then
    echo "apt (Debian/Ubuntu)"
elif command -v yum >/dev/null 2>&1; then
    echo "yum (RHEL/CentOS)"
elif command -v dnf >/dev/null 2>&1; then
    echo "dnf (Fedora)"
else
    echo "Unknown package manager"
fi
echo

echo "4. Internet connectivity:"
ping -c 2 google.com
echo

echo "5. DNS resolution:"
nslookup pkgs.tailscale.com
echo

echo "6. Check if curl is available:"
if command -v curl >/dev/null 2>&1; then
    echo "✅ curl is available"
else
    echo "❌ curl is not available"
fi
echo

echo "7. Check existing Tailscale sources:"
ls -la /etc/apt/sources.list.d/ | grep tailscale || echo "No Tailscale sources found"
echo

echo "8. Check existing Tailscale keys:"
ls -la /usr/share/keyrings/ | grep tailscale || echo "No Tailscale keys found"
echo

echo "9. Check if tailscale is already installed:"
if command -v tailscale >/dev/null 2>&1; then
    echo "✅ Tailscale is installed: $(tailscale version)"
else
    echo "❌ Tailscale is not installed"
fi
echo

echo "10. Package cache status:"
if command -v apt >/dev/null 2>&1; then
    apt list --installed | grep tailscale || echo "Tailscale not in installed packages"
fi
