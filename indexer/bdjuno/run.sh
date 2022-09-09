# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub"
  exit
fi

########################################################################################################################
pacman -Syu --noconfirm
pacman -S --noconfirm go git base-devel wget jq screen postgresql-libs

export GOPATH="$HOME/go"
export GOROOT="/usr/lib/go"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOROOT}/bin:${GOBIN}"

########################################################################################################################
echo "build & install bdjuno"

cd $HOME
git clone https://github.com/baabeetaa/bdjuno
cd bdjuno/
git fetch --all --tags

branch="${chain_name}"
if [[ $chain_name == "cosmoshub" ]]; then
  branch="cosmos"
fi


git checkout chains/${branch}/mainnet
make install

########################################################################################################################
echo "config bdjuno"

$HOME/go/bin/bdjuno init

echo "download config"
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/indexer/indexer/bdjuno/config.${chain_name}.yaml" > $HOME/.bdjuno/config.yaml

echo "create database bdjuno"
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432 -c "CREATE DATABASE bdjuno;"

echo "create database hasura for metadata"
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432 -c "CREATE DATABASE hasura;"

echo "create schema"
cd $HOME/bdjuno/database/schema/
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 00-cosmos.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 01-auth.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 02-bank.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 03-staking.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 04-consensus.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 05-mint.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 06-distribution.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 07-pricefeed.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 08-gov.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 09-modules.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 10-slashing.sql
psql postgresql://postgres:mysecretpassword@tasks.psql_${chain_name}:5432/bdjuno -f 11-feegrant.sql

echo "import genesis"
curl -Ls "https://snapshot.notional.ventures/$chain_name/genesis.json" > $HOME/.bdjuno/genesis.json
$HOME/go/bin/bdjuno parse genesis-file --genesis-file-path $HOME/.bdjuno/genesis.json


####
echo "install hasura-cli"
curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash


echo "wait for hasura up"

is_OK=""
while [[ "$is_OK" != "OK" ]]; do
  sleep 60;
  is_OK=$(curl --silent --max-time 3 "http://tasks.hasura_${chain_name}:8080/healthz")
  echo "waiting for hasura up.....is_OK=$is_OK"
done

echo "hasura is up, continue..."

echo "clear metadata"
hasura metadata clear --endpoint http://tasks.hasura_${chain_name}:8080 --admin-secret myadminsecretkey

echo "apply the metadata"
cd /root/bdjuno/hasura
hasura metadata apply --endpoint http://tasks.hasura_${chain_name}:8080 --admin-secret myadminsecretkey


echo "start bdjuno"
screen -S bdjuno -dm $HOME/go/bin/bdjuno start

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
