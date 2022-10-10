# usage: ./cronjob.sh domain_name ips
# - domain_name: eg., test.notional.ventures
# - ips: list of ip addresses seperated by comma. Eg., 1.1.1.1,2.2.2.2
# example: sh cronjob.sh test 8.8.8.8,127.0.0.255

echo "rr-dns cronjob..."

cd $HOME

# CLOUDFLARE_ZONE_ID="xxxx"
# CLOUDFLARE_X_AUTH_EMAIL="xxxx"
# CLOUDFLARE_X_AUTH_KEY="xxxx"
#

domain_name="$1"
ips="$2"
# replace ',' => ' '
ips="${ips//,/ }"

echo "domain_name=$domain_name"
echo "ips=$ips"

###################################################################################################
# functions

check_server_alive () {
  # check_server_alive for $1
  ping -c1 $1 &> /dev/null
  if [ $? -eq 0 ]; then
    echo "up"
  else
    echo "down"
  fi
}

###################################################################################################
# main

for ip in $ips; do
  state=$(check_server_alive $ip)
  echo "state of $ip is $state"
done