#!/bin/bash

####################################################################################################
# VARIABLES
####################################################################################################

# Color
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
orange='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
gray='\033[0;37m'
gray2='\033[1;30m'
red2='\033[1;31m'
green2='\033[1;32m'
yellow='\033[1;33m'
blue2='\033[1;34m'
purple2='\033[1;35m'
cyan2='\033[1;36m'
white='\033[1;37m'
nc='\033[0m' # No Color

# napi_proxy for notionalapi.net
CONTAINER_NAME=$1
DOMAIN=$2

# Basic variables for certbot
CREDENTIAL_PATH="./cloudflare.ini"
CERTBOT_DIR="/tmp/certbot"
CERTBOT_SERVER="https://acme-v02.api.letsencrypt.org/directory"

####################################################################################################
# FUNCTIONS
####################################################################################################

# Get configs
agent_id=$(docker ps -aqf "name=agent")
# DOMAINS=$(docker exec $agent_id curl -s "http://tasks.web_config/config/cloudflare.domains")
EMAILS=$(docker exec $agent_id curl -s "http://tasks.web_config/config/cloudflare.$DOMAIN.emails")
CREDENTIAL=$(docker exec $agent_id curl -s "http://tasks.web_config/config/cloudflare.$DOMAIN.credential")
DOMAINS="*.${DOMAIN}"

# install binary if not exist
install_binary_if_not_exist () {

  local BINARY=$1
  local FUNCTION=$2
  
  if command -v ${BINARY} &> /dev/null; then
    continue
  else
    $FUNCTION
  fi
}

# install pip package if not exist
install_package_if_not_exist () {

    local PACKAGE_NAME=$1
    local FUNCTION=$2

    if pip show "$PACKAGE_NAME" &> /dev/null; then
      continue
    else
      $FUNCTION
    fi

}

# Install pip binary function
install_pip_binary () {
  curl -O https://bootstrap.pypa.io/get-pip.py
  python get-pip.py --break-system-package
}

# Install certbot dns cloudflare function
install_certbot_dns_cloudflare () {
  pip install certbot-dns-cloudflare --break-system-package
}

# Obtain certificates function
obtain_certs () {

  local DOMAINS=$1
  local EMAILS=$2
  local CERTBOT_DIR=$3
  local CERTBOT_SERVER=$4
  local CREDENTIAL_PATH=$5

  certbot certonly \
    --dns-cloudflare \
    --dry-run \
    --dns-cloudflare-credentials $CREDENTIAL_PATH \
    --dns-cloudflare-propagation-seconds 60 \
    --domains $DOMAINS \
    --key-type rsa \
    --rsa-key-size 2048 \
    --logs-dir $CERTBOT_DIR \
    --config-dir $CERTBOT_DIR \
    --work-dir $CERTBOT_DIR \
    --email $EMAILS \
    --agree-tos \
    --non-interactive \
    --server $CERTBOT_SERVER \

}

####################################################################################################
# IMPLEMENTATION
####################################################################################################

# Install pip and certbot dns cloudflare
install_binary_if_not_exist pip install_pip_binary
install_package_if_not_exist certbot-dns-cloudflare install_certbot_dns_cloudflare

# Write credentials to file
cat << EOF | sudo tee -a $CREDENTIAL_PATH
$CREDENTIAL
EOF

# Obtain certifications
obtain_certs $DOMAINS $EMAILS $CERTBOT_DIR $CERTBOT_SERVER $CREDENTIAL_PATH

# Remove credential after obtain certs
rm -rf $CREDENTIAL_PATH

# Remove old certificate configs
docker config rm $PRIVKEY_CONFIG
docker config rm $FULLCHAIN_CONFIG

# Create new certificate configs
docker config create $PRIVKEY_CONFIG $CERTBOT_DIR/${DOMAINS}/privkey.pem
docker config create $FULLCHAIN_CONFIG $CERTBOT_DIR/${DOMAINS}.ventures/fullchain.pem

# Get current timestamp
TIMESTAMP=`date +"%s-%A-%d-%B-%Y-@-%Hh%Mm%Ss"`

# Get container id
export SERVICE=$CONTAINER_NAME
CONTAINER_ID=$(docker ps -a | grep $SERVICE | grep -E "$SERVICE." | awk '{print $1}')
docker exec $CONTAINER_ID ls

# Backup old certifications
docker exec $CONTAINER_ID mkdir -p /etc/nginx/$TIMESTAMP
docker exec $CONTAINER_ID cp /etc/nginx/privkey.pem /etc/nginx/$TIMESTAMP/privkey.pem
docker exec $CONTAINER_ID cp /etc/nginx/fullchain.pem /etc/nginx/$TIMESTAMP/fullchain.pem

# Update nginx proxy
docker exec $CONTAINER_ID wget "http://tasks.web_config/config/${DOMAINS}_fullchain.pem" -O /etc/nginx/fullchain.pem
docker exec $CONTAINER_ID wget "http://tasks.web_config/config/${DOMAINS}_privkey.pem" -O /etc/nginx/privkey.pem
docker exec $CONTAINER_ID sleep 3
docker exec $CONTAINER_ID /usr/sbin/nginx -s reload
