# usage: ./docker_service_create_snapshost.sh chain_name
# eg., ./docker_service_create_snapshost.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create_snapshost.sh cosmoshub"
  exit
fi



git_branch=$(git symbolic-ref --short -q HEAD)

SERVICE_NAME=snapshot_$chain_name


# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network cosmosia \
  --restart-condition any \
  --restart-delay 3m \
  --restart-max-attempts 3 \
  --restart-window 10m \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/$git_branch/snapshot/snapshot_run.sh > ~/snapshot_run.sh && \
  /bin/bash ~/snapshot_run.sh $chain_name"
