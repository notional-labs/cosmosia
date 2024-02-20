# usage: ./snapshost_run.sh chain_name
# eg., ./snapshost_run.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./snapshost_run.sh cosmoshub"
  loop_forever
fi

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

get_docker_snapshot_config () {
  str_snapshot_cfg="$(curl -s "http://tasks.web_config/config/cosmosia.snapshot.${chain_name}" |sed 's/ = /=/g')"
  echo $str_snapshot_cfg
}

echo "#################################################################################################################"
echo "read chain info:"
# https://www.medo64.com/2018/12/extracting-single-ini-section-via-bash/

# to get the url to the config file
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

echo "config=$config"
# load config
eval "$(curl -s "$config" |sed 's/ = /=/g')"

str_snapshot_cfg=$(get_docker_snapshot_config)
echo "str_snapshot_cfg=${str_snapshot_cfg}"
eval "${str_snapshot_cfg}"

# figure out IP of the snapshot_storage_node
snapshot_storage_node_ip=$(curl -s "http://tasks.web_config/node_ip/${snapshot_storage_node}")

# fix injective close-source
if [[ $git_repo == "https://github.com/InjectiveLabs/injective-core" ]]; then
  gh_access_token="$(curl -s "http://tasks.web_config/config/gh_access_token")"
  git_repo="https://${gh_access_token}@github.com/InjectiveLabs/injective-core"
fi


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
snapshot_storage_node_ip="$snapshot_storage_node_ip"
snapshot_prune="$snapshot_prune"
db_backend="$db_backend"
go_version="$go_version"
EOT

if [ $( echo "${chain_name}" | egrep -c "agoric" ) -eq 0 ]; then
  cat <<EOT >> $HOME/env.sh
# fix agoric
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh" # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOT
fi

if [[ -z $version ]]; then
  echo "No version found, exit!"
  loop_forever
fi

cd $HOME
pacman -Syu --noconfirm
pacman -Sy --noconfirm git base-devel wget pigz jq dnsutils inetutils python python-pip cronie spawn-fcgi fcgiwrap openssh

echo "#################################################################################################################"
echo "install go..."

if [[ -z $go_version ]]; then
  echo "No go version defined, install with package manager"
  pacman -Sy --noconfirm go
else
  echo "installing go version ${go_version}"
  wget -O - "https://go.dev/dl/${go_version}.linux-amd64.tar.gz" |pigz -dc |tar -xf - -C /usr/lib/
fi

export GOPATH="$HOME/go"
export GOROOT="/usr/lib/go"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOROOT}/bin:${GOBIN}"
export GOROOT_BOOTSTRAP=$GOROOT

mkdir -p $GOBIN

#use_gvm=false
## use gvm for cosmoshub for go1.18
#if [ $( echo "${chain_name}" | egrep -c "^(cosmoshub|cosmoshub-archive-sub)$" ) -ne 0 ]; then
#  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
#  source /root/.gvm/scripts/gvm
#  gvm install go1.18.10
#  gvm use go1.18.10 --default
#  use_gvm=true
#fi


echo "#################################################################################################################"
echo "openssh..."

mkdir -p $HOME/.ssh
curl -Ls http://tasks.web_config/config/cosmosia.id_rsa.pub > $HOME/.ssh/id_rsa.pub
curl -Ls http://tasks.web_config/config/cosmosia.id_rsa > $HOME/.ssh/id_rsa

chmod -R 700 ~/.ssh

echo "#################################################################################################################"
sleep 5

# start_chain.sh script
cat <<EOT > $HOME/start_chain.sh
source $HOME/env.sh
# fix supervisorctl creates a dbus-daemon process everytime starting chain
killall dbus-daemon
$HOME/go/bin/$daemon_name start $start_flags 1>&2
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
stderr_logfile_backups=10
stdout_logfile_backups=10
stderr_logfile_maxbytes=50MB
stdout_logfile_maxbytes=50MB
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



# restart cronjob
cat <<EOT > $HOME/restart_cronjob.sh
echo "Checking chain"
status=\$(/usr/sbin/supervisorctl status chain 2>&1)
echo "\$status"
if [[ "\$status" == *RUNNING* ]]; then
	echo "Restarting chain"
	/usr/sbin/supervisorctl stop chain
	sleep 60
	/usr/sbin/supervisorctl start chain
fi
EOT

echo "$snapshot_time_minute */7 * * * root /bin/bash $HOME/restart_cronjob.sh" > /etc/cron.d/cron_restart_chain



# start crond
crond

loop_forever