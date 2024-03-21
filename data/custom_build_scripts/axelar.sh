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

axelard_version=${version##*v}
go build -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/cosmos/cosmos-sdk/version.Version=$axelard_version -X github.com/cosmos/cosmos-sdk/version.Name=axelar -X github.com/cosmos/cosmos-sdk/version.AppName=axelard -X github.com/CosmWasm/wasmd/x/wasm/types/MaxWasmSize=3145728 -X github.com/axelarnetwork/axelar-core/x/axelarnet/exported.NativeAsset=uaxl -X github.com/axelarnetwork/axelar-core/app.WasmEnabled=true -X github.com/axelarnetwork/axelar-core/app.IBCWasmHooksEnabled=false -X github.com/axelarnetwork/axelar-core/app.WasmCapabilities="iterator,staking,stargate,cosmwasm_1_3"" -trimpath -o /root/go/bin/$daemon_name ./cmd/axelard