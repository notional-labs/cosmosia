# usage: ./quicksynch.sh chain_name
# eg., ./quicksynch.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./quicksynch.sh cosmoshub"
fi

########################################################################################################################
# read chain info
# https://www.medo64.com/2018/12/extracting-single-ini-section-via-bash/
source <(awk -v TARGET=$chain_name -F ' *= *' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ' /cosmosia/chain_registry.ini)

# debug chain info
echo "############################################################################################################"
echo "git_repo=$git_repo"
echo "version=$version"
echo "genesis_url=$genesis_url"
echo "daemon_name=$daemon_name"
echo "node_home=$node_home"
echo "minimum_gas_prices=$minimum_gas_prices"
echo "addrbook_url=$addrbook_url"
echo "snapshot_provider=$snapshot_provider"

if [[ -z $git_repo ]]
then
  echo "Not support chain $chain_name"
fi


########################################################################################################################
# build from source first
pacman -Syy --noconfirm go git base-devel wget jq

cd $HOME
git clone $git_repo

# find folder name. eg:
# https://github.com/cosmos/gaia => gaia
# https://github.com/cosmos/gaia.git => gaia
repo_name=$(basename $git_repo | cut -d. -f1)

cd $repo_name
git checkout $version
go install ./...


########################################################################################################################
# delete node home
rm -rf $node_home/*

$HOME/go/bin/$daemon_name init test

# delete the data folder
rm -rf $node_home/data/*


cd $node_home

if [[ $snapshot_provider == "quicksync.io" ]]
then
  # using quicksync.io https://quicksync.io/networks/cosmos.html

  if [[ $chain_name == "cosmoshub" ]]
  then
    URL=`curl https://quicksync.io/cosmos.json|jq -r '.[] |select(.file=="$chain_name-4-pruned")|.url'`
  elif [[ $chain_name == "osmosis" ]]
  then
    URL=`curl https://quicksync.io/osmosis.json|jq -r '.[] |select(.file=="$chain_name-1-pruned")|.url'`
  else
    echo "Not support $chain_name with snapshot_provider $snapshot_provider"
    exit
  fi
elif [[ $snapshot_provider == "polkachu.com" ]]
then
  # using https://polkachu.com/tendermint_snapshots/juno

  # setting for polkachu snapshot
  sed -i.bak -e "s/^indexer *=.*/indexer = \"null\"/" $node_home/config/config.toml
  sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" $node_home/config/app.toml
  sed -i.bak -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $node_home/config/app.toml
  sed -i.bak -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"0\"/" $node_home/config/app.toml
  sed -i.bak -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $node_home/config/app.toml


  if [[ $chain_name == "juno" ]]
  then
    URL=`curl https://polkachu.com/tendermint_snapshots/juno | grep -m 1 -Eo "https://\S+?\.tar.lz4"`
  else
    echo "Not support $chain_name with snapshot_provider $snapshot_provider"
    exit
  fi
else
  echo "Not support snapshot_provider $snapshot_provider"
  exit
fi

echo "URL=$URL"
wget --timeout=0 -O - "http://proxy_cache:8080/$URL" | lz4 -d | tar -xvf -

# set minimum gas prices
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas_prices\"/" $node_home/config/app.toml

# set rpc port
sed -i.bak '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $node_home/config/config.toml

# download genesis file
if [[ $addrbook_url == *.json.gz ]]
then
  wget -O - $genesis_url | gzip -cd > $node_home/config/genesis.json
elif [[ $addrbook_url == *.json ]]
then
  curl -s http://proxy_cache:8080/$genesis_url > $node_home/config/genesis.json
else
  echo "Not support genesis file type"
  exit
fi


# download addrbook
curl -s  http://proxy_cache:8080/$addrbook_url > $node_home/config/addrbook.json


$HOME/go/bin/$daemon_name start --x-crisis-skip-assert-invariants




