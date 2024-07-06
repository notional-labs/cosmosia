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
# install rly
cd $HOME
wget "https://github.com/cosmos/relayer/releases/download/v2.5.2/Cosmos.Relayer_2.5.2_linux_amd64.tar.gz"
tar -xz Cosmos.Relayer_2.5.2_linux_amd64.tar.gz -C $HOME/
rm -rf 'Cosmos Relayer_2.5.2_linux_amd64'/

# rly config
cd $HOME
mkdir $HOME/.relayer/config
# /.relayer/config/config.yaml
curl -Ls "http://tasks.web_config/config/cosmosia.relay_clear.${hubname}.mnemonic.txt" > $HOME/.relayer/config/mnemonic.txt
MNEMONIC=$(cat $HOME/.relayer/config/mnemonic.txt)
export MNEMONIC="$MNEMONIC"

# TODO: use https://kislyuk.github.io/yq/ to get list of chains
#chains=$(cat $HOME/.relayer/config/config.yaml |grep "id = " |sed -e "s/id = //g" -e "s/'//g" -e 's/"//g')
#for chain in $chain_ids; do
#  rly keys restore composable default "${MNEMONIC}"
#done






################################################################################################
loop_forever