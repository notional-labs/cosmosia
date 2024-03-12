########################################################################################################################
# make sure single instance running
PIDFILE="$HOME/cronjob_get_val_status.sh.lock"
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

cd $HOME/cosmosia/admin

# define list of service we want to monitor here
chains="osmosis osmosis-testnet"

# each service has 2 val nodes for HA
chains_str=""
for chain in $chains; do
  nodes="val_${chain}-pruned_1 val_${chain}-pruned_2"
  node_str=""
  for node in $nodes; do
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 2 "http://tasks.${node}/healthcheck")
    data_size=$(curl -s "http://tasks.${node}/data_size" |jq -r .data_size)

    if [[ ! -z "$node_str" ]]; then
      node_str="$node_str,"$'\n'
    fi
    node_str="$node_str { \"node\": \"$node\", \"status\": \"$status_code\", \"data_size\": \"$data_size\" }"

    sleep 0.5
  done

  if [[ ! -z "$chains_str" ]]; then
    chains_str="$chains_str,"$'\n'
  fi
  chains_str="$chains_str { \"chain\": \"$chain\", \"nodes\": [ $node_str ] }"
done

echo "[ $chains_str ]" > ./web/public/val_status.json
