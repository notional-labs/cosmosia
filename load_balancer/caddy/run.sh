# usage: ./run.sh chain_name scale
# eg., ./run.sh cosmoshub 2

chain_name="$1"
scale="$2"
echo "chain_name=$chain_name, scale=$scale"
if [[ -z $chain_name ]]; then
  echo "No chain_name. Exit"
  exit
fi

if [[ -z $scale ]]; then
  echo "No scale. Exit"
  exit
fi

cd $HOME

pacman -Syu --noconfirm
pacman -S --noconfirm base-devel jq dnsutils python caddy screen wget cronie

# write env vars to bash file, so that cronjobs or other scripts could know
cat <<EOT >> $HOME/env.sh
CONFIG_FILE="/etc/caddy/Caddyfile"
TMP_CONFIG_FILE="/etc/caddy/Caddyfile.tmp"
chain_name="$chain_name"
scale=$scale
EOT

source $HOME/env.sh

########################################################################################################################
# cron

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/573-rpc-store-chain-data-on-mount-volume/load_balancer/caddy/generate_upstream.sh" > $HOME/generate_upstream.sh

cat <<'EOT' >  $HOME/cron_update_upstream.sh
source $HOME/env.sh
source $HOME/generate_upstream.sh $chain_name $scale

if cmp -s "$CONFIG_FILE" "$TMP_CONFIG_FILE"; then
  # the same => do nothing
  echo "no config change, do nothing..."
else
  # different

  # show the diff
  diff -c "$CONFIG_FILE" "$TMP_CONFIG_FILE"

  echo "found config changes, updating..."
  cat "$TMP_CONFIG_FILE" > "$CONFIG_FILE"
  /usr/sbin/caddy reload --config $CONFIG_FILE
fi
EOT

echo "*/5 * * * * root /bin/bash $HOME/cron_update_upstream.sh" > /etc/cron.d/cron_update_upstream
crond

########################################################################################################################
# caddy

# generate new config file and copy to $CONFIG_FILE
source $HOME/cron_update_upstream.sh
cat $TMP_CONFIG_FILE > $CONFIG_FILE

screen -S caddy -dm /usr/sbin/caddy run --config $CONFIG_FILE
sleep 5


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

