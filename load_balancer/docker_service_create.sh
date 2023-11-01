# usage: ./docker_service_create.sh chain_name rpc_service_name [lb_type]
# eg., ./docker_service_create.sh cosmoshub rpc_cosmoshub_3 caddy

chain_name="$1"
rpc_service_name="$2"
lb_type="$3" # lb_type could be caddy or haproxy, default is caddy

if [[ $lb_type != "haproxy" ]]; then
  lb_type="caddy"
fi

echo "lb_type=${lb_type}"

if [ -f "../env.sh" ]; then
  source ../env.sh
else
  echo "../env.sh file does not exist."
  exit
fi


if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub rpc_cosmoshub_1 caddy"
  exit
fi

if [[ -z $rpc_service_name ]]; then
  echo "No rpc_service_name. usage eg., ./docker_service_create.sh cosmoshub rpc_cosmoshub_1 caddy"
  exit
fi

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

echo "network=$network"

SERVICE_NAME=lb_$chain_name

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --constraint "node.labels.cosmosia.lb==true" \
  --network $network \
  --label 'cosmosia.service=lb' \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/load_balancer/${lb_type}/run.sh > ~/run.sh && \
   /bin/bash ~/run.sh $rpc_service_name"


