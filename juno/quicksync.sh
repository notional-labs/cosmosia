# build juno from source first
pacman -Syy --noconfirm go git base-devel wget

cd $HOME
git clone https://github.com/CosmosContracts/juno
cd juno/
git checkout v2.1.0
make install


# using https://polkachu.com/tendermint_snapshots/juno

# delete All home
rm -rf $HOME/.juno

$HOME/go/bin/junod init test --chain-id juno-1

# set minimum gas prices
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025ujuno\"/" ~/.juno/config/app.toml

# set rpc port
sed -i.bak '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $HOME/.juno/config/config.toml

# set peers
CHAIN_REPO="https://raw.githubusercontent.com/CosmosContracts/mainnet/main/juno-1" && \
PEERS="$(curl -s "$CHAIN_REPO/persistent_peers.txt")"
echo "PEERS=$PEERS"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.juno/config/config.toml


# setting for polkachu snapshot

# indexer = "null"
sed -i.bak -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.juno/config/config.toml


# pruning = "custom"
# pruning-keep-recent = "100"
# pruning-keep-every = "0"
# pruning-interval = "10"
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.juno/config/app.toml
sed -i.bak -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.juno/config/app.toml
sed -i.bak -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"0\"/" $HOME/.juno/config/app.toml
sed -i.bak -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.juno/config/app.toml


# delete the data folder
rm -rf $HOME/.juno/data/*


# download genesis file
curl -s  https://raw.githubusercontent.com/CosmosContracts/mainnet/main/juno-1/genesis.json > $HOME/.juno/config/genesis.json

# copy addrbook
cp /cosmosia/juno/addrbook.json $HOME/.juno/config/


# get data from snapshot
cd $HOME/.juno/

URL="https://snapshots2.polkachu.com/snapshots/juno/juno_2191990.tar.lz4"
wget -O - $URL | lz4 -d | tar -xvf -


# /cosmosia/juno/junod start
$HOME/go/bin/junod start

