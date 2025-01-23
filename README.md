# 🐲 dragon-server

`dragon-server` is an Ubuntu based server image that hosts Docker containers as
web services. The image is built using [Packer](https://www.packer.io/) and [Ansible](https://docs.ansible.com/).

Docker containers are served using [Caddy](https://caddyserver.com/) via the
[docker-caddy-proxy](https://github.com/lucaslorentz/caddy-docker-proxy) plugin
to provide automatic SSL certificates and reverse proxying.

---

## Usage

### SSH Login
- You will need to provide an SSH key when using this image to spin up server
  instances, as password login is disabled.

### Caddy Server

Caddy is built with the following plugins:

- [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)
- [caddy-dns/digitalocean](https://github.com/caddy-dns/digitalocean)
- [caddyserver/transform-encoder](https://github.com/caddyserver/transform-encoder)
- [lucaslorentz/caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy/plugin/v2)

Caddy configuration files are located in `/var/www/caddy/Caddyfile`.

Caddy is installed as a systemd service:

- To start the service, run `sudo systemctl start caddy`.
- To enable the service on boot, run `sudo systemctl enable caddy`.
- To check the status of the service, run `sudo systemctl status caddy`.
- To restart the service, run `sudo systemctl restart caddy`.
- To stop the service, run `sudo systemctl stop caddy`.

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

Install the following tools:

- [Packer](https://www.packer.io/)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [OpenTofu](https://opentofu.org/docs/intro/install/)

### Build
Below are the instructions for building the image for each provider. The image
is built using the `build.pkr.hcl` file in each provider's directory, which gets
the necessary variables from the `variables.pkr.hcl` file in the same directory.

#### Digital Ocean Snapshot
*Requires `DIGITALOCEAN_TOKEN` environmental variable to be set.*

```shell
packer init ./digitalocean/build.pkr.hcl
packer build ./digitalocean
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
