# usage: ./quicksynch.sh chain_name
# eg., ./quicksynch.sh cosmoshub

chain_name="$1"
rpc_service_name="$2"

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./quicksynch.sh cosmoshub"
  exit
fi

[[ -z $rpc_service_name ]] && rpc_service_name="$chain_name"

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

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

echo "git_repo=$git_repo"
echo "version=$version"
echo "genesis_url=$genesis_url"
echo "daemon_name=$daemon_name"
echo "node_home=$node_home"
echo "minimum_gas_prices=$minimum_gas_prices"
echo "addrbook_url=$addrbook_url"
echo "start_flags=$start_flags"
echo "json_rpc=$json_rpc"

if [[ -z $git_repo ]]; then
  echo "Not support chain $chain_name"
  loop_forever
fi

pacman -Syu --noconfirm
pacman -Sy --noconfirm go git base-devel wget jq python python-pip cronie nginx spawn-fcgi fcgiwrap dnsutils inetutils

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

if [ $( echo "${chain_name}" | egrep -c "^(cosmoshub|cheqd|terra)$" ) -ne 0 ]; then
  go mod edit -dropreplace github.com/tecbot/gorocksdb
elif [[ $chain_name == "comdex" ]]; then
  go mod edit -go=1.18
elif [[ $chain_name == "gravitybridge" ]]; then
  cd module
fi

if [[ $chain_name == "emoney" ]]; then
  go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble-sync-all
else
  go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
fi

if [ $( echo "${chain_name}" | egrep -c "^(cyber|provenance)$" ) -ne 0 ]; then
  go mod tidy -compat=1.17
else
  go mod tidy
fi

if [ $( echo "${chain_name}" | egrep -c "^(starname|sifchain)$" ) -ne 0 ]; then
  go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./cmd/$daemon_name
elif [ $( echo "${chain_name}" | egrep -c "^(comdex|persistent)$" ) -ne 0 ]; then
  go build -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" -o /root/go/bin/$daemon_name ./node
elif [[ $chain_name == "axelar" ]]; then
  axelard_version=${version##*v}
  go build -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/cosmos/cosmos-sdk/version.Version=$axelard_version" -o /root/go/bin/$daemon_name ./cmd/axelard
elif [[ $chain_name == "emoney" ]]; then
  sed -i 's/db.NewGoLevelDB/sdk.NewLevelDB/g' app.go
  go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/e-money/cosmos-sdk/types.DBBackend=pebbledb" ./...
else
  go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...
fi

echo "#################################################################################################################"
echo "download snapshot:"

# delete node home
rm -rf $node_home/*

$HOME/go/bin/$daemon_name init test

# backup $node_home/data/priv_validator_state.json as it is not included in snapshot from some providers.
mv $node_home/data/priv_validator_state.json $node_home/config/

# delete the data folder
rm -rf $node_home/data/*

cd $node_home

# always try from our snapshot first, if failure => use external providers
URL="http://tasks.snapshot_$chain_name/chain.json"
status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 3 $URL)
if [[ $status_code == "200" ]]; then
  URL=`curl -s $URL |jq -r '.snapshot_url'`
  URL="http://tasks.snapshot_$chain_name/${URL##*/}"
else
  echo "Not found snapshot for $chain_name from notional.ventures, continue to try other providers..."

  echo "Loop forever for debug"
  loop_forever
fi

echo "URL=$URL"

if [[ -z $URL ]]; then
  echo "URL to download snapshot is empty. Pls fix it!"
  loop_forever
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
  loop_forever
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
    loop_forever
  fi
fi

# restore priv_validator_state.json if it does not exist in the snapshot
[ ! -f $node_home/data/priv_validator_state.json ] && mv $node_home/config/priv_validator_state.json $node_home/data/

# set minimum gas prices & rpc port...
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas_prices\"/" $node_home/config/app.toml
sed -i '/^\[api]/,/^\[/{s/^enable[[:space:]]*=.*/enable = true/}' $node_home/config/app.toml
sed -i '/^\[grpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:9090"/}' $node_home/config/app.toml
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
sed -i -e "s/^max_num_inbound_peers *=.*/max_num_inbound_peers = 1000/" $node_home/config/config.toml
sed -i -e "s/^max_num_outbound_peers *=.*/max_num_outbound_peers = 200/" $node_home/config/config.toml
sed -i -e "s/^log_level *=.*/log_level = \"error\"/" $node_home/config/config.toml
###
sed -i -e "s/^db_backend *=.*/db_backend = \"pebbledb\"/" $node_home/config/config.toml

echo "download genesis file..."
if [[ $genesis_url == *.json.gz ]]; then
  wget -O - "$genesis_url" |gzip -cd > $node_home/config/genesis.json
elif [[ $genesis_url == *.tar.gz ]]; then
  wget -O - "$genesis_url" |tar -xvzf - -O > $node_home/config/genesis.json
elif [[ $genesis_url == *.json ]]; then
  curl -Ls "$genesis_url" > $node_home/config/genesis.json
else
  echo "Not support genesis file type"
  loop_forever
fi


echo "download addrbook..."
# we try notional.ventures first, failed => other providers
URL="https://snapshot.notional.ventures/$chain_name/addrbook.json"
status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 3 $URL)
if [[ $status_code != "200" ]]; then
  echo "Not found snapshot for $chain_name from snapshot, continue to try other providers..."
  URL=$addrbook_url
fi

curl -fso $node_home/config/addrbook.json "$URL"

########################################################################################################################
# supervised
pip install supervisor
mkdir -p /etc/supervisor/conf.d
echo_supervisord_conf > /etc/supervisor/supervisord.conf
echo "[include]
files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf

# use start_chain.sh to start chain with local peers
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/start_chain.sh" > $HOME/start_chain.sh

cat <<EOT > /etc/supervisor/conf.d/chain.conf
[program:chain]
command=/bin/bash /root/start_chain.sh $chain_name $rpc_service_name
autostart=false
autorestart=false
stopasgroup=true
killasgroup=true
stderr_logfile=/var/log/chain.err.log
stdout_logfile=/var/log/chain.out.log
EOT

supervisord

########################################################################################################################
echo "install pebblecompact"
cd $HOME
git clone https://github.com/notional-labs/pebblecompact
cd pebblecompact
make install

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/scripts/pebblecompact_data.sh" > $HOME/pebblecompact_data.sh

echo "#################################################################################################################"
echo "start nginx..."
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/nginx.conf" > /etc/nginx/nginx.conf
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/healthcheck.sh" > /usr/share/nginx/html/healthcheck.sh
chmod +x /usr/share/nginx/html/healthcheck.sh
spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap
/usr/sbin/nginx

echo "#################################################################################################################"
echo "start chain..."
supervisorctl start chain

########################################################################################################################
# cron

# pick a random hour to compact and restart service
random_hour=$(( ${RANDOM} % 24 ))

cat <<EOT > $HOME/restart_cronjob.sh
date >> $HOME/cron_restart_chain.log
/usr/sbin/supervisorctl stop chain
sleep 60
/usr/sbin/killall $daemon_name
sleep 10
echo "compacting..."
cd $HOME && sh pebblecompact_data.sh $node_home/data
/usr/sbin/supervisorctl start chain
EOT

echo "0 $random_hour 1/2 * * root /bin/bash $HOME/restart_cronjob.sh" > /etc/cron.d/cron_restart_chain
crond

loop_forever
