# usage: ./snapshost_run.sh chain_name
# eg., ./snapshost_run.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./snapshost_run.sh cosmoshub"
  exit
fi

cd $HOME
pacman -Syu --noconfirm go git base-devel wget jq python python-pip cronie nginx spawn-fcgi fcgiwrap cpulimit $pacman_pkgs

echo "#################################################################################################################"
echo "nginx..."

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/snapshot.nginx.conf" > /etc/nginx/nginx.conf
# mkdir -p /snapshot
/usr/sbin/nginx

sleep 5

########################################################################################################################
echo "install cosmos-pruner"
git clone https://github.com/binaryholdings/cosmprund
cd cosmprund
make install

########################################################################################################################
# download snapshot

# use start_chain.sh to start chain with local peers
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/start_chain.sh" > $HOME/start_chain.sh

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/50-auto-prune-snapshot/snapshot/snapshot_download.sh" > $HOME/snapshot_download.sh
source ./snapshot_download.sh

########################################################################################################################
# supervised
pip install supervisor
mkdir -p /etc/supervisor/conf.d
echo_supervisord_conf > /etc/supervisor/supervisord.conf
echo "[include]
files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf


cat <<EOT > /etc/supervisor/conf.d/chain.conf
[program:chain]
command=/bin/bash /root/start_chain.sh $chain_name
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

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/50-auto-prune-snapshot/snapshot/snapshot_cronjob.sh" > $HOME/snapshot_cronjob.sh

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