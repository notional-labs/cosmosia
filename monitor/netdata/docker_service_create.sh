# usage: ./docker_service_create.sh swarm_node
# eg., ./docker_service_create.sh cosmosia1

swarm_node="$1"

if [[ -z $swarm_node ]]
then
  echo "No swarm_node. usage eg., ./docker_service_create.sh cosmosia1"
  exit
fi

SERVICE_NAME="netdata_$swarm_node"

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --publish mode=host,target=19999,published=19999 \
  --mount type=bind,source=/proc,destination=/host/proc,readonly \
  --mount type=bind,source=/sys,destination=/host/sys,readonly \
  --mount type=bind,source=/etc/os-release,destination=/host/etc/os-release,readonly \
  --constraint 'node.hostname==${swarm_node}' \
  --restart-condition none \
  netdata/netdata
