# delete existing service
docker service rm proxy_interchain

# create new service
docker service create \
  --name proxy_interchain \
  --replicas 1 \
  --publish mode=host,target=443,published=443 \
  --network cosmosia \
  --network snapshot \
  --constraint 'node.hostname==cosmosia32' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy_custom/interchain/run.sh > ~/run.sh && /bin/bash ~/run.sh"
