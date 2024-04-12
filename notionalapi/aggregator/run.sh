pacman -Syu --noconfirm
pacman -S --noconfirm git screen wget


# install nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v18.14.0
npm install --global yarn

cd $HOME
gh_access_token="$(curl -s "http://tasks.web_config/config/gh_access_token")"
git clone --single-branch --branch main "https://${gh_access_token}@github.com/notional-labs/notionalapi"

########################################################################################################################
# web
cd $HOME/notionalapi/backend

# create .env file
wget "http://tasks.web_config/config/notionalapi.backend.env" -O $HOME/notionalapi/backend/.env

yarn

cat <<EOT > $HOME/start.sh
cd $HOME/notionalapi/backend
while true; do
  yarn aggregator
  sleep 5;
done
EOT

screen -S server -dm /bin/bash $HOME/start.sh


# loop forever for debugging only
while true; do sleep 5; done
