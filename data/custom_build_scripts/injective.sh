cd $HOME

if [[ -z $upgrading ]]; then
  git clone --single-branch --branch $version $git_repo
  repo_name=$(basename $git_repo |cut -d. -f1)
  cd $repo_name
else
  repo_name=$(basename $git_repo |cut -d. -f1)
  cd $repo_name
  git reset --hard
  git fetch --all --tags
  git checkout "$p_version"
fi

go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@pebble
go mod tidy
go mod edit -replace github.com/cometbft/cometbft-db=github.com/notional-labs/cometbft-db@pebble
go mod tidy

# fix for hard-coded using goleveldb
sed -i 's/NewGoLevelDB/NewPebbleDB/g' ./cmd/injectived/root.go
sed -i 's/NewGoLevelDB/NewPebbleDB/g' ./cmd/injectived/start.go
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...