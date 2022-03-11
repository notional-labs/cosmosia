# delete existing service
docker service rm juno


docker service create \
  --name juno \
  --replicas 1 \
  --publish 26657:26657 \
  --mount type=bind,source=$HOME/cosmosia,destination=/cosmosia \
  --mount type=bind,source=$HOME/cosmosia_data/juno,destination=/root \
  archlinux:latest \
  /bin/bash /cosmosia/juno/quicksync.sh
