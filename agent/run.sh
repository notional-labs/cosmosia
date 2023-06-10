
pacman -Syu --noconfirm
pacman -Sy --noconfirm nginx spawn-fcgi fcgiwrap screen docker

# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}


########################################################################################################################
# nginx

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/agent/nginx.conf" > /etc/nginx/nginx.conf
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/agent/host_resource_usage.sh" > /usr/share/nginx/html/host_resource_usage.sh
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/agent/containers_resource_usage.sh" > /usr/share/nginx/html/containers_resource_usage.sh

chmod +x /usr/share/nginx/html/host_resource_usage.sh
chmod +x /usr/share/nginx/html/containers_resource_usage.sh

spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap

# run nginx with screen to avoid log to docker
screen -S nginx -dm /usr/sbin/nginx -g "daemon off;"

loop_forever
