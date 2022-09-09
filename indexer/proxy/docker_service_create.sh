
git_branch=$(git symbolic-ref --short -q HEAD)

# delete existing service
docker service rm proxy

# create new service
docker service create \
  --name proxy \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia9' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/$git_branch/indexer/proxy/run.sh > ~/run.sh && /bin/bash ~/run.sh"


