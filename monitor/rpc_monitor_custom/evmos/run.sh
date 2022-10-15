pacman -Syu --noconfirm
pacman -S --noconfirm base-devel jq dnsutils git yarn cronie screen


########################################################################################################################
# Prepare

# install python2 from source as its no longer available
cd $HOME
curl -o Python-2.7.10.tgz https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz
tar -zxf Python-2.7.10.tgz
cd Python-2.7.10
./configure
make
make install

# install nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v10.24.1

yarn set version 1.22.1

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/cosmosia

########################################################################################################################
# web
cd $HOME/cosmosia/rpc_monitor/web
yarn && yarn build

screen -S server -dm node server.js

########################################################################################################################
# cron
echo "*/1 * * * * root /bin/bash $HOME/cosmosia/monitor/rpc_monitor_custom/evmos/cronjob_get_status.sh" > /etc/cron.d/cron_get_status
echo "*/5 * * * * root /bin/bash $HOME/cosmosia/monitor/rpc_monitor_custom/evmos/cronjob_get_snapshot_size.sh" > /etc/cron.d/cron_get_snapshot_size

# start crond
crond

# loop forever for debugging only
while true; do sleep 5; done
