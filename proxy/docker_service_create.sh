# delete existing service
docker service rm proxy


docker service create \
  --name proxy \
  --replicas 1 \
  --publish 80:80 \
  --network cosmosia \
  archlinux:latest \
  /bin/bash -c \
  "export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl nginx && \
  curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf && \
  curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/html/index.html > /usr/share/nginx/html/index.html && \
  usr/sbin/nginx -g \"daemon off;\""




#  --mount type=bind,source=$HOME/cosmosia/proxy/html,destination=/usr/share/nginx/html \
#  --mount type=bind,source=$HOME/cosmosia/proxy/nginx,destination=/etc/nginx \