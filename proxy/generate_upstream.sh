SERVICES=$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |grep -E "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')


UPSTREAM_CONFIG_FILE="/etc/nginx/upstream.conf"
UPSTREAM_CONFIG_FILE_TMP="/etc/nginx/upstream.conf.tmp"

# generate upstream.conf
echo "" > $UPSTREAM_CONFIG_FILE_TMP
for service_name in $SERVICES; do
  lb_ip=$(dig +short "tasks.lb_$service_name")
  if [[ -z "$lb_ip" ]]; then
    lb_ip="127.0.0.1"
  fi
  cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
    upstream backend_rpc_$service_name {
        keepalive 16;
        server $lb_ip:8000;
    }

    upstream backend_api_$service_name {
        keepalive 16;
        server $lb_ip:8001;
    }

    upstream backend_grpc_$service_name {
        keepalive 16;
        server $lb_ip:8003;
    }
EOT
done

sleep 1
########################################################################################################################
SERVICES_JSONRPC="evmos evmos-testnet-archive evmos-archive"

for service_name in $SERVICES_JSONRPC; do
  lb_ip=$(dig +short "tasks.lb_$service_name")
  if [[ -z "$lb_ip" ]]; then
    lb_ip="127.0.0.1"
  fi
  cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
    upstream backend_jsonrpc_$service_name {
        keepalive 16;
        server $lb_ip:8004;
    }

    upstream backend_wsjsonrpc_$service_name {
        keepalive 16;
        server $lb_ip:8005;
    }
EOT
done

sleep 1
########################################################################################################################
SERVICES_SUBNODE="osmosis juno cosmoshub"
for service_name in $SERVICES_SUBNODE; do
  lb_ip=$(dig +short "tasks.sub_$service_name")
  if [[ -z "$lb_ip" ]]; then
    lb_ip="127.0.0.1"
  fi
  cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
    upstream backend_rpc_sub_$service_name {
        keepalive 16;
        server $lb_ip:26657;
    }

    upstream backend_api_sub_$service_name {
        keepalive 16;
        server $lb_ip:1337;
    }

    upstream backend_grpc_sub_$service_name {
        keepalive 16;
        server $lb_ip:9090;
    }
EOT
done

sleep 1