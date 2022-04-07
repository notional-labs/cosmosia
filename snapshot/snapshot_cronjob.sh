echo "#################################################################################################################"
echo "snapshot_cronjob..."

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

supervisorctl stop chain

sleep 10


source $HOME/chain_info.sh

cd $node_home

TAR_FILE="$HOME/${chain_name}_$(date +%Y%m%d_%T |sed 's/://g').tar.gz"

tar -czvf $TAR_FILE ./data