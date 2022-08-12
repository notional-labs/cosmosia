# usage: ./sss_run.sh chain_name
# eg., ./sss_run.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./sss_run.sh cosmoshub"
  exit
fi

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/statesync/create_statesync_snapshot.sh" > $HOME/create_statesync_snapshot.sh

echo "#################################################################################################################"
echo "read chain info:"
# https://www.medo64.com/2018/12/extracting-single-ini-section-via-bash/

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

echo "git_repo=$git_repo"
echo "version=$version"
echo "genesis_url=$genesis_url"
echo "daemon_name=$daemon_name"
echo "node_home=$node_home"
echo "minimum_gas_prices=$minimum_gas_prices"
echo "addrbook_url=$addrbook_url"
echo "start_flags=$start_flags"
echo "pacman_pkgs=$pacman_pkgs"

if [[ -z $git_repo ]]; then
  echo "Not support chain $chain_name"
  loop_forever
fi

pacman -Syu --noconfirm
pacman -Sy --noconfirm go git base-devel wget jq $pacman_pkgs

echo "#################################################################################################################"
echo "build chain from source:"

export GOPATH="$HOME/go"
export GOROOT="/usr/lib/go"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOROOT}/bin:${GOBIN}"

cd $HOME

if [[ $chain_name == "sentinel" ]]; then
  # sentinel requires custom build
  mkdir -p $HOME/go/src/github.com/sentinel-official
  cd $HOME/go/src/github.com/sentinel-official
fi

echo "curren path: $PWD"

# git clone $git_repo $chain_name
# cd $chain_name
git clone --single-branch --branch $version $git_repo
repo_name=$(basename $git_repo |cut -d. -f1)
cd $repo_name

# git checkout $version
[[ $chain_name == "gravitybridge" ]] && cd module

# fix axelar `make install` doesnt work
if [[ $chain_name == "axelar" ]]; then
  make build && mkdir -p $HOME/go/bin && cp ./bin/axelard $HOME/go/bin/
else
  make install
fi


echo "#################################################################################################################"
echo "statesync:"


RPC_URL="http://tasks.sss_${chain_name}:26657"
LATEST_HEIGHT=$(curl -s "$RPC_URL/block" | jq -r .result.block.header.height)
BLOCK_HEIGHT=$(($LATEST_HEIGHT-2000))
TRUST_HASH=$(curl -s "$RPC_URL/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
REMOTE_NODE_ID=$(curl -s "$RPC_URL/status" | jq -r .result.node_info.id)
CHAIN_ID=$(curl -s "$RPC_URL/status" | jq -r .result.node_info.network)

echo "BLOCK_HEIGHT=$BLOCK_HEIGHT"
echo "TRUST_HASH=$TRUST_HASH"
echo "REMOTE_NODE_ID=$REMOTE_NODE_ID"
echo "CHAIN_ID=$CHAIN_ID"

# delete node home
rm -rf $node_home/*
$HOME/go/bin/$daemon_name init test --chain-id=$CHAIN_ID

cd $node_home

# set minimum gas prices & rpc port...
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas_prices\"/" $node_home/config/app.toml
sed -i '/^\[api]/,/^\[/{s/^enable[[:space:]]*=.*/enable = true/}' $node_home/config/app.toml
sed -i '/^\[grpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:9090"/}' $node_home/config/app.toml
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $node_home/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"362880\"/" $node_home/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"0\"/" $node_home/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"100\"/" $node_home/config/app.toml
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = 2000/" $node_home/config/app.toml
sed -i -e "s/^snapshot-keep-recent *=.*/snapshot-keep-recent = 10/" $node_home/config/app.toml
sed -i '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $node_home/config/config.toml
sed -i -e "s/^max_num_inbound_peers *=.*/max_num_inbound_peers = 1000/" $node_home/config/config.toml
sed -i -e "s/^max_num_outbound_peers *=.*/max_num_outbound_peers = 200/" $node_home/config/config.toml
sed -i -e "s/^log_level *=.*/log_level = \"info\"/" $node_home/config/config.toml
######
sed -i -e "s/^chunk_fetchers *=.*/chunk_fetchers = 1/" $node_home/config/config.toml
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = 1000/" $node_home/config/app.toml
sed -i '/^\[statesync]/,/^\[/{s/^enable[[:space:]]*=.*/enable = true/}' $node_home/config/config.toml
sed -i -e "s/^addr_book_strict *=.*/addr_book_strict = false/" $node_home/config/config.toml
sed -i -e "s|^rpc_servers *=.*|rpc_servers = \"$RPC_URL,$RPC_URL\"|" $node_home/config/config.toml
sed -i -e "s/^trust_height *=.*/trust_height = $BLOCK_HEIGHT/" $node_home/config/config.toml
sed -i -e "s/^trust_hash *=.*/trust_hash = \"$TRUST_HASH\"/" $node_home/config/config.toml
sed -i -e "s/^send_rate *=.*/send_rate = 51200000/" $node_home/config/config.toml
sed -i -e "s/^recv_rate *=.*/recv_rate = 51200000/" $node_home/config/config.toml
sed -i -e "s/^seeds *=.*/seeds = \"\"/" $node_home/config/config.toml
sed -i -e "s/^pex *=.*/pex = false/" $node_home/config/config.toml

sleep 5

# fix panic: failed to initialize database: IO error: No such file or directory: While mkdir if missing: /root/.evmosd/data/snapshots/metadata.db: No such file or directory
mkdir -p $node_home/data/snapshots

echo "start chain..."
$HOME/go/bin/$daemon_name start --p2p.persistent_peers=${REMOTE_NODE_ID}@tasks.sss_${chain_name}:26656

loop_forever
