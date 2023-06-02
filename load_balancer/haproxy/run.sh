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
CHAIN_REGISTRY_INI_URL="$CHAIN_REGISTRY_INI_URL"
rpc_service_name="$rpc_service_name"
EOT

source $HOME/env.sh

########################################################################################################################
# haproxy

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/load_balancer/haproxy/haproxy.cfg" > /etc/haproxy/haproxy.cfg
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/load_balancer/haproxy/start.sh" > $HOME/start.sh
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/load_balancer/haproxy/reload.sh" > $HOME/reload.sh

source $HOME/start.sh

########################################################################################################################
# cron

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done

