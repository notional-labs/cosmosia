
SERVICE_NAME="napiweb"

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network notionalapi \
  --constraint "node.labels.cosmosia.notionalapi==true" \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/napiweb/notionalapi/web/run.sh > ~/run.sh && /bin/bash ~/run.sh"


