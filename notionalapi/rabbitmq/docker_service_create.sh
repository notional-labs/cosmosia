
SERVICE_NAME="napi_rabbitmq"

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --publish mode=host,target=15672,published=15672 \
  --publish mode=host,target=5672,published=5672 \
  --network notionalapi \
  --constraint 'node.hostname==cosmosia21' \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "while true; do sleep 5; done"


