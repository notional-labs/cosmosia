########################################################################################################################
# make sure single instance running
PIDFILE="$HOME/cron_update_client.sh.lock"
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

# 12 hours
DEFAULT_THRESHOLD_TIME=43200
URL="https://status.notional.ventures/ibc_monitor/get_last_ibc_client_update?hermes_config_url=https%3A%2F%2Fraw.githubusercontent.com%2Fnotional-labs%2Fcosmosia%2Fmain%2Frelay%2F${hubname}_config.toml"
items=$(curl -s "$URL" |jq -c -r '.[]')

TESTNETS="(testnet|narwhal-2|osmo-test-5|theta-testnet-001)"

echo "$items" | while IFS= read -r item ; do
  chain_id=$(echo "$item" |jq -r .chain_id)
  client_id=$(echo $item |jq -r .client_id)
  block_time=$(echo $item |jq -r .block_time)
  channel_id=$(echo $item |jq -r .channel_id)
  counter_chain_id=$(echo $item |jq -r .counter_chain_id)
  latest_height=$(echo $item |jq -r .latest_height)
  time_ago=$(echo $item |jq -r .time_ago)

  if [[ ! -z "$block_time" ]]; then
    BLOCKCHAIN_SECS=`date -d $block_time +%s`
    CURRENT_SECS=`date +%s`
    BLOCK_AGE=$((${CURRENT_SECS} - ${BLOCKCHAIN_SECS}))

    threshold_time=DEFAULT_THRESHOLD_TIME

    # 1 hour for axelar
    if [ $( echo "${chain_id}" | grep -cE "^(axelar-dojo-1)$" ) -ne 0 ] || [ $( echo "${counter_chain_id}" | grep -cE "^(axelar-dojo-1)$" ) -ne 0 ] ; then
      threshold_time=3600
    fi

    # 1 hour for testnet, but we dont know if its a testnet based on chain-id, so have to make a list
    if [ $( echo "${chain_id}" | grep -cE $TESTNETS ) -ne 0 ] || [ $( echo "${counter_chain_id}" | grep -cE $TESTNETS ) -ne 0 ] ; then
      threshold_time=3600
    fi

    if [[ ${BLOCK_AGE} -gt ${threshold_time} ]]; then
      echo "chain_id=$chain_id, channel_id=$channel_id, block_time=$block_time block_time is more than $threshold_time seconds ago => update client."
      $HOME/.hermes/bin/hermes update client --host-chain $chain_id --client $client_id
    fi
  fi
done