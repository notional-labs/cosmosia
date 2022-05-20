# usage: ./docker_service_create_sss.sh chain_name
# eg., ./docker_service_create_sss.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create_sss.sh cosmoshub"
  exit
fi

# sss = statesync server

SERVICE_NAME=sss_$chain_name

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/statesync/sss_run.sh > ~/sss_run.sh && \
  /bin/bash ~/sss_run.sh $chain_name"
