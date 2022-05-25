pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils python nginx logrotate

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/jsonrpc_proxy/proxy/nginx.conf > /etc/nginx/nginx.conf
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/index.html > /usr/share/nginx/html/index.html

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
