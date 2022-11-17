pacman -Syu --noconfirm
pacman -S --noconfirm base-devel wget dnsutils nginx cronie screen

########################################################################################################################
# SSL for notional.ventures (fullchain.pem and privkey.pem files)
wget "http://tasks.web_config/config/fullchain.pem" -O /etc/nginx/fullchain.pem
wget "http://tasks.web_config/config/privkey.pem" -O /etc/nginx/privkey.pem

########################################################################################################################
# nginx
curl -s "https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy_static/nginx.conf" > /etc/nginx/nginx.conf

# generate index.html
curl -s "https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini" > $HOME/chain_registry.ini
SERVICES=$(cat $HOME/chain_registry.ini |grep -E "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')

get_links () {
  for service_name in $SERVICES; do
    eval "$(cat $HOME/chain_registry.ini |awk -v TARGET=$service_name -F ' = ' '
      {
        if ($0 ~ /^\[.*\]$/) {
          gsub(/^\[|\]$/, "", $0)
          SECTION=$0
        } else if (($2 != "") && (SECTION==TARGET)) {
          print $1 "=" $2
        }
      }
      ')"

    echo "<p><a href=\"http://${snapshot_node}.notional.ventures:11111/$service_name/\">$service_name</a></p>"
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
  eval "$(cat $HOME/chain_registry.ini |awk -v TARGET=$service_name -F ' = ' '
      {
        if ($0 ~ /^\[.*\]$/) {
          gsub(/^\[|\]$/, "", $0)
          SECTION=$0
        } else if (($2 != "") && (SECTION==TARGET)) {
          print $1 "=" $2
        }
      }
      ')"

    cat <<EOT >> $REDIRECT_CONFIG_FILE
        rewrite ^/${service_name}/(.*)$ http://${snapshot_node}.notional.ventures:11111/${service_name}/\$1\$is_args\$args redirect;
EOT
done


# run nginx with screen to avoid log to docker
screen -S nginx -dm /usr/sbin/nginx -g "daemon off;"

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
