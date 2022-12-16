# delete existing service
docker service rm proxy_custom_quicksilver

# create new service
docker service create \
  --name proxy_custom_quicksilver \
  --replicas 1 \
  --publish mode=host,target=443,published=443 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia9' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy_custom/run.sh > ~/run.sh && /bin/bash ~/run.sh"


