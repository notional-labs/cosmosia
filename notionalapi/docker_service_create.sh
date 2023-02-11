# delete existing service
docker service rm notionalapi

# create new service
docker service create \
  --name notionalapi \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia31' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/notionalapi/run.sh > ~/run.sh && /bin/bash ~/run.sh"
