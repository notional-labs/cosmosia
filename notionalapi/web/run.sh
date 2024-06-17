pacman -Syu --noconfirm
pacman -S --noconfirm git yarn screen wget


# install nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v18.14.0

yarn set version v18.14.0

cd $HOME
gh_access_token="$(curl -s "http://tasks.web_config/config/gh_access_token")"
git clone --single-branch --branch main "https://${gh_access_token}@github.com/notional-labs/notionalapi"

########################################################################################################################
# web
cd $HOME/notionalapi/web

# create .env file
wget "http://tasks.web_config/config/notionalapi.web.env" -O $HOME/notionalapi/web/.env

yarn && yarn build
screen -S server -dm yarn start

########################################################################################################################
# deposit_watcher
cd $HOME/notionalapi/web

screen -S server -dm yarn deposit_watcher

########################################################################################################################
# pool-spending
cd $HOME/notionalapi/web

screen -S server -dm yarn pool-spending


# loop forever for debugging only
while true; do sleep 5; done
