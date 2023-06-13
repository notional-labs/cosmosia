# usage: ./docker_service_create.sh swarm_node
# eg., ./docker_service_create.sh cosmosia1

swarm_node="$1"

if [[ -z $swarm_node ]]
then
  echo "No swarm_node. usage eg., ./docker_service_create.sh cosmosia1"
  exit
fi

SERVICE_NAME="proxysnapshot_$swarm_node"

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --publish mode=host,target=80,published=11111 \
  --network snapshot \
  --mount type=bind,source=/mnt/data/snapshots,destination=/snapshots,readonly \
  --constraint "node.hostname==${swarm_node}" \
  --restart-condition none \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/snapshot/run.sh > ~/run.sh && \
  /bin/bash ~/run.sh"
