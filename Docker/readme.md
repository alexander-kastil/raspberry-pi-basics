# Docker on Raspberry Pi

[Docker MCP Server Setup for Raspberry Pi](https://github.com/Lawiak/docker-mcp-raspi)

## Installation

Update system:

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Download and install Docker:

```bash
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh
```

Add user to docker group (replace `<username>`):

```bash
sudo usermod -aG docker <username>
sudo reboot
```

## Verify Installation

Check versions:

```bash
docker --version
docker compose version
```

Test with hello-world:

```bash
docker run hello-world
```
