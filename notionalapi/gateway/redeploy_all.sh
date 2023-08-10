SERVICES=$(cat <<-END
akash
assetmantle
axelar
bitcanna
bitsong
celestia-testnet
cheqd
chihuahua
composable
cosmoshub-archive-sub1
cosmoshub-archive-sub
cosmoshub
crescent
cryptoorgchain
cyber
dig-archive
dig
emoney
evmos-archive-sub1
evmos-archive-sub2
evmos-archive-sub3
evmos-archive-sub
evmos
fetchhub
gravitybridge
injective
irisnet
ixo
juno
kava
kichain
konstellation
kujira
mars
neutron
noble
omniflixhub
osmosis-testnet
osmosis
persistent
quasar
quicksilver
regen
sei-archive-sub
sei
sentinel
stargaze
starname
stride
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

