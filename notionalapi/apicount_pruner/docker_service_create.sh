
SERVICE_NAME="napi_apicount_pruner"

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network notionalapi \
  --endpoint-mode dnsrr \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/notionalapi/apicount_pruner/run.sh > ~/run.sh && /bin/bash ~/run.sh"
