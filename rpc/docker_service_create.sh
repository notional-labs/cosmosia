# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh cosmoshub

chain_name="$1"
source ../env.sh

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub"
  exit
fi

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

echo "network=$network"
echo "snapshot_node=$snapshot_node"
echo "snapshot_storage_node=$snapshot_storage_node"

git_branch=$(git symbolic-ref --short -q HEAD)

# functions
find_current_data_version () {
  # 1. figure out the snapshot node
  node="$snapshot_storage_node"
  if [[ -z $node ]]; then
    node="$snapshot_node"
  fi

  # 2. figure out container id of agent
  agent_id=$(docker ps -aqf "name=agent")

  # 3. execute command in agent container to get data version
  ver=0
  ver=$(docker exec $agent_id curl -Ls "http://tasks.${node}:11111/$chain_name/chain.json" |jq -r '.data_version // 0')
  echo $ver
}


# get the data version from chain.json, service name is rpc_$chain_name_$version
data_version=$(find_current_data_version)

rpc_service_name="rpc_${chain_name}_${data_version}"

echo $rpc_service_name
# exit to debug
exit


constraint="node.labels.cosmosia.rpc.pruned==true"
if [ $( echo "${chain_name}" | egrep -c "archive" ) -ne 0 ]; then
	constraint="node.labels.cosmosia.rpc.${chain_name}==true"
fi

echo "constraint=$constraint"

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
