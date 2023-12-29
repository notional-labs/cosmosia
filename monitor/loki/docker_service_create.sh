# delete existing service
docker service rm loki

# create new service
docker service create \
  --name loki \
  --replicas 1 \
  --network bignet \
  --constraint "node.labels.cosmosia.relay==true" \
  --endpoint-mode dnsrr \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/loki/monitor/main/run.sh > ~/run.sh && /bin/bash ~/run.sh"


