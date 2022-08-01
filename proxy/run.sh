pacman -Sy --noconfirm
pacman -S --noconfirm base-devel dnsutils python nginx logrotate

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/nginx.conf > /etc/nginx/nginx.conf

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


#/usr/sbin/nginx -g "daemon off;"
/usr/sbin/nginx

########################################################################################################################
# logrotate
sed -i -e "s/{.*/{\n\tdaily\n\trotate 2/" /etc/logrotate.d/nginx
sed -i -e "s/create.*/create 0644 root root/" /etc/logrotate.d/nginx

########################################################################################################################
# big loop

while true; do
  # need to use cron job for logrotate
  logrotate /etc/logrotate.d/nginx

  # sleep 1 day
  sleep 86400
done
