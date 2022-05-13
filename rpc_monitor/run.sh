pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils git nodejs npm yarn python2 cronie screen

cd $HOME


git_branch=$(git symbolic-ref --short -q HEAD)
git clone --single-branch --branch $git_branch https://github.com/notional-labs/cosmosia

cd $HOME/cosmosia/rpc_monitor/web


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v10.24.1

yarn && yarn build

screen -S server -dm node server.js

########################################################################################################################
# cron
echo "0/1 * * * * root /bin/bash $HOME/cosmosia/rpc_monitor/cronjob_get_status.sh" > /etc/cron.d/cron_get_status

# start crond
crond

# loop forever for debugging only
while true; do sleep 5; done
