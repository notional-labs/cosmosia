pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel dnsutils python python-pip nginx screen

cd $HOME
git clone --single-branch --branch ip_whitelist_api https://github.com/notional-labs/cosmosia

########################################################################################################################
# ip_whitelist
pip install Flask
pip install Flask-HTTPAuth

cd $HOME/cosmosia/ip_whitelist/api
screen -S api -dm /usr/sbin/python app.py

########################################################################################################################
# nginx

# extract SSL cert (fullchain.pem and privkey.pem files)
tar -xvf "/run/secrets/ssl_notional.ventures.tar.gz" -C /etc/nginx/

cp $HOME/cosmosia/ip_white_list_api/proxy_private/nginx.conf > /etc/nginx/nginx.conf
cp $HOME/cosmosia/ip_white_list_api/proxy_private/index.html > /usr/share/nginx/html/index.html

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
