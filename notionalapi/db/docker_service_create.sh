# usage: ./docker_service_create.sh node_id
# eg., ./docker_service_create.sh 1

# Note: hardcoded cluster of 3 nodes (node_id=1,2 and 3).

node_id="$1"

if [[ -z $node_id ]]; then
  echo "No node_id. usage eg., ./docker_service_create.sh 1"
  exit
fi

SERVICE_NAME="napidb_${node_id}"

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --network bignet \
  --network notionalapi \
  --label 'cosmosia.service=napidb' \
  --constraint "node.labels.cosmosia.notionalapi.db==true" \
  --endpoint-mode dnsrr \
  --restart-condition none \
  rqlite/rqlite:7.21.4 -on-disk=true -bootstrap-expect 3 -join http://tasks.napidb_1:4001,http://tasks.napidb_2:4001,http://tasks.napidb_3:4001
