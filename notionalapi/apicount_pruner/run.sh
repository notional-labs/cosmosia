pacman -Syu --noconfirm
pacman -S --noconfirm mariadb mariadb-clients cronie


########################################################################################################################
# cron

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/napi/apicount_pruner/notionalapi/apicount_pruner/prune_cronjob.sh" > $HOME/prune_cronjob.sh

echo "0 0 * * * root /bin/bash $HOME/prune_cronjob.sh" > /etc/cron.d/cron_prune_apicount

crond



########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 60; done