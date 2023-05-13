
git_branch=$(git symbolic-ref --short -q HEAD)

# delete existing service
docker service rm rpc_monitor

# create new service
docker service create \
  --name rpc_monitor \
  --replicas 1 \
  --constraint 'node.hostname!=cosmosia16' \
  --network cosmosia \
  --network net1 \
  --network net2 \
  --network net3 \
  --network net4 \
  --network net5 \
  --network net6 \
  --network net7 \
  --network net8 \
  --endpoint-mode dnsrr \
  --restart-condition any \
  --env-file ../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/$git_branch/rpc_monitor/run.sh > ~/run.sh && /bin/bash ~/run.sh"


