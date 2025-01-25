# 🐲 dragon-server

[Back to README](README.md)

## Usage

### SSH Login

You will need to provide an SSH key when spinning up server
instances based on this image, as password login is disabled by default.

### Caddy Server

[Caddy Documentation](https://caddyserver.com/docs)
1. Caddy is installed as a systemd service (`/etc/systemd/system/caddy.service`):
   - Start: `sudo systemctl start caddy`.
   - Enable (already enabled by default): `sudo systemctl enable caddy`.
   - Disable: `sudo systemctl disable caddy`.
   - Status: `sudo systemctl status caddy`.
   - Restart: `sudo systemctl restart caddy`.
   - Stop: `sudo systemctl stop caddy`.
2. Caddy configuration and storage is located in `/var/www/_caddy/`. Symbolic
   links have been added that point to the Caddy logs and systemd service file.
3. A static file server hosts from `/var/www/static` by default.

### Docker Container Configuration

[Docker Compose Documentation](https://docs.docker.com/compose/)

Docker compose files can be stored anywhere, but we use the convention of
storing them in `/var/www/containers/`.

In order to enable auto-discovery of running containers, you must add both
the caddy network and the caddy labels to your docker-compose files:

```yaml
services:
  your_service:
      # ...
      networks:
        - caddy
      labels:
          caddy: example.com # change to your domain
          caddy.reverse_proxy: "{{upstreams 80}}"
      # ...

networks:
  caddy:
    external: true
```

An example is located at `/var/www/containers/whoami/docker-compose.yml`. You
can learn more about `caddy-docker-proxy` labels [here](https://github.com/lucaslorentz/caddy-docker-proxy?tab=readme-ov-file#labels-to-caddyfile-conversion).
