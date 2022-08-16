pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils nginx cronie

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/100-fix-nginx-to-update-upstream-dynamically/proxy/nginx.conf > /etc/nginx/nginx.conf

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

########################################################################################################################

# generate config for the first time
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/100-fix-nginx-to-update-upstream-dynamically/proxy/generate_upstream.sh" > $HOME/generate_upstream.sh

source $HOME/generate_upstream.sh
cat $TMP_UPSTREAM_CONFIG_FILE > $UPSTREAM_CONFIG_FILE

#/usr/sbin/nginx -g "daemon off;"
/usr/sbin/nginx

########################################################################################################################
# cron
cat <<'EOT' >  $HOME/cron_update_upstream.sh
source $HOME/generate_upstream.sh

if cmp -s "$UPSTREAM_CONFIG_FILE" "$TMP_UPSTREAM_CONFIG_FILE"; then
  # the same => do nothing
  echo "no config change, do nothing..."
else
  # different

  # show the diff
  diff -c "$UPSTREAM_CONFIG_FILE" "$TMP_UPSTREAM_CONFIG_FILE"

  echo "found config changes, updating..."
  cat $TMP_UPSTREAM_CONFIG_FILE > $UPSTREAM_CONFIG_FILE
  /usr/sbin/nginx -s reload
fi
EOT


echo "0/5 * * * * root /bin/bash $HOME/cron_update_upstream.sh" > /etc/cron.d/cron_update_upstream
crond

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
