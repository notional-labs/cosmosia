#!/bin/bash
pacman -Syu --noconfirm
pacman -S --noconfirm cronie

cd $HOME

#############################################################################
# install (no need to install)
#cd $HOME
#curl -L https://github.com/rqlite/rqlite/releases/download/v7.21.4/rqlite-v7.21.4-linux-amd64.tar.gz -o rqlite-v7.21.4-linux-amd64.tar.gz
#tar xvfz rqlite-v7.21.4-linux-amd64.tar.gz
#cd rqlite-v7.21.4-linux-amd64
#./rqlited ~/node.1


#########
# setup cronjob
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/notionalapi/db_backup/backup.sh" > $HOME/backup.sh

echo "0 */12 * * * root /bin/bash $HOME/backup.sh" > /etc/cron.d/cron_backup


# loop forever
while true; do sleep 5; done