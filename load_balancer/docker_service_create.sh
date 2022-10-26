# usage: ./docker_service_create.sh chain_name [rpc_service_name]
# eg., ./docker_service_create.sh cosmoshub [rpc_cosmoshub_3]

chain_name="$1"
rpc_service_name="$2"

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

SERVICE_NAME=lb_$chain_name

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --constraint "node.labels.cosmosia.lb.${chain_name}==true" \
  --network $network \
  --network cosmosia \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/load_balancer/run.sh > ~/run.sh && \
   /bin/bash ~/run.sh $rpc_service_name"


