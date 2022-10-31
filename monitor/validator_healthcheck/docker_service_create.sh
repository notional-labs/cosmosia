# delete existing service
docker service rm validator_healthcheck

# create new service
docker service create \
  --name validator_healthcheck \
  --replicas 1 \
  --network cosmosia \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/validator_healthcheck/run.sh > ~/run.sh && /bin/bash ~/run.sh"


