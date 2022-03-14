# delete existing service
docker service rm proxy


docker service create \
  --name proxy \
  --replicas 1 \
  --publish 80:80 \
  --network cosmosia \
  --restart-condition any \
  --restart-delay 3s \
  --restart-max-attempts 3 \
  --restart-window 10s \
  ubuntu:20.04 \
  /bin/bash -c \
  "export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl nginx && \
  curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/default.conf > /etc/nginx/sites-available/default && \
  curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/index.html > /var/www/html/index.html && \
  /usr/sbin/nginx -g \"daemon off;\""
