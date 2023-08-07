pacman -Syu --noconfirm
pacman -S --noconfirm git yarn screen wget


# install nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v18.14.0

yarn set version v18.14.0

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/notionalapi

########################################################################################################################
# web
cd $HOME/notionalapi/backend

# create .env file
wget "http://tasks.web_config/config/notionalapi.backend.env" -O $HOME/notionalapi/backend/.env


screen -S server -dm yarn aggregator


# loop forever for debugging only
while true; do sleep 5; done
