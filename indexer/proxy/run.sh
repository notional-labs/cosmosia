pacman -Syu --noconfirm
pacman -S --noconfirm base-devel wget dnsutils nginx

########################################################################################################################
# nginx

########################################################################################################################
# SSL for notional.ventures (fullchain.pem and privkey.pem files)
# tar -xvf "/run/secrets/ssl_notional.ventures.tar.gz" -C /etc/nginx/
wget "http://tasks.web_config/config/fullchain.pem" -O /etc/nginx/fullchain.pem
wget "http://tasks.web_config/config/privkey.pem" -O /etc/nginx/privkey.pem

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/indexer/proxy/nginx.conf > /etc/nginx/nginx.conf


cat <<'EOT' > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cosmosia BDJuno</title>
</head>

<body>
  <h3>Chains:</h3>
  <p><a href="/hasura_juno/">hasura_juno</a></p>
  <p><a href="/hasura_cosmoshub/">hasura_cosmoshub</a></p>
  <p><a href="/hasura_stargaze/">hasura_stargaze</a></p>
</body>
</html>
EOT


/usr/sbin/nginx

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
