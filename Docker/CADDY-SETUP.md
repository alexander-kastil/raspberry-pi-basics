# Caddy & Skills-API Setup on Raspberry Pi

## Overview
Caddy is now configured as a reverse proxy to expose the `arambazamba/skills-api` service running in Docker.

## Architecture
```
Internet/Local Network → Caddy (Port 80) → Skills-API Docker Container (Port 3000)
```

## Configuration Details

### Caddy Configuration
**Location:** `/etc/caddy/Caddyfile`
```
:80 {
	# Reverse proxy to skills-api running on localhost:3000
	reverse_proxy localhost:3000
}
```

### Docker Container
- **Image:** arambazamba/skills-api (or python:3 for testing)
- **Container Name:** skills-api
- **Internal Port:** 3000
- **Status:** Running

### Caddy Service
- **Service Name:** caddy.service
- **Status:** Active (running)
- **Admin Endpoint:** localhost:2019

---

## How to Access Skills-API

### From Local Raspberry Pi
```bash
curl http://localhost/
```

### From Another Device on Network
Replace `192.168.0.143` with your Raspberry Pi's IP address:
```bash
curl http://192.168.0.143/
```

### From Windows Machine (on same network)
```powershell
# Using PowerShell
Invoke-WebRequest -Uri "http://192.168.0.143/" -Method GET

# Or using curl if available
curl http://192.168.0.143/
```

---

## Testing Commands

### 1. Test via Caddy (Port 80)
```bash
# From Raspberry Pi
curl -v http://localhost/

# From other machines
curl -v http://192.168.0.143/
```

### 2. Direct Container Test (Port 3000)
```bash
# This should also work (bypasses Caddy)
curl http://192.168.0.143:3000/
```

### 3. Check Service Status
```bash
# Check Caddy status
systemctl status caddy

# Check Docker container
docker ps | grep skills-api

# View Caddy logs
sudo journalctl -u caddy -f

# View Docker container logs
docker logs skills-api
```

### 4. Configuration Verification
```bash
# Verify Caddyfile syntax
caddy validate --config /etc/caddy/Caddyfile

# Check listening ports
ss -tlnp | grep -E "80|3000|:caddy"
```

---

## Management Commands

### Restart Caddy
```bash
sudo systemctl restart caddy
```

### Stop Caddy
```bash
sudo systemctl stop caddy
```

### Start Caddy
```bash
sudo systemctl start caddy
```

### Restart Skills-API Container
```bash
docker restart skills-api
```

### View Real-time Logs
```bash
# Caddy logs
sudo journalctl -u caddy -f

# Docker container logs
docker logs -f skills-api
```

---

## Caddy Admin API

Caddy provides an admin API on localhost:2019 for configuration changes:

```bash
# Reload configuration
curl -X POST http://localhost:2019/load -H "Content-Type: application/json" \
  -d @/etc/caddy/Caddyfile

# Get current configuration
curl http://localhost:2019/config/
```

---

## Future Configuration

### To Use a Custom Domain with HTTPS
Update `/etc/caddy/Caddyfile`:
```
skills-api.yourdomain.com {
	reverse_proxy localhost:3000
	# Caddy will automatically handle HTTPS certificates
}
```

### To Add Authentication
```
:80 {
	reverse_proxy localhost:3000 {
		header_uri -Authorization
	}
}
```

---

## Troubleshooting

### Caddy Not Responding
1. Check status: `systemctl status caddy`
2. Check logs: `sudo journalctl -u caddy -n 50`
3. Verify port 80 is not in use: `ss -tlnp | grep 80`
4. Reload configuration: `sudo systemctl reload caddy`

### Skills-API Container Not Running
1. Check status: `docker ps -a | grep skills-api`
2. View logs: `docker logs skills-api`
3. Restart: `docker restart skills-api`

### Network Connectivity Issues
1. Verify Raspberry Pi IP: `hostname -I`
2. Test from local machine: `ping 192.168.0.143`
3. Check if port 80 is open: `curl -v http://192.168.0.143/`

---

## Key Information
- **Raspberry Pi IP:** 192.168.0.143
- **Caddy Admin:** http://192.168.0.143:2019
- **Skills-API via Caddy:** http://192.168.0.143/
- **Skills-API Direct:** http://192.168.0.143:3000/

