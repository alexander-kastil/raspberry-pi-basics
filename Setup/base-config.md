# Raspberry Pi Base Configuration

## Prerequisites

- Raspberry Pi with Raspberry Pi OS installed
- Network connectivity (WiFi or Ethernet)
- SSH access enabled

## Remote Desktop Protocol (RDP) Setup

### Automated Installation

Copy the setup script to your Raspberry Pi and execute it:

```bash
# Download the script (if hosted) or create it manually
wget https://raw.githubusercontent.com/alexander-kastil/raspberry-pi-basics/develop/Setup/setup-rdp.sh
chmod +x setup-rdp.sh
./setup-rdp.sh
```

### Manual Installation

If you prefer to install manually or need to troubleshoot, follow these steps:

#### 1. Update System

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

#### 2. Install XFCE4 Desktop Environment

The default Raspberry Pi OS Lite doesn't include a desktop environment. XFCE4 is lightweight and works well with RDP:

```bash
sudo apt-get install -y xfce4 xfce4-goodies
```

#### 3. Install xRDP

```bash
sudo apt-get install -y xrdp xrdp-pulseaudio-installer
```

#### 4. Configure Permissions

Add the xrdp user to the ssl-cert group to fix common permission errors:

```bash
sudo addgroup xrdp ssl-cert
```

#### 5. Configure Window Manager

The default startwm.sh configuration may not work correctly. Replace it with:

```bash
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
```

Make the script executable:

```bash
sudo chmod +x /etc/xrdp/startwm.sh
```

#### 6. Enable and Start xRDP Service

```bash
sudo systemctl enable xrdp
sudo systemctl restart xrdp
```

#### 7. Verify Installation

Check that xRDP is running:

```bash
sudo systemctl status xrdp
```

You should see "Active: active (running)".

Verify xRDP is listening on port 3389:

```bash
sudo netstat -antp | grep 3389
```

### Connect from Windows

1. Open Remote Desktop Connection (mstsc)
2. Enter your Raspberry Pi's IP address: `192.168.0.143`
3. Click "Connect"
4. Login with your Raspberry Pi credentials:
   - Username: `alex` (or your configured username)
   - Password: Your Raspberry Pi password

You can also connect via command line:

```cmd
mstsc /v:192.168.0.143
```

## Troubleshooting

### Connection Refused

If you cannot connect, check:

1. xRDP service is running:

   ```bash
   sudo systemctl status xrdp
   ```

2. Firewall is not blocking port 3389 (if enabled):

   ```bash
   sudo ufw status
   sudo ufw allow 3389/tcp
   ```

3. Check IP address is correct:
   ```bash
   hostname -I
   ```

### Black Screen or Connection Drops

This usually indicates a window manager crash. Check logs:

```bash
sudo tail -50 /var/log/xrdp.log
sudo tail -50 /var/log/xrdp-sesman.log
```

Look for errors like:

- `[ERROR] Xorg server closed connection`
- `[WARN] Window manager exited with signal SIGSEGV`

**Solution**: Ensure the startwm.sh file is configured correctly (see step 5 above).

### Performance Issues

For better performance on Raspberry Pi:

1. Reduce display resolution in RDP client settings
2. Disable desktop effects:
   ```bash
   xfconf-query -c xfwm4 -p /general/use_compositing -s false
   ```

### Check Session Logs

User-specific X server logs:

```bash
cat ~/.xorgxrdp.10.log
```

## Security Considerations

1. **Change Default Password**: Always change the default Raspberry Pi password

   ```bash
   passwd
   ```

2. **Use SSH Keys**: For SSH access, prefer key-based authentication over passwords

3. **Firewall**: Consider enabling and configuring UFW firewall

   ```bash
   sudo apt-get install ufw
   sudo ufw allow ssh
   sudo ufw allow 3389/tcp
   sudo ufw enable
   ```

4. **Network Security**: Only expose RDP on trusted networks or use VPN

## Additional Configuration

### Set Static IP Address

Edit the dhcpcd configuration:

```bash
sudo nano /etc/dhcpcd.conf
```

Add at the end:

```
interface wlan0
static ip_address=192.168.0.143/24
static routers=192.168.0.1
static domain_name_servers=192.168.0.1 8.8.8.8
```

Restart networking:

```bash
sudo systemctl restart dhcpcd
```

### Enable Audio Redirection

Audio should work automatically with xrdp-pulseaudio-installer, but if not:

```bash
sudo apt-get install pulseaudio
```

## System Information

- **Hostname**: raspi4
- **Default User**: alex
- **Desktop Environment**: XFCE4
- **RDP Server**: xRDP
- **RDP Port**: 3389
