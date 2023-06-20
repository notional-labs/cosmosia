# Note:
# set grafana admin default password by using docker swarm config with key GRAFANA_PASSWORD

# delete existing service
docker service rm grafana

# create new service
docker service create \
  --name grafana \
  --replicas 1 \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/grafana/run.sh > ~/run.sh && /bin/bash ~/run.sh"


