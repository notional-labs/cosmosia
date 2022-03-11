# build from source first
pacman -Syy --noconfirm go git base-devel wget jq

cd $HOME
git clone https://github.com/cosmos/gaia
cd gaia/
git checkout v6.0.3
go install ./...



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
wget -O - $URL | lz4 -d | tar -xvf -



# set minimum gas prices
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001uatom\"/" $HOME/.gaia/config/app.toml

# set rpc port
sed -i.bak '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' $HOME/.gaia/config/config.toml


# copy addrbook and genesis
cp /cosmosia/cosmoshub/addrbook.json $HOME/.gaia/config/
cp /cosmosia/cosmoshub/genesis.json $HOME/.gaia/config/



$HOME/go/bin/gaiad start --x-crisis-skip-assert-invariants

