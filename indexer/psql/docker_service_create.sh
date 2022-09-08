# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh juno

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create.sh juno"
  exit
fi

SERVICE_NAME="psql_${chain_name}"

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --restart-condition none \
  --env POSTGRES_PASSWORD=mysecretpassword \
  postgres:latest