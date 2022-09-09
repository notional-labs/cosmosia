pacman -Syu --noconfirm
pacman -S --noconfirm base-devel dnsutils nginx

########################################################################################################################
# nginx

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/indexer/indexer/proxy/nginx.conf > /etc/nginx/nginx.conf
/usr/sbin/nginx

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
