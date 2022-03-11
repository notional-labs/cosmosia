# delete existing service
docker service rm osmosis


docker service create \
  --name osmosis \
  --replicas 1 \
  --publish 26659:26657 \
  --mount type=bind,source=$HOME/cosmosia,destination=/cosmosia \
  --mount type=bind,source=$HOME/cosmosia_data/osmosis,destination=/root \
  archlinux:latest \
  /bin/bash /cosmosia/osmosis/quicksync.sh
