# Note: statesync isnt reliable, dont use it atm

# delte the data
rm -rf $HOME/.gaia


/root/cosmosia/cosmoshub/gaiad init test


# copy addrbook and genesis
cp /root/cosmosia/cosmoshub/addrbook.json $HOME/.gaia/config/
cp /root/cosmosia/cosmoshub/genesis.json $HOME/.gaia/config/


# enable statesync
sed -i.bak -e "s/^enable *=.*/enable = true/" $HOME/.gaia/config/config.toml


INTERVAL=1000
LATEST_HEIGHT=$(curl -s https://rpc.cosmos.network/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL))
TRUST_HASH=$(curl -s "https://rpc.cosmos.network/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo "TRUST HEIGHT: $BLOCK_HEIGHT"
echo "TRUST HASH: $TRUST_HASH"

export GAIAD_STATESYNC_ENABLE=true
export GAIAD_P2P_MAX_NUM_OUTBOUND_PEERS=200
export GAIAD_STATESYNC_RPC_SERVERS="https://rpc.cosmos.network:433,https://cosmos.chorus.one,https://cosmoshub.validator.network/,https://cosmoshub-4.technofractal.com:443,https://rpc-cosmoshub.blockapsis.com"
export GAIAD_STATESYNC_TRUST_HEIGHT=$BLOCK_HEIGHT
export GAIAD_STATESYNC_TRUST_HASH=$TRUST_HASH
# export GAIAD_P2P_SEEDS="bf8328b66dceb4987e5cd94430af66045e59899f@public-seed.cosmos.vitwit.com:26656,cfd785a4224c7940e9a10f6c1ab24c343e923bec@164.68.107.188:26656,d72b3011ed46d783e369fdf8ae2055b99a1e5074@173.249.50.25:26656,ba3bacc714817218562f743178228f23678b2873@public-seed-node.cosmoshub.certus.one:26656,3c7cad4154967a294b3ba1cc752e40e8779640ad@84.201.128.115:26656,366ac852255c3ac8de17e11ae9ec814b8c68bddb@51.15.94.196:26656"

/root/cosmosia/cosmoshub/gaiad start --x-crisis-skip-assert-invariants

# /root/cosmosia/cosmoshub/gaiad start
