# usage: ./create_snapshot.sh chain_name
# eg., ./snapshost_run.sh cosmoshub

# Note: requires pigz

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./create_snapshot.sh cosmoshub"
  exit
fi


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

echo "node_home=$node_home"

# delete old snapshots before creating new snapshot to save disk space
cd /snapshot/ && rm $(ls *.tar.gz |sort |head -n -2)

cd $node_home

rm -rf $node_home/data/snapshots/*

TAR_FILENAME="data_$(date +%Y%m%d_%T |sed 's/://g').tar.gz"
TAR_FILE_PATH="/snapshot/$TAR_FILENAME"

# snapshot file includes ALL dirs in $node_home excluding config dir
included_dirs=$(ls -d * |grep -v config| tr '\n' ' ')
tar -cvf - $included_dirs |pigz --best -p8 > $TAR_FILE_PATH

FILESIZE=$(stat -c%s "$TAR_FILE_PATH")

cat <<EOT > /snapshot/chain.json
{
    "snapshot_url": "http://${snapshot_node}.notional.ventures:11111/$chain_name/$TAR_FILENAME",
    "file_size": $FILESIZE,
    "data_version": 0
}
EOT
