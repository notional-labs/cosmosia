# usage: ./snapshot_cronjob.sh [db_backend]
# eg., ./snapshot_cronjob.sh goleveldb
# db_backend: goleveldb rocksdb, default is goleveldb

echo "snapshot_cronjob..."

db_backend="$1"
[[ -z $db_backend ]] && db_backend="goleveldb"

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
echo "snapshot_prune_threshold=$snapshot_prune_threshold"

if [[ $snapshot_prune == "cosmos-pruner" ]]; then
  # check snapshot size large than threshold or not
  SNAPSHOT_THRESHOLD_BYTE=$((${snapshot_prune_threshold} * 1024 * 1024 * 1024))
  chain_json_url="https://snapshot.notional.ventures/$chain_name/chain.json"
  [[ $db_backend == "rocksdb" ]] && chain_json_url="https://snapshot.notional.ventures/$chain_name/rocksdb/chain.json"

  snapshot_file_size=$(curl -s "$chain_json_url" |jq -r '.file_size')

  if [[ ${SNAPSHOT_THRESHOLD_BYTE} -le ${snapshot_file_size} ]]; then
    echo "start pruning..."

    cd $node_home/data
    echo "Before:"
    du -h


    if [[ $db_backend == "rocksdb" ]]; then
        if [ $( echo "${chain_name}" | egrep -c "^(osmosis|cosmoshub|kava|terra)$" ) -ne 0 ]; then
          $HOME/go/bin/cosmos-pruner prune $node_home/data --app=$chain_name --backend=rocksdb --blocks=201600 --versions=362880
        else
          $HOME/go/bin/cosmos-pruner prune $node_home/data --backend=rocksdb --blocks=201600 --versions=362880
        fi
    else
      if [ $( echo "${chain_name}" | egrep -c "^(osmosis|cosmoshub|kava|terra)$" ) -ne 0 ]; then
        $HOME/go/bin/cosmos-pruner prune $node_home/data --app=$chain_name --blocks=201600 --versions=362880
      elif [[ $chain_name == "provenance" ]]; then
        $HOME/go/bin/cosmos-pruner prune $node_home/data --backend=cleveldb --blocks=201600 --versions=362880
      else
        $HOME/go/bin/cosmos-pruner prune $node_home/data --blocks=201600 --versions=362880
      fi
    fi


    # Delete tx_index.db
    rm -rf $node_home/data/tx_index.db

    echo "After:"
    du -h

    data_version=$(get_next_version)
  else
    echo "No need to prune"
  fi

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
echo "OK, chain get synched, taking snapshot..."
echo "data_version=$data_version"

supervisorctl stop chain
sleep 60

# make sure chain stopped
killall $daemon_name
sleep 10

cd $node_home

TAR_FILENAME="data_$(date +%Y%m%d_%T |sed 's/://g').tar.gz"
TAR_FILE_PATH="$HOME/$TAR_FILENAME"

# snapshot file includes ALL dirs in $node_home excluding config dir
included_dirs=$(ls -d * |grep -v config| tr '\n' ' ')

tar -czvf $TAR_FILE_PATH $included_dirs & sleep 2 && cpulimit -l 50 -p $(pidof gzip)

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
cd /snapshot/ && rm $(ls *.tar.gz |sort |head -n -1)
