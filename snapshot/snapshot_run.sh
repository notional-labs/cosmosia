# usage: ./snapshost_run.sh chain_name
# eg., ./snapshost_run.sh cosmoshub

chain_name="$1"

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./snapshost_run.sh cosmoshub"
  loop_forever
fi

echo "#################################################################################################################"
echo "read chain info:"
# https://www.medo64.com/2018/12/extracting-single-ini-section-via-bash/

eval "$(curl -s "$CHAIN_REGISTRY_INI_URL" |awk -v TARGET=$chain_name -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ')"


# write chain info to bash file, so that cronjob could know
cat <<EOT >> $HOME/env.sh
chain_name="$chain_name"
git_repo="$git_repo"
version="$version"
daemon_name="$daemon_name"
node_home="$node_home"
minimum_gas_prices="$minimum_gas_prices"
start_flags="$start_flags"
snapshot_node="$snapshot_node"
snapshot_storage_node="$snapshot_storage_node"
snapshot_prune="$snapshot_prune"
EOT

if [[ -z $version ]]; then
  echo "No version found, exit!"
  loop_forever
fi

cd $HOME
pacman -Syu --noconfirm
pacman -Sy --noconfirm go git base-devel wget pigz jq dnsutils inetutils python python-pip cronie spawn-fcgi fcgiwrap openssh

echo "#################################################################################################################"
echo "openssh..."

mkdir -p $HOME/.ssh
curl -Ls http://tasks.web_config/config/cosmosia.id_rsa.pub > $HOME/.ssh/id_rsa.pub
curl -Ls http://tasks.web_config/config/cosmosia.id_rsa > $HOME/.ssh/id_rsa

chmod -R 700 ~/.ssh

echo "#################################################################################################################"
sleep 5

# start_chain.sh script
cat <<EOT >> $HOME/start_chain.sh
source $HOME/env.sh
# fix supervisorctl creates a dbus-daemon process everytime starting chain
killall dbus-daemon
$HOME/go/bin/$daemon_name start --db_backend=pebbledb $start_flags
EOT

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/snapshot_restore.sh" > $HOME/snapshot_restore.sh

########################################################################################################################
echo "install cosmos-pruner"
cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/cosmprund
cd cosmprund
make install

########################################################################################################################
# restore snapshot
cd $HOME
source $HOME/snapshot_restore.sh

########################################################################################################################
# supervised
pacman -Sy --noconfirm supervisor
mkdir -p /etc/supervisor.d
echo_supervisord_conf > /etc/supervisord.conf
echo "[include]
files = /etc/supervisor.d/*.conf" >> /etc/supervisord.conf


cat <<EOT > /etc/supervisor.d/chain.conf
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

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/snapshot_cronjob.sh" > $HOME/snapshot_cronjob.sh

# pick a random hour and minute to take snapshot
snapshot_time_hour=$(( ${RANDOM} % 24 ))
snapshot_time_minute=$(( ${RANDOM} % 60 ))

# weekly snapshot if it is archive node
snapshot_day="*"
[[ -z $snapshot_prune ]] && snapshot_day=$(( ${snapshot_time_hour} % 6 ))
echo "$snapshot_time_minute $snapshot_time_hour * * $snapshot_day root /usr/bin/flock -n /var/run/lock/snapshot_cronjob.lock /bin/bash $HOME/snapshot_cronjob.sh" > /etc/cron.d/cron_snapshot

# start crond
crond

loop_forever