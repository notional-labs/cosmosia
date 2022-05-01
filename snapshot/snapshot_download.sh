
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

if [[ -z $git_repo ]]; then
  echo "Not support chain $chain_name"
  exit
fi

# write chain info to bash file, so that cronjob could know
cat <<EOT >> $HOME/chain_info.sh
chain_name="$chain_name"
git_repo="$git_repo"
version="$version"
genesis_url="$genesis_url"
daemon_name="$daemon_name"
node_home="$node_home"
minimum_gas_prices="$minimum_gas_prices"
addrbook_url="$addrbook_url"
snapshot_provider="$snapshot_provider"
start_flags="$start_flags"
pacman_pkgs="$pacman_pkgs"
snapshot_time="$snapshot_time"
EOT


pacman -Syu --noconfirm go git base-devel wget jq nginx spawn-fcgi fcgiwrap $pacman_pkgs

echo "#################################################################################################################"
echo "build from source:"

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
make install

echo "#################################################################################################################"
echo "download snapshot:"

rm -rf $node_home/*
$HOME/go/bin/$daemon_name init test

# backup $node_home/data/priv_validator_state.json as it is not included in snapshot from some providers.
mv $node_home/data/priv_validator_state.json $node_home/config/
rm -rf $node_home/data/*

cd $node_home

# always try from our local snapshot first, if failure => use external providers
BASE_URL="http://localhost/"
URL="http://localhost/chain.json"
status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 3 $URL)
if [[ $status_code == "200" ]]; then
  URL=`curl -s $URL |jq -r '.snapshot_url'`
  URL="${BASE_URL}${URL##*/}"
