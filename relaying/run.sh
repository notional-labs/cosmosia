pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel screen wget

# install hermes
cd $HOME
mkdir -p $HOME/.hermes/bin
wget -O - "https://github.com/informalsystems/hermes/releases/download/v1.7.4/hermes-v1.7.4-x86_64-unknown-linux-gnu.tar.gz" |tar -xz -C $HOME/.hermes/bin




# loop forever for debugging only
while true; do sleep 5; done