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
#/usr/sbin/nginx -g "daemon off;"
/usr/sbin/nginx

# generate config for the first time
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/100-fix-nginx-to-update-upstream-dynamically/proxy/cron_update_upstream.sh" > $HOME/cron_update_upstream.sh

/bin/bash $HOME/cron_update_upstream.sh
#sleep 5
#UPSTREAM_CONFIG_FILE="/etc/nginx/upstream.conf"
#UPSTREAM_CONFIG_FILE_TMP="/etc/nginx/upstream.conf.tmp"
#cat $TMP_UPSTREAM_CONFIG_FILE > $UPSTREAM_CONFIG_FILE

########################################################################################################################
# cron
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
