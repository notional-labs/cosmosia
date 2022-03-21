# usage: ./quicksynch.sh chain_name
# eg., ./quicksynch.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./quicksynch.sh cosmoshub"
  exit
fi

echo "#################################################################################################################"
echo "# prepare"
pacman -Syy --noconfirm go git base-devel wget jq

# read config from /data/config.ini
eval "$(curl -Ls https://raw.githubusercontent.com/baabeetaa/cosmosia/main/data/config.ini |sed 's/ *= */=/g')"

# debug config params
echo "############################################################################################################"
echo "read config:"
echo "proxy_cache_url=$proxy_cache_url"

echo "#################################################################################################################"
echo "read chain info:"
# https://www.medo64.com/2018/12/extracting-single-ini-section-via-bash/

eval "$(curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/data/chain_registry.ini |awk -v TARGET=$chain_name -F ' = ' '
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
echo "snapshot_provider=$snapshot_provider"
echo "start_flags=$start_flags"

if [[ -z $git_repo ]]
then
  echo "Not support chain $chain_name"
  exit
fi


echo "#################################################################################################################"
echo "build from source:"

cd $HOME

if [[ $chain_name == "sentinel" ]]
then
  # sentinel requires custom build
  mkdir -p $HOME/go/src/github.com/sentinel-official
  cd $HOME/go/src/github.com/sentinel-official

  export GOROOT=/usr/lib/go
  export GOPATH=${HOME}/go
  export GOBIN=${GOPATH}/bin
  export PATH=${PATH}:${GOROOT}/bin:${GOBIN}
fi

echo "curren path: $PWD"

# git clone $git_repo $chain_name
# cd $chain_name
git clone $git_repo
repo_name=$(basename $git_repo |cut -d. -f1)
cd $repo_name

git checkout $version
make install


echo "#################################################################################################################"
echo "download snapshot:"

# delete node home
rm -rf $node_home/*

$HOME/go/bin/$daemon_name init test

# backup $node_home/data/priv_validator_state.json as it is not included in snapshot from some providers.
#mv $node_home/data/priv_validator_state.json $node_home/config/

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
  elif [[ $chain_name == "emoney" ]]
  then
    URL=`curl https://quicksync.io/emoney.json|jq -r '.[] |select(.file=="emoney-3-default")|.url'`
  elif [[ $chain_name == "terra" ]]
  then
    URL=`curl https://quicksync.io/terra.json|jq -r '.[] |select(.file=="columbus-5-pruned")|select (.mirror=="Netherlands")|.url'`
  elif [[ $chain_name == "bandchain" ]]
  then
    URL=`curl https://quicksync.io/band.json |jq -r '.[] |select(.file=="laozi-mainnet-pruned")|.url'`
  elif [[ $chain_name == "kava" ]]
  then
    URL=`curl https://quicksync.io/kava.json |jq -r '.[] |select(.file=="kava-9-pruned")|.url'`
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

  URL=`curl -s https://polkachu.com/tendermint_snapshots/$chain_name |grep -m 1 -Eo "https://\S+?\.tar.lz4"`
elif [[ $snapshot_provider == "alexvalidator.com" ]]
then
  cd $node_home/data/

  URL=$(curl -s https://snapshots.alexvalidator.com/$chain_name/ |egrep -o ">.*tar" |tr -d ">")
  URL="https://snapshots.alexvalidator.com/$chain_name/$URL"
elif [[ $snapshot_provider == "cosmosia" ]]
then
  URL=`curl -s http://65.108.121.153/$chain_name.json |jq -r '.snapshot_url'`
elif [[ $snapshot_provider == "staketab.com" ]]
then
  cd $node_home/data/

  URL=$(curl -s https://cosmos-snap.staketab.com/$chain_name/ |egrep -o ">$chain_name.*tar" |tr -d ">" |grep -v "wasm")
  URL="https://cosmos-snap.staketab.com/$chain_name/$URL"

  if [[ $chain_name == "stargaze" ]]
  then
    URL_WASM=$(curl -s https://cosmos-snap.staketab.com/$chain_name/ |egrep -o ">$chain_name.*wasm.*.*tar" | tr -d ">")
    URL_WASM="https://cosmos-snap.staketab.com/$chain_name/$URL_WASM"
  fi
elif [[ $snapshot_provider == "custom" ]]
then
  if [[ $chain_name == "cheqd" ]]
  then
    cd $node_home/data/

    URL=$(curl -Ls "https://cheqd-node-backups.ams3.digitaloceanspaces.com/?list-type=2&delimiter=" |xmllint --format - |egrep -o "<Key>.*tar.gz</Key>" |tail -n1 |sed -e 's/<[^>]*>//g')
    URL="https://cheqd-node-backups.ams3.digitaloceanspaces.com/$URL"
  elif [[ $chain_name == "konstellation" ]]
  then
    cd $node_home/data/

    URL=$(curl -s https://mercury-nodes.net/knstl-snapshot/ |egrep -o ">knstl.*tar.lz4" |tail -1 |tr -d ">")
    URL="https://mercury-nodes.net/knstl-snapshot/$URL"
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
  echo "URL to download snapshot is empty. Pls fix it!"
  exit
fi

echo "extract the snapshot to current path..."
if [[ $URL == *.tar.lz4 ]]
then
  wget --timeout=0 -O - "$proxy_cache_url$URL" |lz4 -dq |tar -xf -
elif [[ $URL == *.tar ]]
then
  wget --timeout=0 -O - "$proxy_cache_url$URL" |tar -xf -
elif [[ $URL == *.tar.gz ]]
then
  wget --timeout=0 -O - "$proxy_cache_url$URL" |tar -xzf -
else
  echo "Not support snapshot file type."
  exit
fi

# download wasm snapshot, for stargaze only atm
if [[ ! -z $URL_WASM ]]
then
  echo "URL_WASM=$URL_WASM"
  mkdir -p $node_home/wasm

  echo "extract the snapshot of wasm..."
  if [[ $URL_WASM == *.tar ]]
  then
    wget --timeout=0 -O - "$proxy_cache_url$URL_WASM" |tar -xvf - -C $node_home/wasm/
  else
    echo "Not support snapshot file type."
    exit
  fi
fi

# restore priv_validator_state.json if it does not exist in the snapshot
#[ ! -f $node_home/data/priv_validator_state.json ] && mv $node_home/config/priv_validator_state.json $node_home/data/


# set minimum gas prices & rpc port
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas_prices\"/" $node_home/config/app.toml
sed -i.bak '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $node_home/config/config.toml

echo "download genesis file..."
if [[ $addrbook_url == *.json.gz ]]
then
  wget -O - $genesis_url |gzip -cd > $node_home/config/genesis.json
elif [[ $addrbook_url == *.tar.gz ]]
then
  wget -O - $genesis_url |tar -xvzf - -O > $node_home/config/genesis.json
elif [[ $addrbook_url == *.json ]]
then
  curl -Ls $proxy_cache_url$genesis_url > $node_home/config/genesis.json
else
  echo "Not support genesis file type"
  exit
fi


echo "download addrbook..."
curl -Ls  $proxy_cache_url$addrbook_url > $node_home/config/addrbook.json


$HOME/go/bin/$daemon_name start $start_flags




