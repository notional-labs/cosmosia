# usage: ./docker_service_create_statesync_snapshot.sh chain_name [db_backend]
# eg., ./docker_service_create_statesync_snapshot.sh cosmoshub goleveldb
# db_backend: goleveldb rocksdb, default is goleveldb

chain_name="$1"
db_backend="$2"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create_statesync_snapshot.sh cosmoshub [db_backend]"
  exit
fi

if [[ -z $db_backend ]]; then
  db_backend="goleveldb"
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


HOST="$snapshot_node"
MOUNT_SRC="/mnt/data/snapshots/$chain_name"
SERVICE_NAME="statesync_snapshot_$chain_name"

if [[ $db_backend == "rocksdb" ]]; then
  HOST="$rocksdb_snapshot_node"
  SERVICE_NAME="rocksdb_statesync_snapshot_$chain_name"
  MOUNT_SRC="/mnt/data/rocksdb_snapshots/$chain_name"
fi

echo "HOST=$HOST"
echo "SERVICE_NAME=$SERVICE_NAME"

# delete existing service
docker service rm $SERVICE_NAME

docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --mount type=bind,source=$MOUNT_SRC,destination=/snapshot \
  --network cosmosia \
  --constraint "node.hostname==$HOST" \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/statesync/statesync_snapshot_run.sh > ~/statesync_snapshot_run.sh && \
  /bin/bash ~/statesync_snapshot_run.sh $chain_name $db_backend"
