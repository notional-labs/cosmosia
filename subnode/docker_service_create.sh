# delete existing service
docker service rm osmosis-subnode

# create new service
docker service create \
  --name proxy_interchain \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --publish mode=host,target=26657,published=26657 \
  --publish mode=host,target=1337,published=1337 \
  --publish mode=host,target=9090,published=9090 \
  --constraint 'node.hostname==cosmosia32' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/286-deploy-osmosis-subnode-for-testing/subnode/run.sh > ~/run.sh && /bin/bash ~/run.sh"
