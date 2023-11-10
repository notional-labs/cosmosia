# delete existing service
docker service rm proxy_custom_quicksilver

# create new service
docker service create \
  --name proxy_custom_quicksilver \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --publish mode=host,target=9090,published=9090 \
  --network cosmosia \
  --network net1 \
  --network net2 \
  --network net3 \
  --network net4 \
  --network net5 \
  --network net6 \
  --network net7 \
  --network net8 \
  --constraint 'node.hostname==cosmosia16' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/notional/proxy/quicksilver/run.sh > ~/run.sh && /bin/bash ~/run.sh"
