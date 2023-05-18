# This is common file used for rpc and snapshot services

source $HOME/env.sh

echo "#################################################################################################################"
echo "build from source:"

export GOPATH="$HOME/go"
export GOROOT="/usr/lib/go"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOROOT}/bin:${GOBIN}"
export GOROOT_BOOTSTRAP=$GOROOT

mkdir -p $GOBIN

use_gvm=false
# use gvm for cosmoshub for go1.18
if [ $( echo "${chain_name}" | egrep -c "^(cosmoshub|cosmoshub-archive-sub)$" ) -ne 0 ]; then
  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  source /root/.gvm/scripts/gvm
  gvm install go1.18.10
  gvm use go1.18.10 --default
  use_gvm=true
fi

cd $HOME

# 1. build the snapshot base url
node="$snapshot_storage_node"
if [[ -z $node ]]; then
  node="$snapshot_node"
fi
SNAPSHOT_BASE_URL="http://tasks.proxysnapshotinternal_${node}:11111/$chain_name"
echo "SNAPSHOT_BASE_URL=$SNAPSHOT_BASE_URL"

# empty $git_repo means closed source and need downloading the binaries instead of building from source
if [[ -z $git_repo ]]; then
  BINARY_URL="${SNAPSHOT_BASE_URL}/releases/${version}/${daemon_name}"
  wget "${BINARY_URL}" -O "${GOBIN}/${daemon_name}"
  chmod +x "${GOBIN}/${daemon_name}"

  wget -P /usr/lib https://github.com/CosmWasm/wasmvm/raw/v1.1.1/internal/api/libwasmvm.x86_64.so
else
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

  if [ $( echo "${chain_name}" | egrep -c "^(cosmoshub|cheqd|terra|terra-archive|assetmantle)$" ) -ne 0 ]; then
    go mod edit -dropreplace github.com/tecbot/gorocksdb
  elif [[ $chain_name == "gravitybridge" ]]; then
    cd module
  fi

  go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble

  if [ $( echo "${chain_name}" | egrep -c "^(cyber|provenance|akash)$" ) -ne 0 ]; then
    go mod tidy -compat=1.17
  else
    go mod tidy
  fi

  if [ $( echo "${chain_name}" | egrep -c "^(umee|kujira|whitewhale|quicksilver|regen|juno|juno-archive-sub|omniflixhub|cosmoshub|cosmoshub-archive-sub)$" ) -ne 0 ]; then
    go mod edit -replace github.com/cometbft/cometbft-db=github.com/notional-labs/cometbft-db@pebble
    go mod tidy
  fi

  if [ $( echo "${chain_name}" | egrep -c "^(emoney)$" ) -ne 0 ]; then
    sed -i 's/db.NewGoLevelDB/sdk.NewLevelDB/g' app.go
    go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/e-money/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./...
  elif [ $( echo "${chain_name}" | egrep -c "^(starname|sifchain)$" ) -ne 0 ]; then
    go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./cmd/$daemon_name
  elif [[ $chain_name == "axelar" ]]; then
    axelard_version=${version##*v}
    go build -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/cosmos/cosmos-sdk/version.Version=$axelard_version" -o /root/go/bin/$daemon_name ./cmd/axelard
  elif [[ $chain_name == "pylons" ]]; then
    go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./...
  else
    go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...
  fi

  # copy binary from gvm to $HOME/go/bin/
  if [ "$use_gvm" = true ]; then
    cp /root/.gvm/pkgsets/go1.18.10/global/bin/$daemon_name /root/go/bin/
  fi
fi

echo "#################################################################################################################"
echo "download snapshot:"

# delete node home
rm -rf $node_home/*

chain_id_arg=""
if [[ $chain_name == "evmos-testnet-archive" ]]; then
  chain_id_arg="--chain-id=evmos_9000-4"
elif [[ $chain_name == "sei-testnet" ]]; then
  chain_id_arg="--chain-id=atlantic-2"
fi
$HOME/go/bin/$daemon_name init $chain_id_arg test

# backup $node_home/data/priv_validator_state.json as it is not included in snapshot from some providers.
mv $node_home/data/priv_validator_state.json $node_home/config/

# delete the data folder
rm -rf $node_home/data/*

cd $node_home

URL="${SNAPSHOT_BASE_URL}/chain.json"
URL=`curl -Ls $URL |jq -r '.snapshot_url'`
URL="${SNAPSHOT_BASE_URL}/${URL##*/}"
echo "URL=$URL"


