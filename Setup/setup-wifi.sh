#!/bin/bash
# WiFi Setup Script
# Connects Raspberry Pi to a wireless network using NetworkManager

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <SSID> <password>"
    echo "Example: $0 'MyNetwork' 'mypassword'"
    exit 1
fi

SSID=$1
PASSWORD=$2

echo "========================================="
echo "WiFi Setup Script"
echo "========================================="
echo "SSID: $SSID"
echo ""

# Check if NetworkManager is running
if ! systemctl is-active --quiet NetworkManager; then
    echo "Error: NetworkManager is not running"
    echo "Starting NetworkManager..."
    sudo systemctl start NetworkManager
    sleep 2
fi

# Bring WiFi interface up
echo "Enabling WiFi interface..."
sudo ip link set wlan0 up

# Set WiFi country code (adjust as needed)
echo "Setting WiFi country code to AT (Austria)..."
sudo raspi-config nonint do_wifi_country AT

# Connect to WiFi
echo "Connecting to WiFi network: $SSID..."
sudo nmcli device wifi connect "$SSID" password "$PASSWORD"

# Wait for connection
echo "Waiting for connection..."
sleep 5

# Show connection status
echo ""
echo "========================================="
echo "Connection Status:"
echo "========================================="
nmcli device status

echo ""
echo "========================================="
echo "WiFi Details:"
echo "========================================="
iwconfig wlan0 2>/dev/null | grep -E "ESSID|Quality|Signal"

echo ""
echo "========================================="
echo "IP Address:"
echo "========================================="
ifconfig wlan0 | grep "inet " | awk '{print "IPv4: " $2}'

echo ""
echo "========================================="
echo "Testing Internet Connectivity:"
echo "========================================="
if ping -c 2 google.com &>/dev/null; then
    echo "✓ Internet connection successful!"
else
    echo "✗ Internet connection failed"
fi

echo ""
echo "========================================="
echo "WiFi setup complete!"
echo "========================================="
