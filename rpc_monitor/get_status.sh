
RPC_SERVICES="osmosis starname regen akash cosmoshub sentinel emoney ixo juno sifchain likecoin kichain cyber cheqd stargaze bandchain chihuahua kava bitcanna konstellation omniflixhub terra vidulum provenance dig gravitybridge"

TMP_DIR="$HOME/tmp"
TMP_STATUS_FILE="$TMP_DIR/status.json"

mkdir -p $TMP_DIR

echo "{" > $TMP_STATUS_FILE
for service_name in $RPC_SERVICES; do
  echo "\"$service_name\": {" >> $TMP_STATUS_FILE

  ips=$(dig +short "tasks.$service_name" |sort)

  tmp_str=""
  while read -r ip_addr || [[ -n $ip_addr ]]; do
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 3 "http://$ip_addr/healthcheck")

    if [[ ! -z "$tmp_str" ]]; then
      tmp_str="$tmp_str,"$'\n'
    fi
    tmp_str="$tmp_str""    \"$ip_addr\": $status_code"

  done < <(echo "$ips")

  echo "$tmp_str" >> $TMP_STATUS_FILE

  echo "}" >> $TMP_STATUS_FILE
done

echo "}" >> $TMP_STATUS_FILE