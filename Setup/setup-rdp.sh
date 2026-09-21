#!/bin/bash
# Raspberry Pi RDP Setup Script
# This script installs and configures xRDP with XFCE4 desktop environment

echo "========================================="
echo "Raspberry Pi RDP Setup Script"
echo "========================================="

# Update package list
echo "Updating package list..."
sudo apt-get update

# Upgrade existing packages
echo "Upgrading packages..."
sudo apt-get upgrade -y

# Install XFCE4 desktop environment
echo "Installing XFCE4 desktop environment..."
sudo apt-get install -y xfce4 xfce4-goodies

# Install xRDP and related packages
echo "Installing xRDP..."
sudo apt-get install -y xrdp xrdp-pulseaudio-installer

# Add xrdp user to ssl-cert group (fixes permission issues)
echo "Configuring xRDP permissions..."
sudo addgroup xrdp ssl-cert

# Configure xRDP to use XFCE4
echo "Configuring xRDP to use XFCE4..."
sudo bash -c 'cat > /etc/xrdp/startwm.sh << "EOF"
#!/bin/sh
# xrdp X session start script (c) 2015 mirabilos
# This file is licensed under the GNU General Public License, version 2.

unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
test -f /etc/profile && . /etc/profile

test -f $HOME/.profile && . $HOME/.profile

exec startxfce4
EOF'

# Make startwm.sh executable
sudo chmod +x /etc/xrdp/startwm.sh

# Enable and start xRDP service
echo "Enabling and starting xRDP service..."
sudo systemctl enable xrdp
sudo systemctl restart xrdp

# Check service status
echo ""
echo "========================================="
echo "Checking xRDP service status..."
echo "========================================="
sudo systemctl status xrdp --no-pager

echo ""
echo "========================================="
echo "RDP Setup Complete!"
echo "========================================="
echo "You can now connect from Windows using:"
echo "  mstsc /v:$(hostname -I | awk '{print $1}')"
echo ""
echo "Use your Raspberry Pi credentials to login."
echo "========================================="
