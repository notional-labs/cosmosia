# usage: ./sss_run.sh chain_name
# eg., ./sss_run.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./sss_run.sh cosmoshub"
  exit
fi

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
echo "start_flags=$start_flags"

if [[ -z $git_repo ]]; then
  echo "Not support chain $chain_name"
  loop_forever
fi

pacman -Syu --noconfirm
pacman -Sy --noconfirm go git base-devel wget jq nginx

echo "#################################################################################################################"
echo "nginx..."

# a webserver to fix buggy chains eg., bandchain - missing `files` folder.
# so this webserver hosting these missing files for client to download

cat <<EOT > /etc/nginx/nginx.conf
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;
    types_hash_max_size 4096;
    server_names_hash_bucket_size 128;

    server {
        listen       80;
        server_name  localhost;

        root   /usr/share/nginx/html;

        location / {
            root /statesync;
            autoindex on;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
    }
}
EOT

mkdir -p /statesync

echo "start nginx..."
/usr/sbin/nginx
sleep 10

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

go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble

if [ $( echo "${chain_name}" | egrep -c "^(cyber|provenance)$" ) -ne 0 ]; then
  go mod tidy -compat=1.17
else
  go mod tidy
fi

  if [ $( echo "${chain_name}" | egrep -c "^(emoney)$" ) -ne 0 ]; then
    go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./...
  elif [ $( echo "${chain_name}" | egrep -c "^(starname|sifchain)$" ) -ne 0 ]; then
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

# restore priv_validator_state.json if it does not exist in the snapshot
[ ! -f $node_home/data/priv_validator_state.json ] && mv $node_home/config/priv_validator_state.json $node_home/data/

# set minimum gas prices & rpc port...
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas_prices\"/" $node_home/config/app.toml
sed -i '/^\[api]/,/^\[/{s/^enable[[:space:]]*=.*/enable = true/}' $node_home/config/app.toml
sed -i '/^\[grpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:9090"/}' $node_home/config/app.toml
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $node_home/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $node_home/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"0\"/" $node_home/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"100\"/" $node_home/config/app.toml
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = 14400/" $node_home/config/app.toml
sed -i -e "s/^snapshot-keep-recent *=.*/snapshot-keep-recent = 2/" $node_home/config/app.toml

# https://github.com/notional-labs/cosmosia/issues/24
[ "$chain_name" != "kava" ] && sed -i -e "s/^swagger *=.*/swagger = true/" $node_home/config/app.toml

sed -i '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $node_home/config/config.toml
sed -i -e "s/^max_num_inbound_peers *=.*/max_num_inbound_peers = 1000/" $node_home/config/config.toml
sed -i -e "s/^max_num_outbound_peers *=.*/max_num_outbound_peers = 200/" $node_home/config/config.toml
sed -i -e "s/^log_level *=.*/log_level = \"error\"/" $node_home/config/config.toml
###
sed -i -e "s/^db_backend *=.*/db_backend = \"pebbledb\"/" $node_home/config/config.toml

echo "download addrbook..."
curl -fso $node_home/config/addrbook.json "https://snapshot.notional.ventures/$chain_name/addrbook.json"

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

########

# fix Persistence (persistent) chain creating a soft-link ln -s /root/data/snapshots ~/.persistenceCore/data/snapshots
[[ $chain_name == "persistent" ]] && mkdir -p /root/data/snapshots && ln -s /root/data/snapshots $node_home/data/snapshots

echo "start chain..."
$HOME/go/bin/$daemon_name start --db_backend=pebbledb $start_flags

EXITCODE=$?
echo "chain stopped with exit code=$EXITCODE"

loop_forever
