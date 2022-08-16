SERVICES=$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |egrep -o "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')


UPSTREAM_CONFIG_FILE="/etc/nginx/upstream.conf"
UPSTREAM_CONFIG_FILE_TMP="/etc/nginx/upstream.conf.tmp"

# generate upstream.conf
echo "" > $UPSTREAM_CONFIG_FILE_TMP
for service_name in $SERVICES; do
  lb_ip=$(dig +short "tasks.lb_$service_name")
  if [[ ! -z "$lb_ip" ]]; then
    cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
      upstream backend_rpc_$service_name {
          keepalive 32;
          server tasks.lb_$service_name:8000;
      }

      upstream backend_grpc_$service_name {
          keepalive 32;
          server tasks.lb_$service_name:8003;
      }

EOT
  fi
done

sleep 1

# jsonrpc for evmos and evmos-testnet-archive
lb_ip=$(dig +short "tasks.lb_evmos")
if [[ ! -z "$lb_ip" ]]; then
  cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
    upstream backend_jsonrpc_evmos {
        keepalive 32;
        server tasks.lb_evmos:8004;
    }

    upstream backend_wsjsonrpc_evmos {
        keepalive 32;
        server tasks.lb_evmos:8005;
    }

EOT
fi

sleep 1

lb_ip=$(dig +short "tasks.lb_evmos-testnet-archive")
if [[ ! -z "$lb_ip" ]]; then
  cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
    upstream backend_jsonrpc_evmos-testnet-archive {
        keepalive 32;
        server tasks.lb_evmos-testnet-archive:8004;
    }

    upstream backend_wsjsonrpc_evmos-testnet-archive {
        keepalive 32;
        server tasks.lb_evmos-testnet-archive:8005;
    }

EOT
fi
