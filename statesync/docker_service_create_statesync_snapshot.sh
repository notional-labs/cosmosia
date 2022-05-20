# usage: ./docker_service_create_statesync_snapshot.sh chain_name
# eg., ./docker_service_create_statesync_snapshot.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create_statesync_snapshot.sh cosmoshub"
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

echo "snapshot_node=$snapshot_node"


SERVICE_NAME=statesync_snapshot_$chain_name

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --mount type=bind,source=/mnt/data/snapshots/$chain_name,destination=/snapshot \
  --network cosmosia \
  --constraint "node.hostname==$snapshot_node" \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/statesync/statesync_snapshot_run.sh > ~/statesync_snapshot_run.sh && \
  /bin/bash ~/statesync_snapshot_run.sh $chain_name"
