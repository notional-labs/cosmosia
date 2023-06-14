
# delete existing service
docker service rm proxy_legacy

# create new service
docker service create \
  --name proxy_legacy \
  --mode global \
  --constraint "node.labels.cosmosia.proxy.legacy==true" \
  --endpoint-mode dnsrr \
  --publish mode=host,target=80,published=80 \
  --network cosmosia \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/legacy/run.sh > ~/run.sh && /bin/bash ~/run.sh"


