# build from source first
pacman -Syy --noconfirm go git base-devel wget jq

cd $HOME
git clone https://github.com/osmosis-labs/osmosis
cd osmosis/
git checkout v7.0.4
go install ./...


# using quicksync.io https://quicksync.io/networks/osmosis.html

# delete All home
rm -rf $HOME/.osmosisd

$HOME/go/bin/osmosisd init test

# set rpc port
sed -i.bak '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $HOME/.osmosisd/config/config.toml

# delete the data folder
rm -rf $HOME/.osmosisd/data/*

# set rpc port
sed -i.bak -e "s/^laddr *=.*/laddr = \"tcp://0.0.0.0:26657\"/" $HOME/.osmosisd/config/config.toml

# download genesis file
wget -O $HOME/.osmosisd/config/genesis.json http://proxy_cache:8080/https://github.com/osmosis-labs/networks/raw/main/osmosis-1/genesis.json

# copy addrbook and genesis
cp /root/cosmosia/osmosis/addrbook.json $HOME/.osmosisd/config/


# get data from quicksync
cd $HOME/.osmosisd/

URL=`curl https://quicksync.io/osmosis.json|jq -r '.[] |select(.file=="osmosis-1-pruned")|select (.mirror=="Netherlands")|.url'`
echo "URL=$URL"
wget --timeout=0 -O - "http://proxy_cache:8080/$URL" | lz4 -d | tar -xvf -


$HOME/go/bin/osmosisd start





