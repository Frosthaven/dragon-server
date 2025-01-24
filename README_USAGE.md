# 🐲 dragon-server

[Back to README](README.md)

## Usage

### SSH Login

You will need to provide an SSH key when spinning up server
instances based on this image, as password login is disabled by default.

### Caddy Server

[Caddy Documentation](https://caddyserver.com/docs)

1. Caddy configuration is located in `/etc/caddy/Caddyfile`.

2. Caddy is installed as a systemd service (`/etc/systemd/system/caddy.service`):
   - Start: `sudo systemctl start caddy`.
   - Enable (already enabled by default): `sudo systemctl enable caddy`.
   - Disable: `sudo systemctl disable caddy`.
   - Status: `sudo systemctl status caddy`.
   - Restart: `sudo systemctl restart caddy`.
   - Stop: `sudo systemctl stop caddy`.
3. A static file server can be hosted from `/var/www/static`.
   - To enable, change static.example.com to your domain in `/etc/caddy/Caddyfile`
     and restart the caddy service with `sudo systemctl restart caddy`.

### Docker Container Configuration

[Docker Compose Documentation](https://docs.docker.com/compose/)

Docker compose files can be stored anywhere, but the recommended location is
`/var/www/containers/`.

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

An example is located at `/var/www/containers/whoami/docker-compose.yml`.
