#!/bin/bash

# cgi-script
# url: /api_upstream?rpc_service_name=rpc_cosmoshub_6

echo "Status: 200"
echo "Content-type:text/plain"
echo ""
# echo "QUERY_STRING=${QUERY_STRING}"

declare -a pairs
IFS='&' read -ra pairs <<<"${QUERY_STRING}"

declare -A values
for pair in "${pairs[@]}"; do
    IFS='=' read -r key value <<<"$pair"
    values["$key"]="$value"
done

rpc_service_name="${values[rpc_service_name]}"

if [[ -z "${rpc_service_name}" ]]; then
  echo "no rpc_service_name. Do nothing."
  exit
fi

echo "rpc_service_name=${rpc_service_name}"
echo "reloading..."

sed -i -e "s/^rpc_service_name*=.*/rpc_service_name=\"${rpc_service_name}\"/" $HOME/env.sh

# for haproxy
if [ -f "$HOME/reload.sh" ]; then
  source $HOME/reload.sh
fi

# for caddy
if [ -f "$HOME/cron_update_upstream.sh" ]; then
  source $HOME/cron_update_upstream.sh
fi