pacman -Syu --noconfirm
pacman -S --noconfirm git screen

########################################
# install nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

sleep 5

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v18.14.0
npm install --global yarn

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/upgrade-watcher

########################################
# backend
cd $HOME/upgrade-watcher/backend

# download .env config file
curl -Ls http://tasks.web_config/config/cosmosia.upgrade_watcher.backend.env > $HOME/upgrade-watcher/backend/.env

yarn
screen -S backend -dm yarn start

########################################
# frontend
cd $HOME/upgrade-watcher/frontend

# create .env.local file
cat <<EOT >> .env.local
NEXTAUTH_URL="https://upgrade-watcher.notional.ventures"
EOT

yarn && yarn build
screen -S web -dm yarn start

########################################################################################################################
echo "Done!"
# loop forever for debugging
while true; do sleep 5; done