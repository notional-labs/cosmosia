
git_branch=$(git symbolic-ref --short -q HEAD)

# delete existing service
docker service rm rpc_monitor_evmos

# create new service
docker service create \
  --name rpc_monitor_evmos \
  --replicas 1 \
  --network cosmosia \
  --network net4 \
  --network net5 \
  --network net6 \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/$git_branch/monitor/rpc_monitor_custom/evmos/run.sh > ~/run.sh && /bin/bash ~/run.sh"


