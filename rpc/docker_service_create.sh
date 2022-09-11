# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub"
  exit
fi

eval "$(awk -v TARGET=$chain_name -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ' ../data/chain_registry.ini )"

echo "network=$network"

git_branch=$(git symbolic-ref --short -q HEAD)

# functions
find_current_data_version () {
  ver=0
  ver=$(curl -s "https://snapshot.notional.ventures/$chain_name/chain.json" |jq -r '.data_version // 0')
  echo $ver
}


# get the data version from chain.json, service name is rpc_$chain_name_$version
data_version=$(find_current_data_version)

rpc_service_name="rpc_${chain_name}_${data_version}"

# delete existing service
docker service rm $rpc_service_name

docker service create \
  --name $rpc_service_name \
  --replicas 1 \
  --network $network \
  --label 'cosmosia.service=rpc' \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/$git_branch/rpc/quicksync.sh > ~/quicksync.sh && \
  /bin/bash ~/quicksync.sh $chain_name $rpc_service_name"
