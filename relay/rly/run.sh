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
pacman -S --noconfirm git base-devel python python-pip cronie screen wget jq

################################################################################################
# install
cd $HOME
wget "https://github.com/cosmos/relayer/releases/download/v2.5.2/Cosmos.Relayer_2.5.2_linux_amd64.tar.gz"
tar -xf Cosmos.Relayer_2.5.2_linux_amd64.tar.gz -C $HOME/
mv 'Cosmos Relayer_2.5.2_linux_amd64'/rly /usr/bin/
rm -rf 'Cosmos Relayer_2.5.2_linux_amd64'/

################################################################################################
# config
cd $HOME
mkdir $HOME/.relayer/config
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/relay/rly/config/${hubname}_config.yaml" > $HOME/.relayer/config/config.yaml
curl -Ls "http://tasks.web_config/config/cosmosia.relay_clear.${hubname}.mnemonic.txt" > $HOME/.relayer/config/mnemonic.txt
MNEMONIC=$(cat $HOME/.relayer/config/mnemonic.txt)
export MNEMONIC="$MNEMONIC"
rly keys restore default "${MNEMONIC}" --restore-all

################################################################################################
# run
screen -S rly -dm rly start

################################################################################################
loop_forever