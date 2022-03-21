pacman -Syu --noconfirm
pacman -S --noconfirm nginx

curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/nginx.conf > /etc/nginx/nginx.conf
curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/index.html > /usr/share/nginx/html/index.html

/usr/sbin/nginx -g "daemon off;"