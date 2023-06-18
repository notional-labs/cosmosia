pacman -Syu --noconfirm
pacman -S --noconfirm base-devel wget dnsutils nginx cronie screen

########################################################################################################################
# SSL for notional.ventures (fullchain.pem and privkey.pem files)
wget "http://tasks.web_config/config/fullchain.pem" -O /etc/nginx/fullchain.pem
wget "http://tasks.web_config/config/privkey.pem" -O /etc/nginx/privkey.pem

########################################################################################################################
# nginx
curl -s "https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/static/nginx.conf" > /etc/nginx/nginx.conf

# generate index.html
curl -s "$CHAIN_REGISTRY_INI_URL" > $HOME/chain_registry.ini
SERVICES=$(cat $HOME/chain_registry.ini |grep -E "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')

get_links () {
  for service_name in $SERVICES; do
    eval "$(curl -s "http://tasks.web_config/config/cosmosia.snapshot.${service_name}" |sed 's/ = /=/g')"

    node="$snapshot_storage_node"
    if [[ -z $node ]]; then
      node="$snapshot_node"
    fi

    # figure out IP of node
    node_ip=$(curl -s "http://tasks.web_config/node_ip/${node}")
    echo "<p><a href=\"http://${node_ip}:11111/$service_name/\">$service_name</a></p>"
  done
}

links=$(get_links)

cat <<EOT > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cosmosia Snapshots</title>
</head>

<body>
  <h3>Snapshots:</h3>

  ${links}
</body>
</html>
EOT


REDIRECT_CONFIG_FILE="/etc/nginx/redirect_snapshots.conf"
# generate upstream.conf
echo "" > $REDIRECT_CONFIG_FILE
for service_name in $SERVICES; do
  eval "$(curl -s "http://tasks.web_config/config/cosmosia.snapshot.${service_name}" |sed 's/ = /=/g')"

  node="$snapshot_storage_node"
  if [[ -z $node ]]; then
    node="$snapshot_node"
  fi

  # figure out IP of node
  node_ip=$(curl -s "http://tasks.web_config/node_ip/${node}")

  cat <<EOT >> $REDIRECT_CONFIG_FILE
        rewrite ^/${service_name}/(.*)$ http://${node_ip}:11111/${service_name}/\$1\$is_args\$args redirect;
EOT
done


# run nginx with screen to avoid log to docker
screen -S nginx -dm /usr/sbin/nginx -g "daemon off;"

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
