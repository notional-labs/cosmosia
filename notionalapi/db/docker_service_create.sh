# usage: ./docker_service_create.sh
# eg., ./docker_service_create.sh

SERVICE_NAME="napidb"

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --hostname="{{.Service.Name}}.{{.Node.Hostname}}" \
  --replicas 1 \
  --network notionalapi \
  --label 'cosmosia.service=napidb' \
  --constraint "node.labels.cosmosia.notionalapi==true" \
  --endpoint-mode dnsrr \
  --restart-condition none \
  rqlite/rqlite -on-disk=true
