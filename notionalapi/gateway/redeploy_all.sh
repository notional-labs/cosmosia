SERVICES=$(cat <<-END
agoric-archive-sub
agoric
akash
archway
assetmantle
axelar
bitcanna
bitsong
celestia-testnet
celestia
cheqd
chihuahua
composable
composable-archive-sub
composable-testnet
coreum
cosmoshub1-archive-sub0
cosmoshub2-archive-sub0
cosmoshub3-archive-sub0
cosmoshub-archive-sub1
cosmoshub-archive-sub
cosmoshub
cosmoshub-testnet
crescent-testnet
crescent
cryptoorgchain
dig-archive
dig
dydx-archive-sub
dydx-testnet
dydx
emoney
evmos-archive-sub1
evmos-archive-sub2
evmos-archive-sub3
evmos-archive-sub4
evmos-archive-sub
evmos
evmos-testnet
fetchhub
furya
gravitybridge
injective-testnet
injective
irisnet
ixo
juno-archive-sub1
juno-archive-sub2
juno-archive-sub3
juno-archive-sub
juno
kava
kichain
konstellation
kujira
mars
neutron-archive-sub
neutron-testnet
neutron
noble
nois
odin
omniflixhub
osmosis-archive-sub1
osmosis-archive-sub2
osmosis-archive-sub
osmosis-testnet
osmosis
persistence-archive-sub
persistent
quasar
quicksilver
regen-archive-sub
regen-testnet
regen
sei-archive-sub
sei-archive-sub1
sei-archive-sub2
sei
sentinel
sommelier
stargaze-testnet
stargaze
starname
stride
terra2-testnet
terra2
terra
umee
vidulum
whitewhale-testnet
whitewhale
END
)

for service_name in $SERVICES; do
  echo "redeploying $service_name"
  sh docker_service_create.sh $service_name
  sleep 3
done

