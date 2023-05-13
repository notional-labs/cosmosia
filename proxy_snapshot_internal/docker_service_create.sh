# usage: ./docker_service_create.sh swarm_node
# eg., ./docker_service_create.sh cosmosia1

swarm_node="$1"

if [[ -z $swarm_node ]]
then
  echo "No swarm_node. usage eg., ./docker_service_create.sh cosmosia1"
  exit
fi

SERVICE_NAME="proxysnapshotinternal_$swarm_node"

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --mount type=bind,source=/mnt/data/snapshots,destination=/snapshots,readonly \
  --constraint "node.hostname==${swarm_node}" \
  --network snapshot \
  --network net1 \
  --network net2 \
  --network net3 \
  --network net4 \
  --network net5 \
  --network net6 \
  --network net7 \
  --network net8 \
  --endpoint-mode dnsrr \
  --restart-condition none \
  --env-file ../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy_snapshot_internal/run.sh > ~/run.sh && \
  /bin/bash ~/run.sh"
