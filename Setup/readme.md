# Setup

Download Raspberry Imager:

[Raspberry Downloads](https://www.raspberrypi.org/downloads/)

[Imager for Windows](https://downloads.raspberrypi.org/imager/imager.exe)

Then choose Operating System (OS) Image & Card

![format-sdcard](_images/format-sdcard.png)

![choose-os](_images/choose-os.png)

---

## Headless OS Setup

Connect to the raspi using a network cable.

After completion add a blank file with the name `ssh` without any extension. This file will be deleted after you have established the first connection.

The default Newtwork Name of the raspi is `raspberrypi`. If you want to find the IP Address of your Raspberry you could use a network scanner like [Advanced IP Scanner](https://www.advanced-ip-scanner.com/de/) or the DHCP table of your router

![ipscan](_images/network-scan.png)

> Note: You might want to adjust the IP range you are scanning

Install the SSH Client [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) or use the SSH Client provided by your Remote Client OS.

Connect to the Raspberry using Windows Command Shell (Windows + R -> CMD)

```bash
ssh pi@raspberrypi
```

> Note: The default password is "raspberry"

Configure the raspi:

```
sudo  raspi-config
```

> Note: To install Ubuntu Server on the raspi follow this [guide](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview)

### Connect to the WiFi

Connect the Raspberry to your local wifi - you will need your Network SSID and the password:

![wifi-1](_images/wifi-1.png)

![wifi-2](_images/wifi-2.png)

> Connect to your WiFi Network using your SSID & password

Update the Raspberry to check if Network Config works:

![update](_images/update.png)

You should see a screen similar to this:

![updating](_images/updating.png)

> Note: In real life you should also change the device name & sudo password

After you finished this configuration choose `finish` to exit the `raspi-config` screen.

Next check your IP Address:

```
ifconfig
```

![check-ip](_images/check-ip.png)

## Enable RDP access

### Quick Setup (Copy-Paste Method)

Copy and paste this entire block into your SSH session:

```bash
sudo apt-get update && \
sudo apt-get upgrade -y && \
sudo apt-get install -y xfce4 xfce4-goodies xrdp xrdp-pulseaudio-installer && \
sudo addgroup xrdp ssl-cert && \
sudo bash -c 'cat > /etc/xrdp/startwm.sh << "EOF"
#!/bin/sh
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
test -f /etc/profile && . /etc/profile
test -f $HOME/.profile && . $HOME/.profile
exec startxfce4
EOF' && \
sudo chmod +x /etc/xrdp/startwm.sh && \
sudo systemctl enable xrdp && \
sudo systemctl restart xrdp && \
echo "RDP setup complete! Connect using: mstsc /v:$(hostname -I | awk '{print $1}')"
```

### Script-Based Setup

Alternatively, use the automated setup script:

```bash
# Copy setup-rdp.sh to your Raspberry Pi, then:
chmod +x setup-rdp.sh
./setup-rdp.sh
```

### Connect from Windows

Open Remote Desktop Connection and connect:

```
mstsc /v:192.168.0.143
```

![rdp-logon](_images/rdp-logon.png)

> Note: Login with your Raspberry Pi credentials (username: alex)

![rdp-finish](_images/rdp-finish.png)

> For detailed configuration, troubleshooting, and security considerations, see [base-config.md](base-config.md)

## Optional - IP Address Management

Release IP:

```
sudo dhclient -v -r
```
