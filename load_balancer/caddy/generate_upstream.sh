# usage: ./generate_upstream.sh chain_name scale
# eg., ./generate_upstream.sh cosmoshub 2

chain_name="$1"
scale=$2
echo "chain_name=$chain_name, scale=$scale"
if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./generate_upstream.sh cosmoshub 2"
  exit
fi

if [[ -z $scale ]]; then
  echo "No scale. usage eg., ./generate_upstream.sh cosmoshub 2"
  exit
fi

CONFIG_FILE="/etc/caddy/Caddyfile"
TMP_CONFIG_FILE="/etc/caddy/Caddyfile.tmp"

default_node="tasks.${chain_name}_1"

# figure out IPs of services
#new_ips=$(dig +short "tasks.$rpc_service_name" |sort)

new_ips=""
node_num=1
while [[ node_num -le scale ]]; do
  rpc_node="tasks.rpc_${chain_name}_${node_num}"
  ip=$(dig +short "$rpc_node")
#  echo "ip of $rpc_node is $ip"

  if [[ ! -z $new_ips ]]; then
    new_ips="${new_ips}"$'\n'
  fi
  new_ips="${new_ips}${ip}"

  ((node_num++));
done

#echo "$new_ips"

rpc_str=""
api_str=""
ws_str=""
grpc_str=""
jsonrpc_str=""
ws_jsonrpc_str=""
if [[ -z "$new_ips" ]]; then
    rpc_str="to http://$default_node:26657"
    api_str="to http://$default_node:1317"
    ws_str="to http://$default_node:26657"
    grpc_str="to http://$default_node:9090"
    jsonrpc_str="to http://$default_node:8545"
    ws_jsonrpc_str="to http://$default_node:8546"
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
if [[ $chain_name == evmos* ]]; then
  JSONRPC_CONFIG=$( cat <<EOT
#JSON-RPC
:8004 {
  reverse_proxy {
    $jsonrpc_str
    health_uri      /healthcheck
    health_port     80
    health_interval 10s
    health_timeout  5s
  }
}

#WS-JSON-RPC
:8005 {
  reverse_proxy {
    $ws_jsonrpc_str
    health_uri      /healthcheck
    health_port     80
    health_interval 10s
    health_timeout  5s
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
    health_interval 10s
    health_timeout  5s
  }
}

#API
http://:8001 {
  reverse_proxy /* {
    $api_str
    health_uri      /healthcheck
    health_port     80
    health_interval 10s
    health_timeout  5s
  }
}

#WS
http://:8002 {
  rewrite * /websocket
    reverse_proxy {
      $ws_str
      health_uri      /healthcheck
      health_port     80
      health_interval 10s
      health_timeout  5s
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
