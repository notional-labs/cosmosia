echo "snapshot_cronjob..."

# functions
find_current_data_version () {
  ver=0
  ver=$(cat /snapshot/chain.json |jq -r '.data_version // 0')
  echo $ver
}


get_next_version () {
  ver=$(find_current_data_version)
  ver=$(( ${ver} + 1 ))
  echo $ver
}


data_version=$(find_current_data_version)


source $HOME/chain_info.sh

echo "#################################################################################################################"
echo "pruning..."

echo "snapshot_prune=$snapshot_prune"

if [[ $snapshot_prune == "cosmos-pruner" ]]; then
  # check snapshot size large than threshold or not
  chain_json_url="https://snapshot.notional.ventures/$chain_name/chain.json"

  echo "start pruning..."

  cd $node_home/data
  echo "Before:"
  du -h

  # no need to compact, pebble will auto-compact after starting the chain again in few mins.
  # Note that size after pruning is not smaller, however it'wll be compacted and smaller next time restarting
  $HOME/go/bin/cosmos-pruner prune $node_home/data --app=$chain_name --backend=pebbledb --blocks=201600 --versions=362880 --compact=false

  # Delete tx_index.db
#    rm -rf $node_home/data/tx_index.db

  echo "After prune:"
  du -h

  data_version=$(get_next_version)
fi


echo "#################################################################################################################"
echo "creating snapshot file..."
supervisorctl start chain

##############
echo "wait till chain get synched..."

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

# need for osmosis only, will be removed in the future versions
if [[ $chain_name == "osmosis" ]]; then
  supervisorctl start chain
  sleep 60
  supervisorctl stop chain
  sleep 60
fi


echo "creating snapshot..."
cd $node_home

TAR_FILENAME="data_$(date +%Y%m%d_%T |sed 's/://g').tar.gz"
TAR_FILE_PATH="$HOME/$TAR_FILENAME"

# snapshot file includes ALL dirs in $node_home excluding config dir
included_dirs=$(ls -d * |grep -v config| tr '\n' ' ')

tar -czvf $TAR_FILE_PATH $included_dirs

FILESIZE=$(stat -c%s "$TAR_FILE_PATH")

# copy to /snapshot folder
mv $TAR_FILE_PATH /snapshot/
cp $node_home/config/addrbook.json /snapshot/

cat <<EOT > /snapshot/chain.json
{
    "snapshot_url": "./$chain_name/$TAR_FILENAME",
    "file_size": $FILESIZE,
    "data_version": $data_version
}
EOT

# delete old snapshots
cd /snapshot/ && rm $(ls *.tar.gz |sort |head -n -2)
