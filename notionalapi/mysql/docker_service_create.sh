
SERVICE_NAME="napi_mysql"

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --publish mode=host,target=3306,published=3306 \
  --network notionalapi \
  --constraint 'node.hostname==cosmosia21' \
  --endpoint-mode dnsrr \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "while true; do sleep 5; done"
