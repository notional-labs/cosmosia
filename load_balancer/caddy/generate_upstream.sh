# usage: ./generate_upstream.sh rpc_service_name
# eg., ./generate_upstream.sh rpc_cosmoshub_0

rpc_service_name="$1"
echo "rpc_service_name=$rpc_service_name"
if [[ -z $rpc_service_name ]]; then
  echo "No rpc_service_name. usage eg., ./generate_upstream.sh rpc_cosmoshub_0"
  exit
fi

CONFIG_FILE="/etc/caddy/Caddyfile"
TMP_CONFIG_FILE="/etc/caddy/Caddyfile.tmp"

# use dig to figure out IPs of service
new_ips=$(dig +short "tasks.$rpc_service_name" |sort)

rpc_str=""
api_str=""
ws_str=""
grpc_str=""
jsonrpc_str=""
ws_jsonrpc_str=""
if [[ -z "$new_ips" ]]; then
    rpc_str="to http://$rpc_service_name:26657"
    api_str="to http://$rpc_service_name:1317"
    ws_str="to http://$rpc_service_name:26657"
    grpc_str="to http://$rpc_service_name:9090"
    jsonrpc_str="to http://$rpc_service_name:8545"
    ws_jsonrpc_str="to http://$rpc_service_name:8546"
else
  while read -r ip_addr || [[ -n $ip_addr ]]; do
      if [[ -z "$rpc_str" ]]; then
        rpc_str="to"
        api_str="to"
        ws_str="to"
        grpc_str="to"
        jsonrpc_str="to"
        ws_jsonrpc_str="to"
      fi
      rpc_str="$rpc_str http://$ip_addr:26657"
      api_str="$api_str http://$ip_addr:1317"
      ws_str="$ws_str http://$ip_addr:26657"
      grpc_str="$grpc_str h2c://$ip_addr:9090"
      jsonrpc_str="$jsonrpc_str http://$ip_addr:8545"
      ws_jsonrpc_str="$ws_jsonrpc_str http://$ip_addr:8546"
  done < <(echo "$new_ips")
fi


JSONRPC_CONFIG=""
if [[ $rpc_service_name == rpc_evmos* ]]; then
  JSONRPC_CONFIG=$( cat <<EOT
#JSON-RPC
:8004 {
  reverse_proxy {
    $jsonrpc_str
    health_uri      /healthcheck
    health_port     80
    health_interval 30s
    health_timeout  30s
  }
}

#WS-JSON-RPC
:8005 {
  reverse_proxy {
    $ws_jsonrpc_str
    health_uri      /healthcheck
    health_port     80
    health_interval 30s
    health_timeout  30s
  }
}
EOT
  )
fi

cat <<EOT > $TMP_CONFIG_FILE
# This file is generated dynamically, dont edit.

{
  admin :2019
  servers {
    metrics
  }
  servers :8003 {
    metrics
    protocols h1 h2c
  }
}

# RPC
http://:8000 {
  reverse_proxy /* {
    $rpc_str
    health_uri      /healthcheck
    health_port     80
    health_interval 30s
    health_timeout  30s
  }
}

#API
http://:8001 {
  reverse_proxy /* {
    $api_str
    health_uri      /healthcheck
    health_port     80
    health_interval 30s
    health_timeout  30s
  }
}

#WS
http://:8002 {
  rewrite * /websocket
    reverse_proxy {
      $ws_str
      health_uri      /healthcheck
      health_port     80
      health_interval 30s
      health_timeout  30s
  }
}

#gRPC
:8003 {
  reverse_proxy {
    $grpc_str
  }
}

$JSONRPC_CONFIG
EOT
