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


##########################
# supervised
pacman -Syu --noconfirm python python-pip
pip install supervisor
mkdir -p /etc/supervisor/conf.d
echo_supervisord_conf > /etc/supervisor/supervisord.conf
echo "[include]
files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf


PROGRAM_CONF="/etc/supervisor/conf.d/chain.conf"

cat <<EOT >> $PROGRAM_CONF
[program:chain]
command=/root/start_chain.sh
autostart=false
autorestart=false
stderr_logfile=/var/log/chain.err.log
stdout_logfile=/var/log/chain.out.log
EOT



supervisord



#echo "#################################################################################################################"
#echo "waiting until chain get synced..."
#
#catching_up=true
#while [[ "catching_up" == "true" ]]; do
#  sleep 60;
#  catching_up=$(curl --silent --max-time 3 "http://localhost:26657/status" |jq -r .result.sync_info.catching_up)
#  echo "catching_up=$catching_up"
#done

supervisorctl start chain



# loop forever for debugging only
while true; do sleep 5; done