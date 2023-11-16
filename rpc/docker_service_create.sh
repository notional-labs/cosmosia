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

get_docker_rpc_constraint () {
  str_rpc_constraint=""

  if [ -f /.dockerenv ]; then
    # inside container
    str_snapshot_cfg="$(curl -s "http://tasks.web_config/config/cosmosia.snapshot.${chain_name}" |sed 's/ = /=/g')"
  else
    # inside host

    # figure out container id of agent
    agent_id=$(docker ps -aqf "name=agent")

    # execute command in agent container to get data version
    str_rpc_constraint=$(docker exec $agent_id curl -s "http://tasks.web_config/config/cosmosia.rpc.${chain_name}" |sed 's/ = /=/g')
  fi

  echo $str_rpc_constraint
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

# functions
find_current_data_version () {
  ver=0

  if [[ -z $USE_SNAPSHOT_PROXY_URL ]]; then
    # use internal snapshot proxy

    # 1. figure out the snapshot node
    node="$snapshot_storage_node"
    if [[ -z $node ]]; then
      node="$snapshot_node"
    fi

    if [ -f /.dockerenv ]; then
      # inside container
      ver=$(curl -Ls "http://proxysnapshot.${node}:11111/${chain_name}/chain.json" |jq -r '.data_version // 0')
    else
      # inside host

      # figure out container id of agent
      agent_id=$(docker ps -aqf "name=agent")

      # execute command in agent container to get data version
      ver=$(docker exec $agent_id curl -Ls "http://proxysnapshot.${node}:11111/${chain_name}/chain.json" |jq -r '.data_version // 0')
    fi
  else
    # use public snapshot proxy
    ver=$(curl -Ls "${USE_SNAPSHOT_PROXY_URL}/${chain_name}/chain.json" |jq -r '.data_version // 0')
  fi

  echo $ver
}

# get the data version from chain.json, service name is rpc_$chain_name_$version
data_version=$(find_current_data_version)

rpc_service_name="rpc_${chain_name}_${data_version}"

## use override constraint if found
#override_constraint=$(docker node ls -f node.label=cosmosia.rpc.${chain_name}=true | tail -n +2 |awk '{print $2}')
#if [[ -z $override_constraint ]]; then
#  echo "No override_constraint found"
#  constraint="node.labels.cosmosia.rpc.pruned==true"
#  if [ $( echo "${chain_name}" | egrep -c "archive" ) -ne 0 ]; then
#    # if archive node
#    constraint="node.labels.cosmosia.rpc.${chain_name}==true"
#  fi
#else
#  echo "Found override_constraint=${override_constraint}"
#  constraint="node.labels.cosmosia.rpc.${chain_name}==true"
#fi

constraint=$(get_docker_rpc_constraint)
echo "constraint=$constraint"

if [[ -z $constraint ]]; then
  echo "No rpc constraint config for ${chain_name}"
  exit
fi

# delete existing service
docker service rm $rpc_service_name

docker service create \
  --name $rpc_service_name \
  --replicas 1 \
  --constraint $constraint \
  --network $network \
  --label 'cosmosia.service=rpc' \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --env-file ../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/$git_branch/rpc/run.sh > ~/run.sh && \
  /bin/bash ~/run.sh $chain_name $rpc_service_name"
