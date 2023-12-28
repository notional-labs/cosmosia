source $HOME/env.sh

# 12 hours
THRESHOLD_TIME=43200

URL="https://status.notional.ventures/ibc_monitor/get_last_ibc_client_update?hermes_config_url=https%3A%2F%2Fraw.githubusercontent.com%2Fnotional-labs%2Fcosmosia%2Fmain%2Frelaying%2F${hubname}_config.toml"
items=$(curl -s "$URL" |jq -c -r '.[]')

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
    if [[ ${BLOCK_AGE} -gt ${THRESHOLD_TIME} ]]; then
      echo "chain_id=$chain_id, channel_id=$channel_id, block_time=$block_time block_time is more than $THRESHOLD_TIME seconds ago => update client."
      $HOME/.hermes/bin/hermes update client --host-chain $chain_id --client $client_id
    fi
  fi
done