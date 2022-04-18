# usage: ./snapshost_run.sh chain_name
# eg., ./snapshost_run.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./snapshost_run.sh cosmoshub"
  exit
fi

cd $HOME

curl -Ls "https://raw.githubusercontent.com/baabeetaa/cosmosia/main/snapshot/snapshot_download.sh" > $HOME/snapshot_download.sh
source ./snapshot_download.sh


pacman -Syu --noconfirm python python-pip cronie nginx jq openssh

echo "#################################################################################################################"
echo "nginx..."

curl -Ls "https://raw.githubusercontent.com/baabeetaa/cosmosia/main/snapshot/snapshot.nginx.conf" > /etc/nginx/nginx.conf
mkdir -p /snapshot
/usr/sbin/nginx

########################################################################################################################
# supervised
pip install supervisor
mkdir -p /etc/supervisor/conf.d
echo_supervisord_conf > /etc/supervisor/supervisord.conf
echo "[include]
files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf


cat <<EOT >> /etc/supervisor/conf.d/chain.conf
[program:chain]
command=/bin/bash /root/start_chain.sh
autostart=false
autorestart=false
stopasgroup=true
killasgroup=true
stderr_logfile=/var/log/chain.err.log
stdout_logfile=/var/log/chain.out.log
EOT

supervisord

########################################################################################################################
# cron

curl -Ls "https://raw.githubusercontent.com/baabeetaa/cosmosia/main/snapshot/snapshot_cronjob.sh" > $HOME/snapshot_cronjob.sh

if [[ -z $snapshot_time ]]; then
  echo "No time setting to take snapshot, please set snapshot_time in chain_registry.ini"
  exit
fi

snapshot_time_hour=${snapshot_time%%:*}
snapshot_time_minute=${snapshot_time##*:}
echo "$snapshot_time_minute $snapshot_time_hour * * * root /usr/bin/flock -n /var/run/lock/snapshot_cronjob.lock /bin/bash $HOME/snapshot_cronjob.sh" > /etc/cron.d/cron_snapshot

# start crond
crond


# loop forever for debugging only
while true; do sleep 5; done