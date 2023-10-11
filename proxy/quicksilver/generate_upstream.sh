SERVICES="quicksilver cosmoshub osmosis stargaze regen juno akash evmos kichain injective umee kujira crescent mars axelar terra2 sommelier cosmoshub-testnet stargaze-testnet evmos-testnet crescent-testnet regen-testnet terra2-testnet injective-testnet"

UPSTREAM_CONFIG_FILE="/etc/nginx/upstream.conf"
UPSTREAM_CONFIG_FILE_TMP="/etc/nginx/upstream.conf.tmp"

# generate upstream.conf
echo "" > $UPSTREAM_CONFIG_FILE_TMP
for service_name in $SERVICES; do
  lb_ip=$(dig +short "tasks.lb_$service_name")
  if [[ ! -z "$lb_ip" ]]; then
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
  fi
done

sleep 1
