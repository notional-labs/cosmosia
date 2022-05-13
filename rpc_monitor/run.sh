pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils git nodejs npm yarn python2 cronie screen


########################################################################################################################
# Prepare
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v10.24.1

cd $HOME
git clone --single-branch --branch monitor_snapshot_file_size https://github.com/notional-labs/cosmosia

########################################################################################################################
# web
cd $HOME/cosmosia/rpc_monitor/web
yarn && yarn build

screen -S server -dm node server.js

########################################################################################################################
# cron
echo "*/1 * * * * root /bin/bash $HOME/cosmosia/rpc_monitor/cronjob_get_status.sh" > /etc/cron.d/cron_get_status

# start crond
crond

# loop forever for debugging only
while true; do sleep 5; done
