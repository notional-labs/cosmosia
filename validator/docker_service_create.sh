# usage: ./docker_service_create.sh chain_name node_num
# eg., ./docker_service_create.sh cosmoshub 1

chain_name="$1"
node_num="$2"
if [ -f "../env.sh" ]; then
  source ../env.sh
else
    echo "../env.sh file does not exist."
    exit
fi

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub 1"
  exit
fi

if [[ -z $node_num ]]; then
  echo "No node_num. usage eg., ./docker_service_create.sh cosmoshub 1"
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
echo "snapshot_node=$snapshot_node"
echo "snapshot_storage_node=$snapshot_storage_node"

git_branch=$(git symbolic-ref --short -q HEAD)
val_service_name="val_${chain_name}_${node_num}"

# delete existing service
docker service rm $val_service_name

docker service create \
  --name $val_service_name \
  --replicas 1 \
  --constraint "node.labels.cosmosia.val==true" \
  --network bignet \
  --network $network \
  --label 'cosmosia.service=val' \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --env-file ../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/$git_branch/validator/run.sh > ~/run.sh && \
  /bin/bash ~/run.sh $chain_name $val_service_name"
