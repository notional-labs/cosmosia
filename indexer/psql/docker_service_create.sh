
SERVICE_NAME="psql_juno"

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --restart-condition none \
  --env MYVAR=mysecretpassword \
  postgres:latest