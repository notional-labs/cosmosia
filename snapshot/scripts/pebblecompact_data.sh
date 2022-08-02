# usage: ./pebblecompact_data.sh data_dir
# eg., ./pebblecompact_data.sh $HOME/.bcna/data
#
# warning: that this tool relaces the data.
# note: requires to install https://github.com/notional-labs/pebblecompact

data_dir="$1"

if [[ -z $data_dir ]]
then
  echo "No data_dir. usage: ./pebblecompact_data.sh data_dir"
  exit
fi

cd $data_dir

dbs=$(ls -d *.db |tr '\n' ' ')

for db in $dbs; do
  echo "compacting ${data_dir}/${db}"
  $HOME/go/bin/pebblecompact "${data_dir}/${db}"
done