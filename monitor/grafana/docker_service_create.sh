# delete existing service
docker service rm grafana

# create new service
docker service create \
  --name grafana \
  --replicas 1 \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --restart-condition any \
  --secret grafana_password \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/grafana/run.sh > ~/run.sh && /bin/bash ~/run.sh"


