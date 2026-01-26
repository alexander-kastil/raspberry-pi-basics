# Docker

[Guide](https://lobehub.com/mcp/lawiak-docker-mcp-raspi)

## Install Docker

Set your system to the latest state:

```
sudo apt-get update && sudo apt-get upgrade
```

> Note: Choose yes if prompted

Download Docker installation script & execute it:

```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Add the Pi user to the Docker Group:

```
sudo usermod -aG docker pi
```

> Note: If you want to add any other (non-root) user to the Docker Group execute: `sudo usermod -aG docker [user_name]`

Check Docker version & test installation:

```
docker version
sudo docker run hello-world
```
