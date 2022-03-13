# delete existing service
docker service rm osmosis


docker service create \
  --name osmosis \
  --replicas 1 \
  --publish 26659:26657 \
  --mount type=bind,source=$HOME/cosmosia,destination=/cosmosia,ro \
  --mount type=bind,source=$HOME/cosmosia_data/osmosis,destination=/root \
  --network cosmosia \
  archlinux:latest \
  /bin/bash /cosmosia/quicksync.sh osmosis
