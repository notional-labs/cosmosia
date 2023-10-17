# delete existing service
docker service rm proxy_public2

# create new service
docker service create \
  --name proxy_public2 \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --publish mode=host,target=9090,published=9090 \
  --network cosmosia \
  --network notionalapi \
  --constraint 'node.hostname==cosmosia42' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/public-endpoint-gw/proxy/public/run.sh > ~/run.sh && /bin/bash ~/run.sh"
