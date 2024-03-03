# delete existing service
docker service rm proxy_static

# create new service
docker service create \
  --name proxy_static \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --network bignet \
  --network cosmosia \
  --network snapshot \
  --constraint 'node.hostname==cosmosia23' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/static/run.sh > ~/run.sh && /bin/bash ~/run.sh"
