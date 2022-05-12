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
sleep 60

# make sure chain stopped
killall $chain_name
sleep 10

source $HOME/chain_info.sh

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
    "file_size": $FILESIZE
}
EOT


# delete old snapshots
cd /snapshot/ && rm $(ls *.tar.gz |sort |head -n -1)
