########################################################################################################################
# make sure single instance running
PIDFILE="$HOME/cronjob_get_snapshot_size.sh.lock"
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

RPC_SERVICES=$(curl -s "$CHAIN_REGISTRY_INI_URL" |grep -E "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')
#TMP_DIR="$HOME/tmp"
TMP_DIR="./web/build"
TMP_STATUS_FILE="$TMP_DIR/snapshot_sizes.json"
#mkdir -p $TMP_DIR

service_str=""
for service_name in $RPC_SERVICES; do
  file_size=$(curl -Ls "https://snapshot.${USE_DOMAIN_NAME}/$service_name/chain.json" |jq -r '.file_size')
  if [[ ! -z "$service_str" ]]; then
    service_str="$service_str,"$'\n'
  fi
  service_str="$service_str { \"service\": \"$service_name\", \"file_size\": \"$file_size\" }"
done

echo "[ $service_str ]" > $TMP_STATUS_FILE
