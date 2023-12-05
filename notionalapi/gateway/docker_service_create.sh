# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh cosmoshub
# for subnode: eg., ./docker_service_create.sh sub_cosmoshub

chain_name="$1"
if [ -f "../../env.sh" ]; then
  source ../../env.sh
else
    echo "../../env.sh file does not exist."
    exit
fi

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub"
  exit
fi


net=""
# check if subnode
if [[ $chain_name == sub_* ]]; then
#  net="subnode"

  subnode_name="${chain_name#sub_}"

  eval "$(awk -v TARGET=$subnode_name -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ' ../../data/subnode_registry.ini )"

  net="$network"
else
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
  net="$network"
fi

echo "net=$net"

SERVICE_NAME="napigw_${chain_name}"

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --constraint "node.labels.cosmosia.notionalapi.gw==true" \
  --network bignet \
  --network $net \
  --network notionalapi \
  --label 'cosmosia.service=napigw' \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition any \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/notionalapi/gateway/run.sh > ~/run.sh && \
  /bin/bash ~/run.sh $chain_name"
