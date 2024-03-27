# usage: ./run.sh rpc_service_name
# eg., ./run.sh rpc_cosmoshub_3

rpc_service_name="$1"
echo "rpc_service_name=$rpc_service_name"
if [[ -z $rpc_service_name ]]; then
  echo "No rpc_service_name"
  exit
fi

cd $HOME

pacman -Syu --noconfirm
pacman -S --noconfirm base-devel jq dnsutils python haproxy screen wget cronie

# write env vars to bash file, so that cronjobs or other scripts could know
cat <<EOT >> $HOME/env.sh
rpc_service_name="$rpc_service_name"
EOT

source $HOME/env.sh

########################################################################################################################
# haproxy

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/573-rpc-store-chain-data-on-mount-volume/load_balancer/haproxy/haproxy.cfg" > $HOME/haproxy.cfg

# enable eth for needed chains by appending haproxy.eth.cfg to haproxy.cfg
if [[ $rpc_service_name == rpc_evmos* ]]; then
  curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/573-rpc-store-chain-data-on-mount-volume/load_balancer/haproxy/haproxy.eth.cfg" >> $HOME/haproxy.cfg
fi


curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/573-rpc-store-chain-data-on-mount-volume/load_balancer/haproxy/start.sh" > $HOME/start.sh
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/573-rpc-store-chain-data-on-mount-volume/load_balancer/haproxy/reload.sh" > $HOME/reload.sh

source $HOME/reload.sh

########################################################################################################################
# cron

########################################################################################################################
# cgi-script api
pacman -S --noconfirm nginx spawn-fcgi fcgiwrap
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/573-rpc-store-chain-data-on-mount-volume/load_balancer/nginx.conf" > /etc/nginx/nginx.conf
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/573-rpc-store-chain-data-on-mount-volume/load_balancer/api_upstream.sh" > /usr/share/nginx/html/api_upstream.sh
chmod +x /usr/share/nginx/html/api_upstream.sh
spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap
/usr/sbin/nginx


########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done

