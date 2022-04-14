# delete existing service
docker service rm proxy_static

# create new service
docker service create \
  --name proxy_static \
  --replicas 1 \
  --publish mode=host,target=443,published=443 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia2' \
  --restart-condition any \
  --restart-delay 3s \
  --restart-max-attempts 3 \
  --restart-window 10m \
  --secret ssl_notional.ventures.tar.gz \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy_static/run.sh > ~/run.sh && /bin/bash ~/run.sh"


