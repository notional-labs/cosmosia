# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh juno

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create.sh juno"
  exit
fi

SERVICE_NAME="bdjuno_${chain_name}"

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --endpoint-mode dnsrr \
  --network cosmosia \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/indexer/indexer/bdjuno/run.sh > ~/run.sh && /bin/bash ~/run.sh $chain_name"