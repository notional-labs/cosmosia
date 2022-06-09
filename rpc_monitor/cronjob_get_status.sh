
cd $HOME/cosmosia/rpc_monitor

RPC_SERVICES=$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |egrep -o "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')

rpc_service_verions=$(curl -sG -XGET http://tasks.web_config:2375/services --data-urlencode 'filters={"label":["cosmosia.service=rpc"]}' |jq -r '.[].Spec.Name')
RPC_SERVICES="${RPC_SERVICES}"$'\n'"${rpc_service_verions}"
# echo "RPC_SERVICES=$RPC_SERVICES"


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

    # figure out hostname of container
    hostname=$(dig +short -x $ip_addr)

    if [[ ! -z "$tmp_str" ]]; then
      tmp_str="$tmp_str,"$'\n'
    fi
    tmp_str="$tmp_str""    { \"ip\": \"$ip_addr\", \"hostname\": \"$hostname\", \"status\": \"$status_code\" }"

  done < <(echo "$ips")

  if [[ ! -z "$service_str" ]]; then
    service_str="$service_str,"$'\n'
  fi
  service_str="$service_str { \"service\": \"$service_name\", \"containers\": [ $tmp_str ] }"
done

echo "[ $service_str ]" > $TMP_STATUS_FILE
