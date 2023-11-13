# delete existing service
docker service rm proxy_internal

# create new service
docker service create \
  --name proxy_internal \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --publish mode=host,target=9090,published=9090 \
  --network cosmosia \
  --network subnode \
  --network net1 \
  --network net2 \
  --network net3 \
  --network net4 \
  --network net5 \
  --network net6 \
  --network net7 \
  --network net8 \
  --constraint 'node.hostname==cosmosia30' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/internal/run.sh > ~/run.sh && /bin/bash ~/run.sh"
