# usage: ./docker_service_create.sh chain_name node_num [-d]
# eg., ./docker_service_create.sh cosmoshub 1
# use -d to clear old data

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

# note: have to call shift to fix the issue that getopts doesn't work there are both params ($1) and the options
shift 2
opt_clear_data=false


OPTSTRING=":d"
# d: delete existing data, default is false

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    d)
      echo "opt_clear_data Option -d was triggered."
      opt_clear_data=true
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

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

get_docker_rpc_config () {
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

######

rpc_service_name="rpc_${chain_name}_${node_num}"

rpc_config=$(get_docker_rpc_config)
#  example config:
#  node_1 = "cosmosia52"
#  node_2 = "cosmosia54"

echo "rpc_config=${rpc_config}"
eval "${rpc_config}"
var_rpc_node="node_${node_num}"
rpc_node=${!var_rpc_node}
echo "rpc_node=${rpc_node}"

# figure out IP of the remote host
agent_id=$(docker ps -aqf "name=agent")
rpc_node_ip=$(docker exec $agent_id curl -s "http://tasks.web_config:2375/nodes/${rpc_node}" |jq -r ".Status.Addr")
echo "rpc_node_ip=${rpc_node_ip}"

# make sure folder exist on remote host before mounting
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${rpc_node_ip} "mkdir -p /mnt/data/rpc/${chain_name}_${node_num}"

MOUNT_OPT="--mount type=bind,source=/mnt/data/rpc/${chain_name}_${node_num},destination=$node_home"

constraint="node.hostname==$rpc_node"
echo "constraint=$constraint"

if [[ -z $constraint ]]; then
  echo "No rpc constraint config for ${chain_name}"
  exit
fi

# delete existing service
docker service rm $rpc_service_name

echo "sleep 30s...."
sleep 30

echo "opt_clear_data = $opt_clear_data"
if [ "$opt_clear_data" = true ] ; then
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${rpc_node_ip} "rm -rf /mnt/data/rpc/${chain_name}_${node_num}/*"
fi

sleep 5

docker service create \
  --name $rpc_service_name \
  --replicas 1 $MOUNT_OPT \
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
