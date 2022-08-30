# delete existing service
docker service rm proxy_public

# create new service
docker service create \
  --name proxy_public \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia5' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/112-wildcard-dns-records/proxy_public/run.sh > ~/run.sh && /bin/bash ~/run.sh"
