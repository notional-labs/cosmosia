if [[ -z "$CHAIN_REGISTRY_INI_URL" ]]; then
  echo "no env var CHAIN_REGISTRY_INI_URL. Make sure put it into \$HOME/env.sh"
  exit
fi

# SERVICES=$(curl -s "$CHAIN_REGISTRY_INI_URL" |grep -E "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')
SERVICES=$(cat <<-END
composable
composable-testnet
quicksilver
whitewhale-testnet
whitewhale
END
)


UPSTREAM_CONFIG_FILE="/etc/nginx/upstream.conf"
UPSTREAM_CONFIG_FILE_TMP="/etc/nginx/upstream.conf.tmp"

# generate upstream.conf
echo "" > $UPSTREAM_CONFIG_FILE_TMP
for service_name in $SERVICES; do
  gw_ip=$(dig +short "tasks.napigw_$service_name")
  if [[ -z "$gw_ip" ]]; then
    gw_ip="127.0.0.1"
  fi
  cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
    upstream backend_rpc_$service_name {
        keepalive 16;
        server $gw_ip:26657;
    }

    upstream backend_wsrpc_$service_name {
        keepalive 16;
        server $gw_ip:26658;
    }

    upstream backend_api_$service_name {
        keepalive 16;
        server $gw_ip:1317;
    }

    upstream backend_grpc_$service_name {
        keepalive 16;
        server $gw_ip:9090;
    }
EOT

  sleep 0.5
done

sleep 1
########################################################################################################################
SERVICES_JSONRPC="evmos evmos-testnet"

for service_name in $SERVICES_JSONRPC; do
  gw_ip=$(dig +short "tasks.napigw_$service_name")
  if [[ -z "$gw_ip" ]]; then
    gw_ip="127.0.0.1"
  fi
  cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
    upstream backend_jsonrpc_$service_name {
        keepalive 16;
        server $gw_ip:8545;
    }

    upstream backend_wsjsonrpc_$service_name {
        keepalive 16;
        server $gw_ip:8546;
    }
EOT
done

sleep 1
########################################################################################################################
SERVICES_SUBNODE="cosmoshub evmos"
for service_name in $SERVICES_SUBNODE; do
  gw_ip=$(dig +short "tasks.napigw_sub_$service_name")
  if [[ -z "$gw_ip" ]]; then
    gw_ip="127.0.0.1"
  fi
  cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
    upstream backend_rpc_sub_$service_name {
      keepalive 16;
      server $gw_ip:26657;
    }
    upstream backend_api_sub_$service_name {
       keepalive 16;
       server $gw_ip:1317;
    }
    upstream backend_grpc_sub_$service_name {
       keepalive 16;
       server $gw_ip:9090;
    }
EOT

  if [[ $service_name == evmos* ]]; then
    cat <<EOT >> $UPSTREAM_CONFIG_FILE_TMP
      upstream backend_jsonrpc_sub_$service_name {
        keepalive 16;
        server $gw_ip:8545;
      }
      upstream backend_wsjsonrpc_sub_$service_name {
        keepalive 16;
        server $gw_ip:8546;
      }
EOT
  fi

done

sleep 1