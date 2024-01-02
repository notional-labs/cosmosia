# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

cd $HOME
pacman -Syu --noconfirm
pacman -Sy --noconfirm nginx screen

echo "#################################################################################################################"
echo "nginx..."

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/validator1/nginx.conf" > /etc/nginx/nginx.conf


# run nginx with screen to avoid log to docker
screen -S nginx -dm /usr/sbin/nginx -g "daemon off;"

loop_forever