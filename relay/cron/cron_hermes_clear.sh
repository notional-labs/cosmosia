########################################################################################################################
# make sure single instance running
PIDFILE="$HOME/cron_hermes_clear.sh.lock"
function cleanup() {
  rm -f $PIDFILE
}

if [ -f $PIDFILE ]; then
   pid=$(cat $PIDFILE)
   if kill -0 $pid 2>/dev/null; then
      echo "Script is already running"
      exit 1
   fi
fi

echo $$ > $PIDFILE
trap cleanup EXIT
########################################################################################################################


source $HOME/env.sh

URL="https://status.notional.ventures/ibc_monitor/get_last_ibc_client_update?hermes_config_url=https%3A%2F%2Fraw.githubusercontent.com%2Fnotional-labs%2Fcosmosia%2Fmain%2Frelay%2F${hubname}_config.toml"
items=$(curl -s "$URL" |jq -c -r '.[]')

echo "$items" | while IFS= read -r item ; do
  chain_id=$(echo "$item" |jq -r .chain_id)
  client_id=$(echo $item |jq -r .client_id)
  block_time=$(echo $item |jq -r .block_time)
  channel_id=$(echo $item |jq -r .channel_id)
  counter_chain_id=$(echo $item |jq -r .counter_chain_id)
  latest_height=$(echo $item |jq -r .latest_height)
  time_ago=$(echo $item |jq -r .time_ago)
  port=$(echo "$item" |jq -r .port)

  echo "hermes clear packets ${chain_id}/${channel_id}"
  $HOME/.hermes/bin/hermes clear packets --chain $chain_id --port $port --channel $channel_id
done