if [[ -z $URL ]]; then
  echo "URL to download snapshot is empty. Pls fix it!"
  loop_forever
fi

echo "download and extract the snapshot to current path..."
wget -O - "$URL" |pigz -dc |tar -xf -

# restore priv_validator_state.json if it does not exist in the snapshot
[ ! -f $node_home/data/priv_validator_state.json ] && mv $node_home/config/priv_validator_state.json $node_home/data/

sed -i -e "s/^iavl-disable-fastnode *=.*/iavl-disable-fastnode = false/" $node_home/config/app.toml

# set minimum gas prices & rpc port...
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas_prices\"/" $node_home/config/app.toml
sed -i '/^\[api]/,/^\[/{s/^enable[[:space:]]*=.*/enable = true/}' $node_home/config/app.toml
sed -i '/^\[grpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:9090"/}' $node_home/config/app.toml

if [[ $chain_name == "injective" ]]; then
  sed -i '/^\[api]/,/^\[/{s/^address[[:space:]]*=.*/address = "tcp:\/\/0.0.0.0:1317"/}' $node_home/config/app.toml
  sed -i '/^\[evm-rpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:8545"/}' $node_home/config/app.toml
  sed -i '/^\[evm-rpc]/,/^\[/{s/^ws-address[[:space:]]*=.*/ws-address = "0.0.0.0:8546"/}' $node_home/config/app.toml
fi

if [ $( echo "${chain_name}" | egrep -c "^(evmos|evmos-archive|evmos-testnet-archive)$" ) -ne 0 ]; then
  sed -i '/^\[json-rpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:8545"/}' $node_home/config/app.toml
  sed -i '/^\[json-rpc]/,/^\[/{s/^ws-address[[:space:]]*=.*/ws-address = "0.0.0.0:8546"/}' $node_home/config/app.toml
fi

sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $node_home/config/app.toml
if [[ $snapshot_prune == "cosmos-pruner" ]]; then
  sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"362880\"/" $node_home/config/app.toml
  sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"0\"/" $node_home/config/app.toml
  sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"100\"/" $node_home/config/app.toml
else
   sed -i -e "s/^pruning *=.*/pruning = \"nothing\"/" $node_home/config/app.toml
fi
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = 0/" $node_home/config/app.toml

# https://github.com/notional-labs/cosmosia/issues/24
[ "$chain_name" != "kava" ] && sed -i -e "s/^swagger *=.*/swagger = true/" $node_home/config/app.toml

sed -i '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $node_home/config/config.toml
sed -i -e "s/^max_num_inbound_peers *=.*/max_num_inbound_peers = 200/" $node_home/config/config.toml
sed -i -e "s/^max_num_outbound_peers *=.*/max_num_outbound_peers = 200/" $node_home/config/config.toml
sed -i -e "s/^log_level *=.*/log_level = \"error\"/" $node_home/config/config.toml
###
sed -i -e "s/^db_backend *=.*/db_backend = \"pebbledb\"/" $node_home/config/config.toml
sed -i -e "s/^app-db-backend *=.*/app-db-backend = \"pebbledb\"/" $node_home/config/app.toml

echo "download genesis..."
curl -Ls "${SNAPSHOT_BASE_URL}/genesis.json" > $node_home/config/genesis.json

echo "download addrbook..."
curl -Lfso $node_home/config/addrbook.json "${SNAPSHOT_BASE_URL}/addrbook.json"

# no seeds and persistent_peers for read-only subnode
if [[ $chain_name == *-sub* ]] && [[ $chain_name != *-sub ]]; then
  sed -i -e "s/^seeds *=.*/seeds = \"\"/" $node_home/config/config.toml
  sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"\"/" $node_home/config/config.toml
fi

# fix for sei
if [ $( echo "${chain_name}" | egrep -c "^(sei-testnet)$" ) -ne 0 ]; then
  sed -i -e "s/^db-backend *=.*/db-backend = \"pebbledb\"/" $node_home/config/config.toml
  sed -i -e "s/^log-level *=.*/log-level = \"error\"/" $node_home/config/config.toml
fi