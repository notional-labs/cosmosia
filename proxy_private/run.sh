pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel dnsutils python python-pip nginx screen

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

# extract SSL cert (fullchain.pem and privkey.pem files)
tar -xvf "/run/secrets/ssl_notional.ventures.tar.gz" -C /etc/nginx/

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


#/usr/sbin/nginx -g "daemon off;"
/usr/sbin/nginx

########################################################################################################################
## logrotate
#sed -i -e "s/{.*/{\n\tdaily\n\trotate 2/" /etc/logrotate.d/nginx
#sed -i -e "s/create.*/create 0644 root root/" /etc/logrotate.d/nginx

########################################################################################################################
# big loop

while true; do
  sleep 5
done
