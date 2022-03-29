pacman -Syu --noconfirm
pacman -S --noconfirm nginx python

########################################################################################################################
# netdata

bash <(curl -Ss https://my-netdata.io/kickstart.sh)

killall netdata

curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/netdata.conf > /opt/netdata/netdata-configs/netdata.conf
curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/netdata.python.d.nginx.conf > /opt/netdata/netdata-configs/python.d/nginx.conf

/opt/netdata/bin/srv/netdata


########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/nginx.conf > /etc/nginx/nginx.conf
curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/index.html > /usr/share/nginx/html/index.html

/usr/sbin/nginx -g "daemon off;"
