# 🐲 dragon-server

`dragon-server` is a development server image that hosts Docker containers as
web services, supporting container auto-discovery and automatic SSL certificates.

- The image is built using [Packer](https://www.packer.io/) and [Ansible](https://docs.ansible.com/).

- Docker containers are served using [Caddy](https://caddyserver.com/) via the
[docker-caddy-proxy](https://github.com/lucaslorentz/caddy-docker-proxy) plugin.

- This project is current a work in progress.

---

## Usage

### SSH Login
You will need to provide an SSH key when spinning up server
  instances based on this image, as password login is disabled by default.

### Caddy Server

Caddy is built with the following plugins:

- [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)
- [caddy-dns/digitalocean](https://github.com/caddy-dns/digitalocean)
- [caddyserver/transform-encoder](https://github.com/caddyserver/transform-encoder)
- [lucaslorentz/caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy/plugin/v2)

Caddy configuration is located in `/etc/caddy`.

Caddy is installed as a systemd service:

- Start: `sudo systemctl start caddy`.
- Enable (already enabled by default): `sudo systemctl enable caddy`.
- Disable: `sudo systemctl disable caddy`.
- Status: `sudo systemctl status caddy`.
- Restart: `sudo systemctl restart caddy`.
- Stop: `sudo systemctl stop caddy`.

### Docker Container Configuration

Docker compose files are stored in `/var/www/containers/<container-name>/`.

In order to enable auto-discovery of running containers, you must add both
the caddy network and the caddy labels to your docker-compose files:

```yaml
services:
  your_service:
      # ...
      networks:
        - caddy
      labels:
          caddy: YOUR_DOMAIN.COM
          caddy.reverse_proxy: "{{upstreams 80}}"
      # ...

networks:
  caddy:
    external: true
```

---

## Building the Image

### Install Requirements
*Note to Windows users: Ansible does not have a Windows binary. It is
recommended to install your tools AND any system level environmental variables
in WSL.*

Follow the installation guide for the following tools:

- [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Build

#### Digital Ocean Snapshot
*Requires `DIGITALOCEAN_TOKEN` environmental variable to be set.*

```shell
packer init ./digitalocean;
packer build ./digitalocean;
```

#### Amazon Web Services AMI

not yet implemented

---

## THIS IS A WORK IN PROGRESS PROJECT

- @todo get the digitalocean token from the packer environment variables and set the environmental variable in the instance
- @todo harden caddy with CrowdSec (maybe look at [os-caddy](https://docs.opnsense.org/manual/how-tos/caddy.html))
- @todo do initial caddy configs for dns challenge
- @todo [disable root login](https://www.digitalocean.com/community/tutorials/how-to-disable-root-login-on-ubuntu-20-04)
  - ensure we copy the ssh key to the new user on first boot
