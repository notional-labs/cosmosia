echo "snapshot_cronjob..."

opt_nosync=false

OPTSTRING=":n"
# n: no sync, default is false

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    n)
      echo "no-sync Option -n was triggered."
      opt_nosync=true
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done


source $HOME/env.sh

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

    # 2. get data version
    ver=$(curl -Ls "http://proxysnapshot.${node}:11111/${chain_name}/chain.json" |jq -r '.data_version // 0')
  else
    # use public snapshot proxy
    ver=$(curl -Ls "${USE_SNAPSHOT_PROXY_URL}/${chain_name}/chain.json" |jq -r '.data_version // 0')
  fi

  echo $ver
}

get_next_version () {
  ver=$(find_current_data_version)
  ver=$(( ${ver} + 1 ))
  echo $ver
}

data_version=$(find_current_data_version)

##############
echo "opt_nosync = $opt_nosync"
if [ "$opt_nosync" = false ] ; then
  echo "wait till chain get synched..."
  supervisorctl start chain

  THRESHOLD_TIME=120
  catching_up=true
  counter=1
  while [[ "$catching_up" != "false" ]]; do
    sleep 60;

    BLOCKCHAIN_TIME=$(curl --silent --max-time 3 "http://localhost:26657/status" |jq -r .result.sync_info.latest_block_time)
    if [ $( echo "${chain_name}" | grep -cE "^(sei|sei-archive-sub|sei-testnet)$" ) -ne 0 ]; then
      BLOCKCHAIN_TIME=$(curl --silent --max-time 3 "http://localhost:26657/status" |jq -r .sync_info.latest_block_time)
    fi

    if [[ "${BLOCKCHAIN_TIME}" != "null" ]]; then
      if [[ ! -z "$BLOCKCHAIN_TIME" ]]; then
        BLOCKCHAIN_SECS=`date -d $BLOCKCHAIN_TIME +%s`
        CURRENT_SECS=`date +%s`

        # if within $THRESHOLD_TIME seconds of current time, call it synced
        BLOCK_AGE=$((${CURRENT_SECS} - ${BLOCKCHAIN_SECS}))

        if [[ ${BLOCK_AGE} -le ${THRESHOLD_TIME} ]]; then
          catching_up="false"
        fi
      fi
    fi

    echo "catching_up=${catching_up}, counter=${counter}"

    # restart node every hour to avoid OOM
    counter=$(( ${counter} + 1 ))
    if (( counter > 60 )); then
      supervisorctl stop chain
      sleep 60
      supervisorctl start chain
      counter=1
    fi
  done
fi

##############
echo "OK, chain get synched"
echo "data_version=$data_version"

supervisorctl stop chain
sleep 60

echo "Synchronize cached writes to persistent storage"
sync $node_home/data
sleep 30

echo "#################################################################################################################"
echo "pruning..."
echo "snapshot_prune=$snapshot_prune"

if [[ $snapshot_prune == "cosmos-pruner" ]]; then
  day_of_month=$( date +%d )
  # remove the leading zero, eg 08 => 8
  day_of_month=$(echo $day_of_month | sed 's/^0*//')

  if [[ $((day_of_month%3)) -eq 0 ]]; then
    cd $node_home/data

    # no need to compact, pebble will auto-compact after starting the chain again in few mins.
    # Note that size after pruning is not smaller, however it'wll be compacted and smaller next time restarting
    pruned_app_name=$(echo $chain_name | cut -d "-" -f1)
    if [ $( echo "${chain_name}" |grep -cE "pruned" ) -ne 0 ]; then
      # if pruned node (not default), then do nothing
      # $HOME/go/bin/cosmos-pruner prune $node_home/data --app=$pruned_app_name --backend=pebbledb --blocks=1000 --versions=1000 --tx_index=false --compact=true
      echo "cosmos-pruner....pruned node, do nothing"
    else
      if [ "$pruned_app_name" = "osmosis" ]; then
         $HOME/go/bin/$daemon_name prune --pruning-keep-recent 362880 --app-db-backend 'pebbledb'
      fi

      $HOME/go/bin/cosmos-pruner prune $node_home/data --app=$pruned_app_name --backend=$db_backend --blocks=362880 --versions=362880 --compact=true
    fi
  fi

  data_version=$(get_next_version)
fi

echo "#################################################################################################################"
echo "creating snapshot file..."
cd $node_home

TAR_FILENAME="data_$(date +%Y%m%d_%T |sed 's/://g').tar.gz"

# snapshot file includes ALL dirs in $node_home excluding config dir
included_dirs=$(ls -d * |grep -v config| tr '\n' ' ')

tar -cvf - $included_dirs |pigz --best -p8 |ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${snapshot_storage_node_ip} "cat > /mnt/data/snapshots/${chain_name}/${TAR_FILENAME}"

FILESIZE=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${snapshot_storage_node_ip} stat -c%s "/mnt/data/snapshots/${chain_name}/${TAR_FILENAME}")
if [[ -z $FILESIZE ]]; then
  FILESIZE=0
fi

cat <<EOT > $HOME/chain.json
{
    "snapshot_url": "http://${snapshot_storage_node_ip}:11111/$chain_name/$TAR_FILENAME",
    "file_size": $FILESIZE,
    "data_version": $data_version
}
EOT

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -prq "$HOME/chain.json" "root@${snapshot_storage_node_ip}:/mnt/data/snapshots/${chain_name}/"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -prq "${node_home}/config/addrbook.json" "root@${snapshot_storage_node_ip}:/mnt/data/snapshots/${chain_name}/"

# delete old snapshots before creating new snapshot to save disk space
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${snapshot_storage_node_ip} "cd /mnt/data/snapshots/${chain_name}/ && rm \$(ls *.tar.gz |sort |head -n -2)"
