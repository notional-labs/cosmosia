# build from source first
pacman -Syy --noconfirm go git base-devel wget jq

cd $HOME
git clone https://github.com/baabeetaa/cosmosia
cd cosmosia/
#git checkout main




# using quicksync.io https://quicksync.io/networks/cosmos.html

# delete All gaia home
rm -rf $HOME/.gaia

$HOME/go/bin/gaiad init test

# delete the data folder
rm -rf $HOME/.gaia/data/*


# get data from quicksync
cd $HOME/.gaia/

URL=`curl https://quicksync.io/cosmos.json|jq -r '.[] |select(.file=="cosmoshub-4-pruned")|.url'`
echo "URL=$URL"
wget -O - "http://proxy_cache:8080/$URL" | lz4 -d | tar -xvf -


# set minimum gas prices
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001uatom\"/" $HOME/.gaia/config/app.toml

# set rpc port
sed -i.bak '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $HOME/.gaia/config/config.toml

# Prepare genesis file for cosmoshub-4
wget --timeout=0 http://proxy_cache:8080/https://github.com/cosmos/mainnet/raw/master/genesis.cosmoshub-4.json.gz
gzip -d genesis.cosmoshub-4.json.gz
mv genesis.cosmoshub-4.json $HOME/.gaia/config/genesis.json

# copy addrbook
cp /cosmosia/cosmoshub/addrbook.json $HOME/.gaia/config/


$HOME/go/bin/gaiad start --x-crisis-skip-assert-invariants

