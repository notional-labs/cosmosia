# usage: ./create_snapshot.sh chain_name
# eg., ./snapshost_run.sh cosmoshub

# Note: requires pigz

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./create_snapshot.sh cosmoshub"
  exit
fi

get_docker_snapshot_config () {
  str_snapshot_cfg="$(curl -s "http://tasks.web_config/config/cosmosia.snapshot.${chain_name}" |sed 's/ = /=/g')"
  echo $str_snapshot_cfg
}

source $HOME/env.sh

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

str_snapshot_cfg=$(get_docker_snapshot_config)
echo "str_snapshot_cfg=${str_snapshot_cfg}"
eval "${str_snapshot_cfg}"

echo "node_home=$node_home"
cd $node_home

TAR_FILENAME="data_$(date +%Y%m%d_%T |sed 's/://g').tar.gz"

# snapshot file includes ALL dirs in $node_home excluding config dir
included_dirs=$(ls -d * |grep -v config| tr '\n' ' ')

tar -cvf - $included_dirs |pigz --best -p8 |ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${snapshot_storage_node_ip} "cat > /mnt/data/snapshots/${chain_name}/${TAR_FILENAME}"

FILESIZE=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${snapshot_storage_node_ip} stat -c%s "/mnt/data/snapshots/${chain_name}/${TAR_FILENAME}")
cat <<EOT > $HOME/chain.json
{
    "snapshot_url": "http://${snapshot_storage_node_ip}:11111/$chain_name/$TAR_FILENAME",
    "file_size": $FILESIZE,
    "data_version": $data_version
}
EOT

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -prq "$HOME/chain.json" "root@${snapshot_storage_node_ip}:/mnt/data/snapshots/${chain_name}/"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -prq "${node_home}/config/addrbook.json" "root@${snapshot_storage_node_ip}:/mnt/data/snapshots/${chain_name}/"
