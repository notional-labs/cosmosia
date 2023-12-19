# Note:
# set grafana admin default password by using docker swarm config with key GRAFANA_PASSWORD

# delete existing service
docker service rm grafana_relayer

# create new service
docker service create \
  --name grafana_relayer \
  --replicas 1 \
  --network bignet \
  --constraint "node.labels.cosmosia.relay==true" \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/493-relayer-dashboard/monitor/grafana-relayer/run.sh > ~/run.sh && /bin/bash ~/run.sh"


