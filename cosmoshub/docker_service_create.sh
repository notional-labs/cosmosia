# delete existing service
docker service rm cosmoshub


docker service create \
  --name cosmoshub \
  --replicas 1 \
  --publish 26658:26657 \
  --mount type=bind,source=$HOME/cosmosia,destination=/cosmosia \
  --mount type=bind,source=$HOME/cosmosia_data/cosmoshub,destination=/root \
  --network cosmosia \
  archlinux:latest \
  /bin/bash /cosmosia/cosmoshub/quicksync.sh
