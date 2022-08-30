pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel wget dnsutils python python-pip nginx screen cronie

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/cosmosia

########################################################################################################################
# ip_whitelist
pip install Flask
pip install Flask-HTTPAuth

cd $HOME/cosmosia/ip_whitelist/api
screen -S api -dm /usr/sbin/python app.py

# wait 3s for /etc/nginx/ip_whitelist.conf to be created if not exist yet
sleep 3

########################################################################################################################
# nginx

# SSL for notional.ventures (fullchain.pem and privkey.pem files)
# tar -xvf "/run/secrets/ssl_notional.ventures.tar.gz" -C /etc/nginx/
wget "http://tasks.web_config/config/fullchain.pem" -O /etc/nginx/fullchain.pem
wget "http://tasks.web_config/config/privkey.pem" -O /etc/nginx/privkey.pem

cp $HOME/cosmosia/proxy_private/nginx.conf /etc/nginx/nginx.conf

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
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/generate_upstream.sh" > $HOME/generate_upstream.sh
sleep 1
source $HOME/generate_upstream.sh
echo "UPSTREAM_CONFIG_FILE=$UPSTREAM_CONFIG_FILE"
echo "UPSTREAM_CONFIG_FILE_TMP=$UPSTREAM_CONFIG_FILE_TMP"
sleep 1
cat "$UPSTREAM_CONFIG_FILE_TMP" > "$UPSTREAM_CONFIG_FILE"
sleep 1
#/usr/sbin/nginx -g "daemon off;"
/usr/sbin/nginx

########################################################################################################################
# cron
cat <<'EOT' >  $HOME/cron_update_upstream.sh
source $HOME/generate_upstream.sh
sleep 1

if cmp -s "$UPSTREAM_CONFIG_FILE" "$UPSTREAM_CONFIG_FILE_TMP"; then
  # the same => do nothing
  echo "no config change, do nothing..."
else
  # different

  # show the diff
  diff -c "$UPSTREAM_CONFIG_FILE" "$UPSTREAM_CONFIG_FILE_TMP"

  echo "found config changes, updating..."
  cat "$UPSTREAM_CONFIG_FILE_TMP" > "$UPSTREAM_CONFIG_FILE"
  sleep 1
  /usr/sbin/nginx -s reload
fi
EOT

sleep 1
echo "*/5 * * * * root /bin/bash $HOME/cron_update_upstream.sh" > /etc/cron.d/cron_update_upstream
sleep 1
crond

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
