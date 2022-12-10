set +x

version_new="v6.0.1"

########################################################################################################################
# functions

# usage: buid_chain <p_version> <p_isforcesync>
# eg: buid_chain v1.2.3 true
# copy from snapshot_restore.sh
buid_chain () {
  p_version="$1"
  p_isforcesync="$2"

  opt_forcesync=""
  if [[ $p_isforcesync == "true" ]]; then
    opt_forcesync="-X github.com/tendermint/tm-db.ForceSync=1"
  fi

  if [[ $chain_name == "sentinel" ]]; then
    # sentinel requires custom build
    mkdir -p $HOME/go/src/github.com/sentinel-official
    cd $HOME/go/src/github.com/sentinel-official
  fi

  repo_name=$(basename $git_repo |cut -d. -f1)
  cd $repo_name
  git reset --hard
  git fetch --all --tags

  git checkout "$p_version"

  if [ $( echo "${chain_name}" | egrep -c "^(cosmoshub|cheqd|terra|assetmantle)$" ) -ne 0 ]; then
    go mod edit -dropreplace github.com/tecbot/gorocksdb
  elif [[ $chain_name == "gravitybridge" ]]; then
    cd module
  fi

  go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble

  if [ $( echo "${chain_name}" | egrep -c "^(cyber|provenance|akash)$" ) -ne 0 ]; then
    go mod tidy -compat=1.17
  elif [ $( echo "${chain_name}" | egrep -c "^(evmos|evmos-archive|evmos-testnet-archive)$" ) -ne 0 ]; then
    # this is a temporary fix for evmos ethermint jsonrpc Batch request over websocket
    if [[ $version == "v9.1.0" ]]; then
      go mod tidy
      go mod edit -replace github.com/evmos/ethermint=github.com/notional-labs/ethermint@v0.19.3-fix_ws
      go mod tidy
    else
      go mod tidy
    fi
  else
    go mod tidy
  fi

  if [ $( echo "${chain_name}" | egrep -c "^(emoney)$" ) -ne 0 ]; then
    sed -i 's/db.NewGoLevelDB/sdk.NewLevelDB/g' app.go
    go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/e-money/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./...
  elif [ $( echo "${chain_name}" | egrep -c "^(starname|sifchain)$" ) -ne 0 ]; then
    go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb $opt_forcesync" ./cmd/$daemon_name
  elif [[ $chain_name == "axelar" ]]; then
    axelard_version=${version##*v}
    go build -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/cosmos/cosmos-sdk/version.Version=$axelard_version $opt_forcesync" -o /root/go/bin/$daemon_name ./cmd/axelard
  elif [[ $chain_name == "pylons" ]]; then
    go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./...
  else
    go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb $opt_forcesync" ./...
  fi
}



########################################################################################################################
# main

cd $HOME
source $HOME/env.sh

# validating
if [[ -z $chain_name ]]; then
  echo "No chain_name"
  exit
fi

##################
# 1. stop chain & delete /var/log/chain.err.log

echo "step 1"
supervisorctl stop chain
sleep 5;

rm "/var/log/chain.err.log"

##################
# 2. build an run old version with "-X github.com/tendermint/tm-db.ForceSync=1"
echo "step 2"

buid_chain "$version" "true"

systemctl start chain

##################
# 3. watch for "panic: UPGRADE" in /var/log/chain.err.log
echo "step 3"

tail -f /var/log/chain.err.log |sed '/^panic: UPGRADE$/ q'

##################
# 4. stop chain & build and run new version
echo "step 4"

systemctl stop chain

buid_chain "version_new" "false"

systemctl start chain

##################
# 5. check synced
echo "step 5"

catching_up=true
while [[ "$catching_up" != "false" ]]; do
  sleep 60;
  catching_up=$(curl --silent --max-time 3 "http://localhost:26657/status" |jq -r .result.sync_info.catching_up)
  echo "catching_up=$catching_up"
done

##############
echo "synched"