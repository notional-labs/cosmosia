# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub"
  exit
fi


SERVICE_NAME=lb_$chain_name

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/load_balancer/run.sh > ~/run.sh && \
   /bin/bash ~/run.sh $chain_name"


