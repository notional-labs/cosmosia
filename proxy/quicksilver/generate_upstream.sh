SERVICES="cosmoshub osmosis stargaze regen"

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

EOT
  fi
done

sleep 1
