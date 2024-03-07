# This is common file used for rpc and snapshot services

source $HOME/env.sh

echo "#################################################################################################################"
echo "build from source:"

cd $HOME

# 1. build the snapshot base url
SNAPSHOT_BASE_URL="${USE_SNAPSHOT_PROXY_URL}/${chain_name}"

if [[ -z $USE_SNAPSHOT_PROXY_URL ]]; then
  # internal snapshot proxy

  node="$snapshot_storage_node"
  if [[ -z $node ]]; then
    node="$snapshot_node"
  fi

  SNAPSHOT_BASE_URL="http://proxysnapshot.${node}:11111/$chain_name"
fi

echo "SNAPSHOT_BASE_URL=$SNAPSHOT_BASE_URL"

# empty $git_repo means closed source and need downloading the binaries instead of building from source
if [[ -z $git_repo ]]; then
  INSTALL_URL="${SNAPSHOT_BASE_URL}/releases/${version}/install.sh"
  curl -L -o- $INSTALL_URL |bash
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

  if [[ $db_backend == "pebbledb" ]]; then
    if [ $( echo "${chain_name}" |grep -cE "^(cosmoshub|cheqd|terra|terra-archive|assetmantle)$" ) -ne 0 ]; then
      go mod edit -dropreplace github.com/tecbot/gorocksdb
    elif [[ $chain_name == "gravitybridge" ]]; then
      cd module
    elif [ $( echo "${chain_name}" |grep -cE "^(dydx|dydx-testnet|dydx-archive-sub)$" ) -ne 0 ]; then
      cd protocol
    elif [[ $chain_name == "agoric" ]]; then
      cd $HOME/agoric-sdk/golang/cosmos
    elif [[ $chain_name == "wormhole" ]]; then
      cd $HOME/wormhole/wormchain
    fi

    go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@pebble

    if [ $( echo "${chain_name}" |grep -cE "^(cyber|provenance|furya)$" ) -ne 0 ]; then
      go mod tidy -compat=1.17
    else
      go mod tidy
    fi

    go mod edit -replace github.com/cometbft/cometbft-db=github.com/notional-labs/cometbft-db@pebble
    if [ $( echo "${chain_name}" |grep -cE "^(cyber|provenance|furya)$" ) -ne 0 ]; then
      go mod tidy -compat=1.17
    else
      go mod tidy
    fi

    go work use

    if [ $( echo "${chain_name}" |grep -cE "^(emoney)$" ) -ne 0 ]; then
      sed -i 's/db.NewGoLevelDB/sdk.NewLevelDB/g' app.go
      go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/e-money/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./...
    elif [ $( echo "${chain_name}" |grep -cE "^(starname|sifchain)$" ) -ne 0 ]; then
      go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./cmd/$daemon_name
    elif [[ $chain_name == "axelar" ]]; then
      axelard_version=${version##*v}
      go build -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/cosmos/cosmos-sdk/version.Version=$axelard_version" -o /root/go/bin/$daemon_name ./cmd/axelard
    elif [ $( echo "${chain_name}" |grep -cE "^(injective|injective-testnet)$" ) -ne 0 ]; then
      # fix for hard-coded using goleveldb
      sed -i 's/NewGoLevelDB/NewPebbleDB/g' ./cmd/injectived/root.go
      sed -i 's/NewGoLevelDB/NewPebbleDB/g' ./cmd/injectived/start.go
      go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...
    elif [[ $chain_name == "agoric" ]]; then
      # fix agoric

      # install nvm
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
      # to load nvm
      source $HOME/env.sh

      # install node
      nvm install v18.17.1

      # install yarn
      npm install --global yarn

      # build
      cd $HOME/agoric-sdk
      yarn install
      yarn build

      cd $HOME/agoric-sdk/packages/cosmic-swingset && make

      cd $HOME/agoric-sdk/golang/cosmos
      go build -buildmode=exe -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" -o build/agd ./cmd/agd
    #  go build -buildmode=exe -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" -o build/ag-cosmos-helper ./cmd/helper
      go build -buildmode=c-shared -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" -o build/libagcosmosdaemon.so ./cmd/libdaemon/main.go

    #  mkdir -p "/root/go/bin"
    #  ln -sf "/root/agoric-sdk/bin/agd" "/root/go/bin/ag-chain-cosmos"
    #  ln -sf "/root/agoric-sdk/packages/cosmic-swingset/bin/ag-nchainz" "/root/go/bin/"
    #  ln -sf "/root/agoric-sdk/bin/agd" "/root/go/bin/agd"
    elif [ $( echo "${chain_name}" |grep -cE "^(osmosis|osmosis-archive-sub|osmosis-testnet|osmosis-testnet-pruned)$" ) -ne 0 ]; then
      GOWORK=off go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb $opt_forcesync" ./...
    else
      go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...
    fi

    ## copy binary from gvm to $HOME/go/bin/
    #if [ "$use_gvm" = true ]; then
    #  cp /root/.gvm/pkgsets/go1.18.10/global/bin/$daemon_name /root/go/bin/
    #fi
  else
    if [[ $chain_name == "wormhole" ]]; then
      cd $HOME/wormhole/wormchain
      go install ./...
    else
      make install
    fi
  fi
fi

echo "#################################################################################################################"
echo "download snapshot:"

# delete node home
rm -rf $node_home/*

chain_id_arg=""
if [[ $chain_name == "evmos-testnet-archive" ]]; then
  chain_id_arg="--chain-id=evmos_9000-4"
elif [[ $chain_name == "evmos-testnet" ]]; then
  chain_id_arg="--chain-id=evmos_9000-4"
elif [[ $chain_name == "sei-testnet" ]]; then
  chain_id_arg="--chain-id=atlantic-2"
elif [[ $chain_name == "sei" ]]; then
  chain_id_arg="--chain-id=pacific-1"
elif [ $( echo "${chain_name}" |grep -cE "sei-archive-sub" ) -ne 0 ]; then
	chain_id_arg="--chain-id=pacific-1"
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

prunning_block="362880"
if [ $( echo "${chain_name}" |grep -cE "pruned" ) -ne 0 ]; then
  # if pruned node (not default)
  prunning_block="1000"
fi

# restore priv_validator_state.json if it does not exist in the snapshot
[ ! -f $node_home/data/priv_validator_state.json ] && mv $node_home/config/priv_validator_state.json $node_home/data/

sed -i -e "s/^iavl-disable-fastnode *=.*/iavl-disable-fastnode = false/" $node_home/config/app.toml
if [[ $chain_name == "terra" ]]; then
  sed -i -e "s/^iavl-disable-fastnode *=.*/iavl-disable-fastnode = true/" $node_home/config/app.toml
fi

# set minimum gas prices & rpc port...
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas_prices\"/" $node_home/config/app.toml
sed -i '/^\[api]/,/^\[/{s/^enable[[:space:]]*=.*/enable = true/}' $node_home/config/app.toml
sed -i '/^\[grpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:9090"/}' $node_home/config/app.toml

#if [[ $chain_name == "injective" ]]; then
  sed -i '/^\[api]/,/^\[/{s/^address[[:space:]]*=.*/address = "tcp:\/\/0.0.0.0:1317"/}' $node_home/config/app.toml
  sed -i '/^\[evm-rpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:8545"/}' $node_home/config/app.toml
  sed -i '/^\[evm-rpc]/,/^\[/{s/^ws-address[[:space:]]*=.*/ws-address = "0.0.0.0:8546"/}' $node_home/config/app.toml
#fi

#if [[ $chain_name == evmos* ]]; then
  sed -i '/^\[grpc]/,/^\[/{s/^enable[[:space:]]*=.*/enable = true/}' $node_home/config/app.toml
  sed -i '/^\[json-rpc]/,/^\[/{s/^enable[[:space:]]*=.*/enable = true/}' $node_home/config/app.toml
  sed -i '/^\[json-rpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:8545"/}' $node_home/config/app.toml
  sed -i '/^\[json-rpc]/,/^\[/{s/^ws-address[[:space:]]*=.*/ws-address = "0.0.0.0:8546"/}' $node_home/config/app.toml
#fi

sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $node_home/config/app.toml
if [[ $snapshot_prune == "cosmos-pruner" ]]; then
  sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"${prunning_block}\"/" $node_home/config/app.toml
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

# if $git_repo is not empty
if [[ $db_backend == "pebbledb" ]]; then
  sed -i -e "s/^db_backend *=.*/db_backend = \"pebbledb\"/" $node_home/config/config.toml
  sed -i -e "s/^app-db-backend *=.*/app-db-backend = \"pebbledb\"/" $node_home/config/app.toml

  # fix for sei
  sed -i -e "s/^db-backend *=.*/db-backend = \"pebbledb\"/" $node_home/config/config.toml
fi

if [ $( echo "${chain_name}" |grep -cE "pruned" ) -ne 0 ]; then
  # if pruned node (not default)
  sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $node_home/config/config.toml
  sed -i -e "s/^min-retain-blocks *=.*/min-retain-blocks = 1000/" $node_home/config/app.toml
else
  sed -i -e "s/^indexer *=.*/indexer = \"kv\"/" $node_home/config/config.toml
fi

sed -i -e "s/^query_gas_limit *=.*/query_gas_limit = 10000000/" $node_home/config/app.toml
sed -i -e "s/^discard_abci_responses *=.*/discard_abci_responses = false/" $node_home/config/config.toml

echo "download genesis..."
curl -Ls "${SNAPSHOT_BASE_URL}/genesis.json" > $node_home/config/genesis.json

echo "download addrbook..."
curl -Lfso $node_home/config/addrbook.json "${SNAPSHOT_BASE_URL}/addrbook.json"

sed -i -e "s/^adaptive-fee-enabled *=.*/adaptive-fee-enabled = \"true\"/" $node_home/config/app.toml

if [[ $chain_name == osmosis* ]]; then
  sed -i -e "s/^min-gas-price-for-high-gas-tx *=.*/min-gas-price-for-high-gas-tx = \".005\"/" $node_home/config/app.toml
  sed -i -e "s/^arbitrage-min-gas-fee *=.*/arbitrage-min-gas-fee = \".025\"/" $node_home/config/app.toml
fi

# no seeds and persistent_peers for read-only subnode
if [[ $chain_name == *-sub* ]] && [[ $chain_name != *-sub ]]; then
  sed -i -e "s/^seeds *=.*/seeds = \"\"/" $node_home/config/config.toml
  sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"\"/" $node_home/config/config.toml
fi

# fix for injective
[ "$chain_name" == "injective" ] && sed -i '/^\[mempool]/,/^\[/{s/^size[[:space:]]*=.*/size = 200/}' $node_home/config/config.toml

# fix for sei
if [ $( echo "${chain_name}" |grep -cE "^(sei|sei-archive-sub|sei-archive-sub1|sei-archive-sub2|sei-archive-sub3|sei-testnet)$" ) -ne 0 ]; then
  sed -i -e "s/^log-level *=.*/log-level = \"error\"/" $node_home/config/config.toml
fi

