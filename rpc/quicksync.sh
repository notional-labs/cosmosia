# usage: ./quicksynch.sh chain_name
# eg., ./quicksynch.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./quicksynch.sh cosmoshub"
  exit
fi

########################################################################################################################
# prepare
pacman -Syy --noconfirm go git base-devel wget jq

# read config from /data/config.ini
eval "$(curl -Ls https://raw.githubusercontent.com/baabeetaa/cosmosia/main/data/config.ini |sed 's/ *= */=/g')"

# debug config params
echo "############################################################################################################"
echo "read config:"
echo "proxy_cache_url=$proxy_cache_url"

########################################################################################################################
# read chain info
# https://www.medo64.com/2018/12/extracting-single-ini-section-via-bash/

eval "$(curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/data/chain_registry.ini |awk -v TARGET=$chain_name -F ' *= *' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ')"

# debug chain info
echo "############################################################################################################"
echo "read chain info:"
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
  exit
fi


########################################################################################################################
# build from source first
echo "build from source:"

cd $HOME
git clone $git_repo

# find folder name. eg:
# https://github.com/cosmos/gaia => gaia
# https://github.com/cosmos/gaia.git => gaia
repo_name=$(basename $git_repo | cut -d. -f1)

cd $repo_name
git checkout $version
make install


########################################################################################################################
echo "download snapshot:"

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
    URL=`curl -s https://quicksync.io/cosmos.json|jq -r '.[] |select(.file=="cosmoshub-4-pruned")|.url'`
  elif [[ $chain_name == "osmosis" ]]
  then
    URL=`curl -s https://quicksync.io/osmosis.json|jq -r '.[] |select(.file=="osmosis-1-pruned")|select (.mirror=="Netherlands")|.url'`
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
    URL=`curl -s https://polkachu.com/tendermint_snapshots/juno | grep -m 1 -Eo "https://\S+?\.tar.lz4"`
  else
    echo "Not support $chain_name with snapshot_provider $snapshot_provider"
    exit
  fi
elif [[ $snapshot_provider == "cosmosia" ]]
then
  if [[ $chain_name == "starname" ]]
  then
    URL=`curl http://65.108.121.153/ | grep -m 1 -Eo "https://\S+?\.tar.lz4"`
  else
    echo "Not support $chain_name with snapshot_provider $snapshot_provider"
    exit
  fi
else
  echo "Not support snapshot_provider $snapshot_provider"
  exit
fi

echo "URL=$URL"

if [[ -z $URL ]]
then
  echo "URL is empty. Pls fix it!"
  exit
fi

wget --timeout=0 -O - "$proxy_cache_url$URL" | lz4 -d | tar -xvf -

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
  curl -Ls $proxy_cache_url$genesis_url > $node_home/config/genesis.json
else
  echo "Not support genesis file type"
  exit
fi


# download addrbook
curl -Ls  $proxy_cache_url$addrbook_url > $node_home/config/addrbook.json


$HOME/go/bin/$daemon_name start --x-crisis-skip-assert-invariants




