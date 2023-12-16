# usage: ./run.sh hubname
# eg., ./run.sh whitewhale

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

hubname="$1"
if [[ -z $hubname ]]; then
  echo "No hubname!"
  loop_forever
fi


pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel screen wget

# install hermes
cd $HOME
mkdir -p $HOME/.hermes/bin
wget -O - "https://github.com/informalsystems/hermes/releases/download/v1.7.4/hermes-v1.7.4-x86_64-unknown-linux-gnu.tar.gz" |tar -xz -C $HOME/.hermes/bin/

# hermes config
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/491-relaying-test-relaying/relaying/${hubname}_config.toml" > $HOME/.hermes/config.toml
curl -Ls "http://tasks.web_config/config/cosmosia.relay.${hubname}.mnemonic.txt" > $HOME/.hermes/mnemonic.txt


chain_ids=$(cat $HOME/.hermes/config.toml |grep id |sed -e "s/id = //g" -e "s/'//g")
for chain_id in $chain_ids; do
  $HOME/.hermes/bin/hermes keys add --chain $chain_id --mnemonic-file $HOME/.hermes/mnemonic.txt
done


loop_forever