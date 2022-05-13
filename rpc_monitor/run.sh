pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils git nodejs npm yarn python2 cronie screen

cd $HOME

git clone --single-branch --branch main https://github.com/notional-labs/cosmosia

cd $HOME/cosmosia/rpc_monitor/web


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v10.24.1

yarn && yarn build

screen -S server -dm node server.js

########################################################################################################################
# cron
echo "0 * * * * root /usr/bin/flock -n /var/run/lock/snapshot_cronjob.lock /bin/bash $HOME/snapshot_cronjob.sh" > /etc/cron.d/cron_snapshot

# start crond
crond


# loop forever for debugging only
while true; do sleep 5; done


cd $HOME/cosmosia/rpc_monitor





while true; do
  /bin/bash get_status.sh

  # sleep 120 seconds...
  sleep 120
done