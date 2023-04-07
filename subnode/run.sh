# usage: ./run.sh subnode_name
# eg., ./run.sh osmosis

subnode_name="$1"

if [[ -z $subnode_name ]]; then
  echo "No subnode_name. usage eg., ./run.sh osmosis"
  exit
fi

pacman -Syu --noconfirm
pacman -Sy --noconfirm go git base-devel wget jq inetutils screen

echo "#################################################################################################################"
echo "install go..."

export GOPATH="$HOME/go"
export GOROOT="/usr/lib/go"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOROOT}/bin:${GOBIN}"

cd $HOME

echo "#################################################################################################################"
echo "install subnode"

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/subnode
cd subnode
make install


# get config
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/subnode/${subnode_name}_subnode.yaml > ~/subnode.yaml

# run subnode with screen to avoid log to docker
cd $HOME
screen -S subnode -dm /root/go/bin/subnode start --conf=/root/subnode.yaml

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
