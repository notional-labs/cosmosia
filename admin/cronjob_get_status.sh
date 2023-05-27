
cd $HOME/cosmosia/admin

rpc_service_verions=$(curl -sG -XGET http://tasks.web_config:2375/services --data-urlencode 'filters={"label":["cosmosia.service=rpc"]}' |jq -r '.[].Spec.Name')
RPC_SERVICES="${rpc_service_verions}"
# echo "RPC_SERVICES=$RPC_SERVICES"


#TMP_DIR="$HOME/tmp"
TMP_DIR="./web/public"
TMP_STATUS_FILE="$TMP_DIR/rpc_status.json"
#mkdir -p $TMP_DIR

service_str=""
for service_name in $RPC_SERVICES; do
  ips=$(dig +short "tasks.$service_name" |sort)

  tmp_str=""
  while read -r ip_addr || [[ -n $ip_addr ]]; do
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 3 "http://$ip_addr/healthcheck")
    data_size=$(curl -s "http://$ip_addr/data_size" |jq -r .data_size)

    # figure out hostname of container
    hostname=$(dig +short -x $ip_addr)

    if [[ ! -z "$tmp_str" ]]; then
      tmp_str="$tmp_str,"$'\n'
    fi
    tmp_str="$tmp_str""    { \"ip\": \"$ip_addr\", \"hostname\": \"$hostname\", \"status\": \"$status_code\", \"data_size\": \"$data_size\" }"

  done < <(echo "$ips")

  if [[ ! -z "$service_str" ]]; then
    service_str="$service_str,"$'\n'
  fi
  service_str="$service_str { \"service\": \"$service_name\", \"containers\": [ $tmp_str ] }"
done

echo "[ $service_str ]" > $TMP_STATUS_FILE
