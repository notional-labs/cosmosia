pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils python nginx logrotate

########################################################################################################################
# netdata

bash <(curl -Ss https://my-netdata.io/kickstart.sh)
sleep 5

killall netdata

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/netdata.conf > /opt/netdata/netdata-configs/netdata.conf
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/netdata.python.d.nginx.conf > /opt/netdata/netdata-configs/python.d/nginx.conf
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/netdata.python.d.web_log.conf > /opt/netdata/etc/netdata/python.d/web_log.conf

/opt/netdata/bin/srv/netdata
sleep 5

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/nginx.conf > /etc/nginx/nginx.conf
curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/index.html > /usr/share/nginx/html/index.html

#/usr/sbin/nginx -g "daemon off;"
/usr/sbin/nginx
sleep 5

########################################################################################################################
# logrotate
sed -i -e "s/{.*/{\n\tdaily\n\trotate 2/" /etc/logrotate.d/nginx
sed -i -e "s/create.*/create 0644 root root/" /etc/logrotate.d/nginx

########################################################################################################################
# big loop

killall netdata
killall nginx
sleep 5
/usr/sbin/nginx
sleep 5
/opt/netdata/bin/srv/netdata


while true; do
  # need to use cron job for logrotate
  logrotate /etc/logrotate.d/nginx

  # sleep 1 day
  sleep 86400
done
