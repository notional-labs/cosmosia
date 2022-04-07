# usage: ./snaphost_run.sh chain_name
# eg., ./quicsnaphost_runksynch.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./snaphost_run.sh cosmoshub"
  exit
fi

cd $HOME

curl -Ls "https://raw.githubusercontent.com/baabeetaa/cosmosia/main/snapshot/snapshot_download.sh" > $HOME/snapshot_download.sh
source ./snapshot_download.sh

echo "#################################################################################################################"
echo "start chain..."
source ./start_chain.sh


EXITCODE=$?
echo "chain stopped with exit code=$EXITCODE"


# loop forever for debugging only
while true; do sleep 5; done