# usage: ./create_snapshot.sh chain_name
# eg., ./snapshost_run.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./create_snapshot.sh cosmoshub"
  exit
fi


eval "$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |awk -v TARGET=$chain_name -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ')"

echo "node_home=$node_home"

cd $node_home

rm -rf $node_home/data/snapshots/*

# make sure /snapshot/statesync path exist
mkdir -p "/snapshot/statesync"

TAR_FILENAME="data_$(date +%Y%m%d_%T |sed 's/://g').tar.gz"
TAR_FILE_PATH="/snapshot/statesync/$TAR_FILENAME"

# snapshot file includes ALL dirs in $node_home excluding config dir
included_dirs=$(ls -d * |grep -v config| tr '\n' ' ')

tar -czvf $TAR_FILE_PATH $included_dirs

# delete old snapshots
cd /snapshot/statesync/ && rm $(ls *.tar.gz |sort |head -n -3)

