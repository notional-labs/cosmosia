# usage: ./level2pebble_data.sh data_dir
# eg., ./level2pebble_data.sh $HOME/.bcna/data
#
# warning: that this tool relaces the data.
# note: requires to install https://github.com/notional-labs/level2pebble

data_dir="$1"

if [[ -z $data_dir ]]
then
  echo "No data_dir. usage: ./level2pebble_data.sh data_dir"
  exit
fi

rm -rf $data_dir/snapshots/*
mkdir -p $HOME/level2pebble_tmp
rm -rf $HOME/level2pebble_tmp/*

cd $data_dir

dbs=$(ls -d *.db |tr '\n' ' ')

for db in $dbs; do
  echo "converting ${data_dir}/${db} to ${HOME}/level2pebble_tmp/${db}"
  $HOME/go/bin/level2pebble "${data_dir}/${db}" "${HOME}/level2pebble_tmp"
done

rm -rf ${data_dir}/*.db
cp -R ${HOME}/level2pebble_tmp/* ${data_dir}/
rm -rf ${HOME}/level2pebble_tmp