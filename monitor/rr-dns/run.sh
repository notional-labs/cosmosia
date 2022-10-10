pacman -Syu --noconfirm
pacman -S --noconfirm base-devel wget dnsutils nginx cronie screen jq

cd $HOME

########################################################################################################################
# get the cloudflare api config
wget "http://tasks.web_config/config/cloudlfare_api_env.txt" -O $HOME/cloudlfare_api_env.sh

curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/29-use-cloudflare-api-to-automate-dns-config/monitor/rr-dns/cronjob.sh  > $HOME/cronjob.sh

# get DNS records the first time
source $HOME/cloudlfare_api_env.sh
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records?type=A&name=test1.notional.ventures&match=all" -H "Content-Type:application/json" -H "X-Auth-Email:$CLOUDFLARE_X_AUTH_EMAIL" -H "X-Auth-Key:$CLOUDFLARE_X_AUTH_KEY" > $HOME/dns_records.txt

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
