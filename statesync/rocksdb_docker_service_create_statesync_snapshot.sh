# usage: ./rocksdb_docker_service_create_statesync_snapshot.sh chain_name
# eg., ./rocksdb_docker_service_create_statesync_snapshot.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./rocksdb_docker_service_create_statesync_snapshot.sh cosmoshub"
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

echo "rocksdb_snapshot_node=$rocksdb_snapshot_node"


SERVICE_NAME=rocksdb_statesync_snapshot_$chain_name

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --mount type=bind,source=/mnt/data/rocksdb_snapshots/$chain_name,destination=/snapshot \
  --network cosmosia \
  --constraint "node.hostname==$rocksdb_snapshot_node" \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/57-add-rocksdb-snapshot-service/statesync/rocksdb_statesync_snapshot_run.sh > ~/rocksdb_statesync_snapshot_run.sh && \
  /bin/bash ~/rocksdb_statesync_snapshot_run.sh $chain_name"
