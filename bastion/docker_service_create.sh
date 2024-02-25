# delete existing service
docker service rm bastion

# create new service
docker service create \
  --name bastion \
  --replicas 1 \
  --publish mode=host,target=22,published=22000 \
  --constraint "node.hostname==cosmosia1" \
  --network bignet \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/bastion/run.sh > ~/run.sh && \
   /bin/bash ~/run.sh"

