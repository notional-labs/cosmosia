pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils python nginx logrotate

# extract SSL cert (fullchain.pem and privkey.pem files)
tar -xvf "/run/secrets/ssl_notional.ventures.tar.gz" -C /etc/nginx/

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy_static/nginx.conf > /etc/nginx/nginx.conf

/usr/sbin/nginx -g "daemon off;"proxy_static

# loop forever for debugging only
#while true; do sleep 5; done