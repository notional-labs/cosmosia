cd $HOME

if [[ -z $upgrading ]]; then
  git clone --single-branch --branch $version $git_repo
  repo_name=$(basename $git_repo |cut -d. -f1)
  # cd $repo_name
  cd $HOME/agoric-sdk/golang/cosmos

  go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@pebble
  go mod tidy
  go mod edit -replace github.com/cometbft/cometbft-db=github.com/notional-labs/cometbft-db@pebble
  go mod tidy

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

  mkdir -p "/root/go/bin"
  ln -sf "/root/agoric-sdk/bin/agd" "/root/go/bin/ag-chain-cosmos"
  ln -sf "/root/agoric-sdk/packages/cosmic-swingset/bin/ag-nchainz" "/root/go/bin/"
  ln -sf "/root/agoric-sdk/bin/agd" "/root/go/bin/agd"
else
  repo_name=$(basename $git_repo |cut -d. -f1)
  cd $repo_name
  git reset --hard
  git fetch --all --tags
  git checkout "$p_version"


  cd $HOME/agoric-sdk/golang/cosmos
  go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@pebble
  go mod tidy
  go mod edit -replace github.com/cometbft/cometbft-db=github.com/notional-labs/cometbft-db@pebble
  go mod tidy

  cd $HOME/agoric-sdk
  yarn install
  yarn build

  cd $HOME/agoric-sdk/packages/cosmic-swingset && make

  cd $HOME/agoric-sdk/golang/cosmos
  go build -buildmode=exe -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb $opt_forcesync" -o build/agd ./cmd/agd
  # go build -buildmode=exe -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb $opt_forcesync" -o build/ag-cosmos-helper ./cmd/helper
  go build -buildmode=c-shared -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb $opt_forcesync" -o build/libagcosmosdaemon.so ./cmd/libdaemon/main.go
fi
