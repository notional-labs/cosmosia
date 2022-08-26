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
pacman -S --noconfirm base-devel jq dnsutils python caddy screen wget cronie

CONFIG_FILE="/etc/caddy/Caddyfile"
TMP_CONFIG_FILE="/etc/caddy/Caddyfile.tmp"

########################################################################################################################
# cron

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/118-put-update-upstream-for-load-balancer-into-a-cronjob/load_balancer/generate_upstream.sh" > $HOME/generate_upstream.sh

cat <<'EOT' >  $HOME/cron_update_upstream.sh
source $HOME/generate_upstream.sh

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

sleep 1
echo "*/5 * * * * root /bin/bash $HOME/cron_update_upstream.sh" > /etc/cron.d/cron_update_upstream
sleep 1
crond

########################################################################################################################
# caddy

# generate new config file and copy to $CONFIG_FILE
source $HOME/cron_update_upstream.sh
cat $TMP_CONFIG_FILE > $CONFIG_FILE

# replace version v2.5.1 (https://github.com/notional-labs/cosmosia/issues/79)
wget -O - "https://github.com/notional-labs/cosmosia/files/9185123/caddy_v2.5.1.tar.gz" |tar -xzf - -C /usr/sbin/

screen -S caddy -dm /usr/sbin/caddy run --config $CONFIG_FILE
sleep 5

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done

