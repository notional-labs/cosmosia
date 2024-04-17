
########################################################################################################################
# make sure single instance running
PIDFILE="$HOME/cronjob_get_status.sh.lock"
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

rpc_service_verions=$(curl -sG -XGET http://tasks.web_config:2375/services --data-urlencode 'filters={"label":["cosmosia.service=rpc"]}' |jq -r '.[].Spec.Name')
RPC_SERVICES="${rpc_service_verions}"
# echo "RPC_SERVICES=$RPC_SERVICES"

service_str=""
for service_name in $RPC_SERVICES; do
  ips=$(dig +short "tasks.$service_name" |sort)

  while read -r ip_addr || [[ -n $ip_addr ]]; do
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 3 "http://$ip_addr/healthcheck")
    data_size=$(curl -s --connect-timeout 3 --max-time 3 "http://$ip_addr/data_size" |jq -r .data_size)

    # figure out hostname of container
    hostname=$(dig +short -x $ip_addr)

    if [[ ! -z "$service_str" ]]; then
      service_str="$service_str,"$'\n'
    fi
    service_str="$service_str""    { \"ip\": \"$ip_addr\", \"hostname\": \"$hostname\", \"status\": \"$status_code\", \"data_size\": \"$data_size\" }"

  done < <(echo "$ips")

  sleep 0.5
done

echo "[ $service_str ]" > ./web/public/rpc_status.json
