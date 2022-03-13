# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub"
  exit
fi


# delete existing service
docker service rm $chain_name

docker service create \
  --name $chain_name \
  --replicas 1 \
  --network cosmosia \
  --restart-condition any \
  --restart-delay 3m \
  --restart-max-attempts 3 \
  --restart-window 10m \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/rpc/quicksync.sh > ~/quicksync.sh && \
  /bin/bash ~/quicksync.sh $chain_name"
