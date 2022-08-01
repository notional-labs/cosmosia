pacman -Sy --noconfirm
pacman -S --noconfirm base-devel wget dnsutils python nginx logrotate

########################################################################################################################
# SSL for notional.ventures (fullchain.pem and privkey.pem files)
# tar -xvf "/run/secrets/ssl_notional.ventures.tar.gz" -C /etc/nginx/
wget "http://tasks.web_config/config/fullchain.pem" -O /etc/nginx/fullchain.pem
wget "http://tasks.web_config/config/privkey.pem" -O /etc/nginx/privkey.pem

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy_public/nginx.conf > /etc/nginx/nginx.conf

# generate index.html
SERVICES=$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |egrep -o "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')

get_links () {
  for service_name in $SERVICES; do
    echo "<p>$service_name <a href=\"/${service_name}/\">goleveldb</a> <a href=\"/${service_name}/rocksdb/\">rocksdb</a></p>"
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




/usr/sbin/nginx -g "daemon off;"
#/usr/sbin/nginx
#sleep 5

########################################################################################################################
## logrotate
#sed -i -e "s/{.*/{\n\tdaily\n\trotate 2/" /etc/logrotate.d/nginx
#sed -i -e "s/create.*/create 0644 root root/" /etc/logrotate.d/nginx

########################################################################################################################
## big loop
#while true; do
#   # need to use cron job for logrotate
#   logrotate /etc/logrotate.d/nginx
#
#  # sleep 1 day
#  sleep 86400
#done

# loop forever for debugging only
while true; do sleep 5; done
