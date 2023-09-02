# usage: ./run.sh chain_name
# eg., ./run.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./run.sh cosmoshub"
  exit
fi

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

pacman -Syu --noconfirm
pacman -Sy --noconfirm go git base-devel screen

echo "#################################################################################################################"
echo "install gateway"

cd $HOME
gh_access_token="$(curl -s "http://tasks.web_config/config/gh_access_token")"
git clone --single-branch --branch main "https://${gh_access_token}@github.com/notional-labs/notionalapi"
cd notionalapi/gateway
make install

########################################################################################################################
# config file
cat <<EOT > $HOME/gateway.yaml
aggrurl: "http://tasks.napiaggregator:8300/metering"
dbconurl: "http://tasks.napidb_1:4001/"
rpc: "http://tasks.lb_${chain_name}:8000"
wsrpc: "ws://tasks.lb_${chain_name}:8000/websocket"
api: "http://tasks.lb_${chain_name}:8001"
grpc: "tasks.lb_${chain_name}:8003"
eth: "http://tasks.lb_${chain_name}:8004"
ethws: "ws://tasks.lb_${chain_name}:8005"
EOT

########################################################################################################################
# run
cd $HOME
screen -S gateway -dm /root/go/bin/gateway start --conf=/root/gateway.yaml

loop_forever
