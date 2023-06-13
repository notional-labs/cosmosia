# usage: ./run.sh chain_name
# eg., ./run.sh cosmoshub

chain_name="$1"
rpc_service_name="$2"

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./run.sh cosmoshub"
  exit
fi

[[ -z $rpc_service_name ]] && rpc_service_name="$chain_name"

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

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

# write env vars to bash file, so that cronjobs or other scripts could know
cat <<EOT >> $HOME/env.sh
chain_name="$chain_name"
git_repo="$git_repo"
version="$version"
daemon_name="$daemon_name"
node_home="$node_home"
minimum_gas_prices="$minimum_gas_prices"
start_flags="$start_flags"
EOT

pacman -Syu --noconfirm
pacman -Sy --noconfirm go git base-devel wget pigz jq python python-pip cronie nginx spawn-fcgi fcgiwrap dnsutils inetutils

########################################################################################################################
# restore snapshot
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/snapshot_restore.sh" > $HOME/snapshot_restore.sh
cd $HOME
source $HOME/snapshot_restore.sh

# enable statesync for pruned rpc node only
if [ $( echo "${chain_name}" | egrep -c "archive" ) -eq 0 ]; then
  # except these chains (https://github.com/notional-labs/cosmosia/issues/297)
  if [ $( echo "${chain_name}" | egrep -c "^(irisnet)$" ) -ne 0 ]; then
    sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = 14400/" $node_home/config/app.toml
    sed -i -e "s/^snapshot-keep-recent *=.*/snapshot-keep-recent = 2/" $node_home/config/app.toml
  fi
fi

########################################################################################################################
# supervised
pacman -Sy --noconfirm supervisor
mkdir -p /etc/supervisor.d
echo_supervisord_conf > /etc/supervisord.conf
echo "[include]
files = /etc/supervisor.d/*.conf" >> /etc/supervisord.conf


# start_chain.sh script
cat <<EOT >> $HOME/start_chain.sh
source $HOME/env.sh
# fix supervisorctl creates a dbus-daemon process everytime starting chain
killall dbus-daemon
$HOME/go/bin/$daemon_name start --db_backend=pebbledb $start_flags
EOT


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

echo "#################################################################################################################"
echo "start nginx..."
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/nginx.conf" > /etc/nginx/nginx.conf
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/healthcheck.sh" > /usr/share/nginx/html/healthcheck.sh
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/data_size.sh" > /usr/share/nginx/html/data_size.sh
chmod +x /usr/share/nginx/html/healthcheck.sh
chmod +x /usr/share/nginx/html/data_size.sh
spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap
/usr/sbin/nginx

echo "#################################################################################################################"
echo "start chain..."
supervisorctl start chain

########################################################################################################################
# cron

# pick a random minute to restart service
random_minute=$(( ${RANDOM} % 59 ))

cat <<EOT > $HOME/restart_cronjob.sh
/usr/sbin/supervisorctl stop chain
sleep 20
/usr/sbin/supervisorctl start chain
EOT

#if [ $( echo "${chain_name}" | egrep -c "^(akash|bandchain|evmos|evmos-archive|evmos-testnet-archive|kava|provenance|persistent|quicksilver|regen|sei|terra|umee|kujira|stride|whitewhale|injective|sei-testnet)$" ) -ne 0 ]; then
echo "$random_minute */7 * * * root /bin/bash $HOME/restart_cronjob.sh" > /etc/cron.d/cron_restart_chain

crond
# fi

loop_forever
