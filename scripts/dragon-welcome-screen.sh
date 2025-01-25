#!/bin/bash

# this file gets placed into "/etc/profile.d" and runs on every login

# functions ********************************************************************
# ******************************************************************************

NORMAL=$'\e[0m'
YELLOW=$'\e[33m'
CYAN=$'\e[36m'
BLUE=$'\e[34m'
RED=$'\e[31m'
MAGENTA=$'\e[35m'
GREEN=$'\e[32m'

function showBanner() {
  echo "${GREEN}――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――${NORMAL}"
  echo "🐲 DRAGON SERVER: ${CYAN}https://github.com/frosthaven/dragon-server"
  echo "${GREEN}――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――${NORMAL}"
  echo ""
}

function showWelcomeScreen() {
  cd /var/www/containers || exit
  showBanner

  echo "${MAGENTA}$(lsb_release -a)${NORMAL}"
  echo ""
  echo "${MAGENTA}Caddy version $(caddy version)${NORMAL}"
  echo "${MAGENTA}$(docker --version)${NORMAL})"
  echo ""
  echo "Caddy Server Files    ${YELLOW}/var/www/_caddy/${NORMAL}"
  echo "Hosted Containers     ${YELLOW}/var/www/containers${NORMAL}"
  echo "Hosted Static Files   ${YELLOW}/var/www/static${NORMAL}"
  echo ""
  echo "${BLUE}$(sudo docker ps)${NORMAL}"
  echo ""
}

function configureServer() {
  showBanner

  echo "Welcome to your dragon-server instance! Please complete the following steps to get started."
  echo ""
  echo "Enter the base domain name (e.g. example.com):"
  read -r base_domain
  echo "Enter the server administrator email address:"
  read -r admin_email

  if [ -z "$base_domain" ] || [ -z "$admin_email" ]; then
    clear
    configureServer
  fi

  # replace all example email and domain name placeholders with the user's input
  sed -i "s/example@example.com/$admin_email/g" /var/www/_caddy/Caddyfile
  sed -i "s/example.com/$base_domain/g" /var/www/_caddy/Caddyfile
  sed -i "s/example.com/$base_domain/g" /var/www/containers/whoami/docker-compose.yml

  # start the whoami container
  cd /var/www/containers/whoami && docker compose up -d

  # get the public IP address
  public_ip=$(curl -s ifconfig.me)

  echo ""
  echo "Add the following DNS records to your domain registrar:"
  {
    echo -e "${BLUE}Domain Name\tType\tValue${NORMAL}"
    echo -e "$base_domain\tA\t$public_ip"
    echo -e "whoami.$base_domain\tCNAME\t$base_domain"
    echo -e "static.$base_domain\tCNAME\t$base_domain"
  } | column -s $'\t' -t
  echo ""
  echo "Press Enter to when done..."
  read -r

  # restart Caddy
  systemctl restart caddy

  # create a file to indicate that the script has been run
  touch /startup_configured

  clear
  echo "Configuration complete! You can test your server at ${CYAN}https://whoami.$base_domain${NORMAL}"
  echo ""
  showWelcomeScreen
}

# main *************************************************************************
# ******************************************************************************

if [ -f /startup_configured ]; then
  clear
  showWelcomeScreen
else
  clear
  configureServer
fi
