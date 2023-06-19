
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
