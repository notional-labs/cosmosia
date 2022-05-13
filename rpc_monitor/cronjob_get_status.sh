
cd $HOME/cosmosia/rpc_monitor

RPC_SERVICES=$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |egrep -o "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')
#TMP_DIR="$HOME/tmp"
TMP_DIR="./web/build"
TMP_STATUS_FILE="$TMP_DIR/status.json"
#mkdir -p $TMP_DIR

service_str=""
for service_name in $RPC_SERVICES; do
  ips=$(dig +short "tasks.$service_name" |sort)

  tmp_str=""
  while read -r ip_addr || [[ -n $ip_addr ]]; do
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 3 "http://$ip_addr/healthcheck")

    if [[ ! -z "$tmp_str" ]]; then
      tmp_str="$tmp_str,"$'\n'
    fi
    tmp_str="$tmp_str""    { \"ip\": \"$ip_addr\", \"status\": \"$status_code\" }"

  done < <(echo "$ips")

  if [[ ! -z "$service_str" ]]; then
    service_str="$service_str,"$'\n'
  fi
  service_str="$service_str { \"service\": \"$service_name\", \"containers\": [ $tmp_str ] }"
done

echo "[ $service_str ]" > $TMP_STATUS_FILE
