# usage: ./upgrading.sh <new_version>
# eg., ./upgrading.sh v6.0.1

########################################################################################################################
# make sure single instance running
PIDFILE="$HOME/upgrading.sh.lock"
function cleanup() {
  rm -f $PIDFILE
}

if [ -f $PIDFILE ]; then
   pid=$(cat $PIDFILE)
   if kill -0 $pid 2>/dev/null; then
      echo "Script is already running"
      exit 1
   fi
fi

echo $$ > $PIDFILE
trap cleanup EXIT

########################################################################################################################
version_new="$1"

if [[ -z $version_new ]]; then
  echo "No version_new"
  exit
fi

echo "version_new=$version_new"

cd $HOME
source $HOME/env.sh

if [[ -z $chain_name ]]; then
  echo "No chain_name"
  exit
fi

if [[ $db_backend == "goleveldb" ]]; then
  echo "use this script for pebbledb only. Exit!"
  exit
fi

#use_gvm=false
## use gvm for cosmoshub for go1.18
#if [ $( echo "${chain_name}" |grep -cE "^(cosmoshub|cosmoshub-archive-sub)$" ) -ne 0 ]; then
#  source /root/.gvm/scripts/gvm
#  use_gvm=true
#fi

# indicate upgrading script is running
upgrading="true"

########################################################################################################################
# functions

# usage: buid_chain <p_version> <p_isforcesync>
# eg: buid_chain v1.2.3 true
# copy from snapshot_restore.sh
buid_chain () {
  p_version="$1"
  p_isforcesync="$2"
  if [[ -z $build_script ]]; then
    opt_forcesync=""
    if [[ $p_isforcesync == "true" ]]; then
      opt_forcesync="-X github.com/tendermint/tm-db.ForceSync=1 -X github.com/cometbft/cometbft-db.ForceSync=1"
    fi

    repo_name=$(basename $git_repo |cut -d. -f1)
    cd $repo_name
    git reset --hard
    git fetch --all --tags

    git checkout "$p_version"

    if [ $( echo "${chain_name}" |grep -cE "^(cosmoshub|cheqd|terra|assetmantle)$" ) -ne 0 ]; then
      go mod edit -dropreplace github.com/tecbot/gorocksdb
    elif [[ $chain_name == "gravitybridge" ]]; then
      cd module
    elif [ $( echo "${chain_name}" |grep -cE "^(dydx|dydx-testnet|dydx-archive-sub)$" ) -ne 0 ]; then
      cd protocol
    elif [[ $chain_name == "agoric" ]]; then
      cd $HOME/agoric-sdk/golang/cosmos
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
      go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb $opt_forcesync" ./cmd/$daemon_name
    else
      go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb $opt_forcesync" ./...
    fi

    #  # copy binary from gvm to $HOME/go/bin/
    #  if [ "$use_gvm" = true ]; then
    #    cp /root/.gvm/pkgsets/go1.18.10/global/bin/$daemon_name /root/go/bin/
    #  fi
  else
    source <(curl -Ls -o- "$build_script")
  fi
}

########################################################################################################################
# main
cd $HOME

# validating
if [[ -z $chain_name ]]; then
  echo "No chain_name"
  exit
fi

##################
# 1. stop chain & delete /var/log/chain.err.log
echo "step 1: clean old logs"
supervisorctl stop chain
sleep 5;

echo "" > /var/log/chain.err.log

##################
# 2. build an run old version with "-X github.com/tendermint/tm-db.ForceSync=1"
echo "step 2: build old binary"
buid_chain "$version" "true"
sleep 5;
supervisorctl start chain &

##################
# 3. watch for "panic: UPGRADE" OR "6:21PM ERR UPGRADE" in /var/log/chain.err.log
echo "step 3: wait until see UPGRADE from logs"
tail -f /var/log/chain.err.log |sed '/UPGRADE\(.*\)NEEDED/ q'
wait
sleep 5;
##################
# 4. stop chain & build and run new version
echo "step 4: build new binary"
supervisorctl stop chain
sleep 5;
buid_chain "$version_new" "false"
sleep 5;
supervisorctl start chain
sleep 5;
##################
# 5. check synced
echo "step 5: synchronization checking"

catching_up="true"
while [[ "$catching_up" != "false" ]]; do
  sleep 60;
  catching_up=$(curl --silent --max-time 3 "http://localhost:26657/status" |jq -r .result.sync_info.catching_up)
  echo "catching_up=$catching_up"
done

##############
echo "synched"
