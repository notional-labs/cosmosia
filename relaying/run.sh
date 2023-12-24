# usage: ./run.sh hubname
# eg., ./run.sh whitewhale

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

hubname="$1"
if [[ -z $hubname ]]; then
  echo "No hubname!"
  loop_forever
fi


pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel python python-pip cronie screen wget jq

# get hermes config
eval "$(curl -s "https://raw.githubusercontent.com/notional-labs/cosmosia/main/relaying/relayerhubs_registry.ini" |awk -v TARGET=$hubname -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ')"
echo "hermes_version=${hermes_version}"
if [[ -z $hermes_version ]]; then
  echo "No hermes_version!"
  loop_forever
fi

# write env vars to bash file, so that cronjobs or other scripts could know
cat <<EOT >> $HOME/env.sh
hermes_version="$hermes_version"
hubname="$hubname"
EOT


# install hermes
cd $HOME
mkdir -p $HOME/.hermes/bin
wget -O - "https://github.com/informalsystems/hermes/releases/download/${hermes_version}/hermes-${hermes_version}-x86_64-unknown-linux-gnu.tar.gz" |tar -xz -C $HOME/.hermes/bin/

# hermes config
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/relaying/${hubname}_config.toml" > $HOME/.hermes/config.toml
curl -Ls "http://tasks.web_config/config/cosmosia.relay.${hubname}.mnemonic.txt" > $HOME/.hermes/mnemonic.txt


chain_ids=$(cat $HOME/.hermes/config.toml |grep "id = " |sed -e "s/id = //g" -e "s/'//g" -e 's/"//g')
for chain_id in $chain_ids; do
  $HOME/.hermes/bin/hermes keys add --chain $chain_id --mnemonic-file $HOME/.hermes/mnemonic.txt
done

########################################################################################################################
# supervised
pacman -Sy --noconfirm supervisor
mkdir -p /etc/supervisor.d
echo_supervisord_conf > /etc/supervisord.conf
echo "[include]
files = /etc/supervisor.d/*.conf" >> /etc/supervisord.conf


cat <<EOT > /etc/supervisor.d/hermes.conf
[program:hermes]
command=/root/.hermes/bin/hermes start
autostart=false
autorestart=false
stopasgroup=true
killasgroup=true
stderr_logfile=/var/log/hermes.err.log
stdout_logfile=/var/log/hermes.out.log
stderr_logfile_backups=3
stdout_logfile_backups=3
stderr_logfile_maxbytes=50MB
stdout_logfile_maxbytes=50MB
EOT

supervisord

sleep 5
echo "start hermes..."
supervisorctl start hermes

################################################################################################
# cron

# cronjob to restart hermes
cat <<EOT > $HOME/restart_cronjob.sh
/usr/sbin/supervisorctl stop hermes
sleep 5
/usr/sbin/supervisorctl start hermes
EOT
echo "0 */7 * * * root /bin/bash $HOME/restart_cronjob.sh" > /etc/cron.d/cron_restart_chain


# cronjob to update client
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/relaying/cron_update_client.sh" > $HOME/cron_update_client.sh
echo "0 */12 * * * root /bin/bash $HOME/cron_update_client.sh" > /etc/cron.d/cron_update_clien

crond
################################################################################################
loop_forever