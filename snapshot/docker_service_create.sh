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

# to get the url to the config file
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

echo "config=$config"
# load config
eval "$(curl -s "$config" |sed 's/ = /=/g')"

str_snapshot_cfg=$(get_docker_snapshot_config)
echo "str_snapshot_cfg=${str_snapshot_cfg}"
eval "${str_snapshot_cfg}"
echo "network=$network"

#HOST="$snapshot_node"
MOUNT_SRC="/mnt/data/snapshots/$chain_name"
SERVICE_NAME="snapshot_$chain_name"

constraint="node.hostname==$snapshot_node"

## use override constraint if found
#override_constraint=$(docker node ls -f node.label=cosmosia.snapshot.${chain_name}=true | tail -n +2 |awk '{print $2}')
#if [[ -z $override_constraint ]]; then
#  echo "No override_constraint found"
#  constraint="node.hostname==$HOST"
#  if [ $( echo "${chain_name}" |grep -cE "archive" ) -eq 0 ]; then
#    # if pruned node, place on node with cosmosia.snapshot.pruned label, see https://github.com/notional-labs/cosmosia/issues/375
#    constraint="node.labels.cosmosia.snapshot.pruned==true"
#  fi
#else
#  echo "Found override_constraint=${override_constraint}"
#  constraint="node.labels.cosmosia.snapshot.${chain_name}==true"
#fi

# for chain data
# MOUNT_OPT="--mount type=bind,source=$MOUNT_SRC,destination=/node_data"
MOUNT_OPT="--mount type=bind,source=$MOUNT_SRC,destination=$node_home"

# figure out IP of the remote host
agent_id=$(docker ps -aqf "name=agent")
snapshot_node_ip=$(docker exec $agent_id curl -s "http://tasks.web_config:2375/nodes/${snapshot_node}" |jq -r ".Status.Addr")

# make sure folder exist on remote host before mounting
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${snapshot_node_ip} "mkdir -p /mnt/data/snapshots/${chain_name}"

echo "constraint= ${constraint}"
echo "SERVICE_NAME=$SERVICE_NAME"
echo "MOUNT_OPT=$MOUNT_OPT"


# delete existing service
docker service rm $SERVICE_NAME

echo "sleep 20s..."
sleep 30

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 $MOUNT_OPT \
  --network bignet \
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
