# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub"
  exit
fi



git_branch=$(git symbolic-ref --short -q HEAD)


# delete existing service
docker service rm $chain_name

docker service create \
  --name $chain_name \
  --replicas 1 \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/$git_branch/rpc/quicksync.sh > ~/quicksync.sh && \
  /bin/bash ~/quicksync.sh $chain_name"
