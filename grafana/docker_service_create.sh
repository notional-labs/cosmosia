# delete existing service
docker service rm grafana

# create new service
docker service create \
  --name grafana \
  --replicas 1 \
  --publish mode=host,target=3000,published=3000 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia7' \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/grafana/run.sh > ~/run.sh && /bin/bash ~/run.sh"


