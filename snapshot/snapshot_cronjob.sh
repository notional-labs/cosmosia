echo "snapshot_cronjob..."

source $HOME/env.sh

# functions
find_current_data_version () {
  ver=0
  ver=$(curl -Ls "https://snapshot.notional.ventures/$chain_name/chain.json" |jq -r '.data_version // 0')
  echo $ver
}


get_next_version () {
  ver=$(find_current_data_version)
  ver=$(( ${ver} + 1 ))
  echo $ver
}

data_version=$(find_current_data_version)

##############
echo "wait till chain get synched..."
supervisorctl start chain

catching_up=true
while [[ "$catching_up" != "false" ]]; do
  sleep 60;
  catching_up=$(curl --silent --max-time 3 "http://localhost:26657/status" |jq -r .result.sync_info.catching_up)
  echo "catching_up=$catching_up"
done

##############
echo "OK, chain get synched"
echo "data_version=$data_version"

supervisorctl stop chain
sleep 60

echo "#################################################################################################################"
echo "pruning..."
echo "snapshot_prune=$snapshot_prune"

if [[ $snapshot_prune == "cosmos-pruner" ]]; then
  # check snapshot size large than threshold or not
  chain_json_url="https://snapshot.notional.ventures/$chain_name/chain.json"

  cd $node_home/data
  echo "Before:"
  du -h

  # no need to compact, pebble will auto-compact after starting the chain again in few mins.
  # Note that size after pruning is not smaller, however it'wll be compacted and smaller next time restarting
  $HOME/go/bin/cosmos-pruner prune $node_home/data --app=$chain_name --backend=pebbledb --blocks=201600 --versions=362880 --compact=true

  echo "After:"
  du -h

  data_version=$(get_next_version)
fi

echo "#################################################################################################################"
echo "creating snapshot file..."
cd $node_home

TAR_FILENAME="data_$(date +%Y%m%d_%T |sed 's/://g').tar.gz"
TAR_FILE_PATH="/snapshot/$TAR_FILENAME"

# snapshot file includes ALL dirs in $node_home excluding config dir
included_dirs=$(ls -d * |grep -v config| tr '\n' ' ')

if [[ -z $snapshot_storage_node ]]; then
  tar -cvf - $included_dirs |pigz --best -p8 > $TAR_FILE_PATH
else
  tar -cvf - $included_dirs |pigz --best -p8 |ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${snapshot_storage_node}.notional.ventures "cat > /mnt/data/snapshots/${chain_name}/${TAR_FILENAME}"
fi

# FILESIZE=$(stat -c%s "$TAR_FILE_PATH")
FILESIZE=0

# addrbook.json
if [[ -z $snapshot_storage_node ]]; then
  cp $node_home/config/addrbook.json /snapshot/
else
  scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -prq "${node_home}/config/addrbook.json" "root@${snapshot_storage_node}.notional.ventures:/mnt/data/snapshots/${chain_name}/"
fi


# chain.json file
node="$snapshot_storage_node"
if [[ -z $node ]]; then
  node="$snapshot_node"
fi

cat <<EOT > $HOME/chain.json
{
    "snapshot_url": "http://${node}.notional.ventures:11111/$chain_name/$TAR_FILENAME",
    "file_size": $FILESIZE,
    "data_version": $data_version
}
EOT

if [[ -z $snapshot_storage_node ]]; then
  cp $HOME/chain.json /snapshot/
else
  scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -prq "$HOME/chain.json" "root@${snapshot_storage_node}.notional.ventures:/mnt/data/snapshots/${chain_name}/"
fi

# delete old snapshots before creating new snapshot to save disk space
if [[ -z $snapshot_storage_node ]]; then
  cd /snapshot/ && rm $(ls *.tar.gz |sort |head -n -2)
else
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${snapshot_storage_node}.notional.ventures "cd /mnt/data/snapshots/${chain_name}/ && rm $(ls *.tar.gz |sort |head -n -2)"
fi
