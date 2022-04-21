
git_branch=$(git symbolic-ref --short -q HEAD)

# delete existing service
docker service rm rpc_monitor

# create new service
docker service create \
  --name rpc_monitor \
  --replicas 1 \
  --network cosmosia \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/$git_branch/rpc_monitor/run.sh > ~/run.sh && /bin/bash ~/run.sh"