else
  echo "Not found local snapshot for $chain_name, continue to try other providers..."

  if [[ $snapshot_provider == "quicksync.io" ]]; then
    # using quicksync.io https://quicksync.io/networks/cosmos.html

    if [[ $chain_name == "cosmoshub" ]]; then
      URL=`curl -s https://quicksync.io/cosmos.json|jq -r '.[] |select(.file=="cosmoshub-4-pruned")|.url'`
    elif [[ $chain_name == "osmosis" ]]; then
      URL=`curl -s https://quicksync.io/osmosis.json|jq -r '.[] |select(.file=="osmosis-1-pruned")|select (.mirror=="Netherlands")|.url'`
    elif [[ $chain_name == "emoney" ]]; then
      URL=`curl https://quicksync.io/emoney.json|jq -r '.[] |select(.file=="emoney-3-default")|.url'`
    elif [[ $chain_name == "terra" ]]; then
      URL=`curl https://quicksync.io/terra.json|jq -r '.[] |select(.file=="columbus-5-pruned")|select (.mirror=="Netherlands")|.url'`
    elif [[ $chain_name == "bandchain" ]]; then
      URL=`curl https://quicksync.io/band.json |jq -r '.[] |select(.file=="laozi-mainnet-pruned")|.url'`
    elif [[ $chain_name == "kava" ]]; then
      URL=`curl https://quicksync.io/kava.json |jq -r '.[] |select(.file=="kava-9-pruned")|.url'`
    else
      echo "Not support $chain_name with snapshot_provider $snapshot_provider"
      exit
    fi
  elif [[ $snapshot_provider == "polkachu.com" ]]; then
    URL=`curl -s https://polkachu.com/tendermint_snapshots/$chain_name |grep -m 1 -Eo "https://\S+?\.tar.lz4"`
  elif [[ $snapshot_provider == "alexvalidator.com" ]]; then
    cd $node_home/data/

    URL=$(curl -s https://snapshots.alexvalidator.com/$chain_name/ |egrep -o ">.*tar" |tr -d ">")
    URL="https://snapshots.alexvalidator.com/$chain_name/$URL"
  elif [[ $snapshot_provider == "cosmosia" ]]; then
    URL=`curl -s http://65.108.121.153/$chain_name.json |jq -r '.snapshot_url'`
  elif [[ $snapshot_provider == "staketab.com" ]]; then
    cd $node_home/data/

    URL=$(curl -s https://cosmos-snap.staketab.com/$chain_name/ |egrep -o ">$chain_name.*tar" |tr -d ">" |grep -v "wasm")
    URL="https://cosmos-snap.staketab.com/$chain_name/$URL"

    if [[ $chain_name == "stargaze" ]]; then
      URL_WASM=$(curl -s https://cosmos-snap.staketab.com/$chain_name/ |egrep -o ">$chain_name.*wasm.*.*tar" | tr -d ">")
      URL_WASM="https://cosmos-snap.staketab.com/$chain_name/$URL_WASM"
    fi
  elif [[ $snapshot_provider == "stake2.me" ]]; then
    cd $node_home/data/

    URL=$(curl -s "https://snapshots.stake2.me/$chain_name/" |egrep -o ">$chain_name.*tar" |tr -d ">" |grep -v "wasm" |tail -1)
    URL="https://snapshots.stake2.me/$chain_name/$URL"
    if [[ $chain_name == "stargaze" ]]; then
      URL_WASM=$(curl -s "https://snapshots.stake2.me/$chain_name/" |egrep -o ">$chain_name.*wasm.*.*tar" | tr -d ">" |tail -1)
      URL_WASM="https://snapshots.stake2.me/$chain_name/$URL_WASM"
    fi
  elif [[ $snapshot_provider == "custom" ]]; then
    if [[ $chain_name == "cheqd" ]]; then
      cd $node_home/data/

      URL=$(curl -Ls "https://cheqd-node-backups.ams3.digitaloceanspaces.com/?list-type=2&delimiter=" |xmllint --format - |egrep -o "<Key>.*tar.gz</Key>" |tail -n1 |sed -e 's/<[^>]*>//g')
      URL="https://cheqd-node-backups.ams3.digitaloceanspaces.com/$URL"
    elif [[ $chain_name == "konstellation" ]]; then
      cd $node_home/data/

      URL=$(curl -s https://mercury-nodes.net/knstl-snapshot/ |egrep -o ">knstl.*tar.lz4" |tail -1 |tr -d ">")
      URL="https://mercury-nodes.net/knstl-snapshot/$URL"
    elif [[ $chain_name == "provenance" ]]; then
      URL=$(curl -s "https://storage.googleapis.com/storage/v1/b/provenance-mainnet-backups/o/latest-post-green.tar.gz" |jq -r '.mediaLink')
    else
      echo "Not support $chain_name with snapshot_provider $snapshot_provider"
      exit
    fi
  else
    echo "Not support snapshot_provider $snapshot_provider"
    exit
  fi
fi


echo "URL=$URL"

if [[ -z $URL ]]; then
  echo "URL to download snapshot is empty. Pls fix it!"
  exit
fi

echo "download and extract the snapshot to current path..."

# remove query params from url so we can figure out the file type
# latest-data-indexed.tar.gz?generation=1647902753676847&alt=media => latest-data-indexed.tar.gz
url_stripped=${URL%%\?*}
echo "url_stripped=$url_stripped"

if [[ $url_stripped == *.tar.lz4 ]]; then
  wget -O - "$URL" |lz4 -dq |tar -xf -
elif [[ $url_stripped == *.tar ]]; then
  wget -O - "$URL" |tar -xf -
elif [[ $url_stripped == *.tar.gz ]]; then
  wget -O - "$URL" |tar -xzf -
else
  echo "Not support snapshot file type."
  exit
fi

# download wasm snapshot, for stargaze only atm
if [[ ! -z $URL_WASM ]]; then
  echo "URL_WASM=$URL_WASM"
  mkdir -p $node_home/wasm

  echo "extract the snapshot of wasm..."
  if [[ $URL_WASM == *.tar ]]; then
    wget -O - "$URL_WASM" |tar -xvf - -C $node_home/wasm/
  else
    echo "Not support snapshot file type."
    exit
  fi
fi

# restore priv_validator_state.json if it does not exist in the snapshot
[ ! -f $node_home/data/priv_validator_state.json ] && mv $node_home/config/priv_validator_state.json $node_home/data/

# set minimum gas prices & rpc port...
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas_prices\"/" $node_home/config/app.toml
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $node_home/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"362880\"/" $node_home/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"0\"/" $node_home/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"100\"/" $node_home/config/app.toml
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = 0/" $node_home/config/app.toml
sed -i '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $node_home/config/config.toml
sed -i -e "s/^max_num_inbound_peers *=.*/max_num_inbound_peers = 1000/" $node_home/config/config.toml
sed -i -e "s/^max_num_outbound_peers *=.*/max_num_outbound_peers = 200/" $node_home/config/config.toml
sed -i -e "s/^log_level *=.*/log_level = \"error\"/" $node_home/config/config.toml

echo "download genesis file..."
if [[ $genesis_url == *.json.gz ]]; then
  wget -O - "$genesis_url" |gzip -cd > $node_home/config/genesis.json
elif [[ $genesis_url == *.tar.gz ]]; then
  wget -O - "$genesis_url" |tar -xvzf - -O > $node_home/config/genesis.json
elif [[ $genesis_url == *.json ]]; then
  curl -Ls "$genesis_url" > $node_home/config/genesis.json
else
  echo "Not support genesis file type"
  exit
fi


echo "download addrbook..."
# we try notional.ventures first, failed => other providers
URL="https://snapshot.notional.ventures/$chain_name/addrbook.json"
status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 3 $URL)
if [[ $status_code != "200" ]]; then
  echo "Not found snapshot for $chain_name, continue to try other providers..."
  URL=$addrbook_url
fi

curl -Ls  "$URL" > $node_home/config/addrbook.json

echo "#################################################################################################################"
echo "start chain script"
echo "$HOME/go/bin/$daemon_name start $start_flags" > $HOME/start_chain.sh