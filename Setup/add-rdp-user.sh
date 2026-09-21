#!/bin/bash
# Add RDP User Script
# Creates a new user with RDP access on Raspberry Pi

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <password>"
    echo "Example: $0 david coolman"
    exit 1
fi

USERNAME=$1
PASSWORD=$2

echo "========================================="
echo "Adding RDP User: $USERNAME"
echo "========================================="

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
    echo "Error: User $USERNAME already exists!"
    exit 1
fi

# Create user with home directory
echo "Creating user $USERNAME..."
sudo adduser --disabled-password --gecos "" "$USERNAME"

# Set password
echo "Setting password for $USERNAME..."
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Optional: Add to sudo group for admin access
# Uncomment the line below if you want this user to have sudo privileges
# sudo usermod -aG sudo "$USERNAME"

# Verify user creation
echo ""
echo "========================================="
echo "User Details:"
echo "========================================="
id "$USERNAME"

echo ""
echo "========================================="
echo "User $USERNAME created successfully!"
echo "========================================="
echo "RDP Login Credentials:"
echo "  Username: $USERNAME"
echo "  Password: $PASSWORD"
echo ""
echo "Connect using: mstsc /v:$(hostname -I | awk '{print $1}')"
echo "========================================="
