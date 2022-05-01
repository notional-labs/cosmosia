pacman -Syu --noconfirm
pacman -S --noconfirm nginx

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/web_config/nginx.conf > /etc/nginx/nginx.conf

/usr/sbin/nginx -g "daemon off;"

# loop forever for debugging only
while true; do sleep 5; done