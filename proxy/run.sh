pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils nginx logrotate

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/98-keepalive-connections-to-upstream-servers/proxy/nginx.conf > /etc/nginx/nginx.conf

# generate index.html
SERVICES=$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |egrep -o "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')

get_links () {
  for service_name in $SERVICES; do
    echo "<p><a href=\"/${service_name}/\">$service_name</a></p>"
  done
}

links=$(get_links)

cat <<EOT > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cosmosia</title>
</head>

<body>
  <h3>RPC:</h3>
  ${links}
</body>
</html>
EOT


# generate upstream.conf
for service_name in $SERVICES; do
  echo "<p><a href=\"/${service_name}/\">$service_name</a></p>"
  cat <<EOT >> /etc/nginx/upstream.conf
    upstream backend_rpc_$service_name {
        keepalive 32;
        server tasks.lb_$service_name:8000;
    }

    upstream backend_jsonrpc_$service_name {
        keepalive 32;
        server tasks.lb_$service_name:8004;
    }

    upstream backend_wsjsonrpc_$service_name {
        keepalive 32;
        server tasks.lb_$service_name:8005;
    }

    upstream backend_grpc_$service_name {
        keepalive 32;
        server tasks.lb_$service_name:8003;
    }
EOT

done


#/usr/sbin/nginx -g "daemon off;"
/usr/sbin/nginx

########################################################################################################################
## logrotate
#sed -i -e "s/{.*/{\n\tdaily\n\trotate 2/" /etc/logrotate.d/nginx
#sed -i -e "s/create.*/create 0644 root root/" /etc/logrotate.d/nginx

########################################################################################################################
# big loop

while true; do
#  # need to use cron job for logrotate
#  logrotate /etc/logrotate.d/nginx

  # sleep 1 day
  sleep 86400
done
