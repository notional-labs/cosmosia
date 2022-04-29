pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils python nginx logrotate

# extract SSL cert (fullchain.pem and privkey.pem files)
tar -xvf "/run/secrets/ssl_notional.ventures.tar.gz" -C /etc/nginx/

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy_public/nginx.conf > /etc/nginx/nginx.conf

#/usr/sbin/nginx -g "daemon off;"
/usr/sbin/nginx
sleep 5

########################################################################################################################
# logrotate
sed -i -e "s/{.*/{\n\tdaily\n\trotate 2/" /etc/logrotate.d/nginx
sed -i -e "s/create.*/create 0644 root root/" /etc/logrotate.d/nginx

########################################################################################################################
# big loop

##killall netdata
#killall nginx
#sleep 5
#/usr/sbin/nginx
#sleep 5
##/opt/netdata/bin/srv/netdata

while true; do
   # need to use cron job for logrotate
   logrotate /etc/logrotate.d/nginx

  # sleep 1 day
  sleep 86400
done
