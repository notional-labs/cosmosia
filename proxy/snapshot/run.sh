# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}

cd $HOME
pacman-key --init
pacman -Syu --noconfirm
pacman -Sy --noconfirm archlinux-keyring
pacman -Sy --noconfirm nginx
pacman -Syu --noconfirm

echo "#################################################################################################################"
echo "nginx..."

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/snapshot/nginx.conf" > /etc/nginx/nginx.conf
/usr/sbin/nginx

loop_forever