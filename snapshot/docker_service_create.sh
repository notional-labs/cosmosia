# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh cosmoshub

chain_name="$1"
if [ -f "../env.sh" ]; then
  source ../env.sh
else
    echo "../env.sh file does not exist."
    exit
fi

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub"
  exit
fi

# functions
get_docker_snapshot_config () {
  str_snapshot_cfg=""


  if [ -f /.dockerenv ]; then
    # inside container
    str_snapshot_cfg="$(curl -s "http://tasks.web_config/config/cosmosia.snapshot.${chain_name}" |sed 's/ = /=/g')"
  else
    # inside host

    # figure out container id of agent
    agent_id=$(docker ps -aqf "name=agent")

    # execute command in agent container to get data version
    str_snapshot_cfg=$(docker exec $agent_id curl -s "http://tasks.web_config/config/cosmosia.snapshot.${chain_name}" |sed 's/ = /=/g')
  fi


  echo $str_snapshot_cfg
}

str_snapshot_cfg=$(get_docker_snapshot_config)
echo "str_snapshot_cfg=${str_snapshot_cfg}"

eval "$(curl -s "$CHAIN_REGISTRY_INI_URL" |awk -v TARGET=$chain_name -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ')"


eval "${str_snapshot_cfg}"

echo "network=$network"

HOST="$snapshot_node"
MOUNT_SRC="/mnt/data/snapshots/$chain_name"
SERVICE_NAME="snapshot_$chain_name"
MOUNT_OPT=""
if [[ -z $snapshot_storage_node ]]; then
  MOUNT_OPT="--mount type=bind,source=$MOUNT_SRC,destination=/snapshot"
fi

constraint="node.hostname==$HOST"
if [ $( echo "${chain_name}" | egrep -c "archive" ) -eq 0 ]; then
  # if pruned node, place on node with cosmosia.snapshot.pruned label, see https://github.com/notional-labs/cosmosia/issues/375
	constraint="node.labels.cosmosia.snapshot.pruned==true"
fi

echo "constraint= ${constraint}"
echo "SERVICE_NAME=$SERVICE_NAME"
echo "MOUNT_OPT=$MOUNT_OPT"


# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 $MOUNT_OPT \
  --network $network \
  --network snapshot \
  --label 'cosmosia.service=snapshot' \
  --constraint $constraint \
  --endpoint-mode dnsrr \
  --restart-condition none \
  --env-file ../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/snapshot_run.sh > ~/snapshot_run.sh && \
  /bin/bash ~/snapshot_run.sh $chain_name"
