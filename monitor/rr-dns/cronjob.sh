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

echo "get current dns_records..."
current_dns_records=$(cat $HOME/dns_records.txt |jq -r .result[].content)
echo "$current_dns_records"
echo "--------"

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

check_server_in_current_dns_records () {
  ip=$1
  current_ip=$(cat $HOME/dns_records.txt |jq -r  --arg ip "$ip" '.result[]| select( .content == $ip ) |.content')
  # echo "ip=$ip,current_ip=$current_ip"

  if [ "$ip" == "$current_ip" ]; then
    echo "yes"
  else
    echo "no"
  fi
}

check_server_in_current_ip_list () {
  server_ip=$1
  for ip in $ips; do
    if [ "$ip" == "$server_ip" ]; then
      echo "yes"
      return 0
    fi
  done

  echo "no"
}

###################################################################################################
# main

records_changed="no"

echo "remove records not in the list of ips"
for ip in $current_dns_records; do
  ip_exist_in_list=$(check_server_in_current_ip_list $ip)
  echo "ip_exist_in_list of $ip: $ip_exist_in_list"

  if [ "$ip_exist_in_list" == "no" ]; then
    echo "TODO: remove ip $ip"
    records_changed="yes"
  fi
done
echo "-----"

#----------------------------------------------------
echo "update dns records"
for ip in $ips; do
  state=$(check_server_alive $ip)
  echo "state of $ip is $state"

  ip_exist_in_records=$(check_server_in_current_dns_records $ip)
  echo "ip_exist_in_records of $ip: $ip_exist_in_records"

  if [ "$state" == "up" ]; then
    if [ "$ip_exist_in_records" == "no" ]; then
      echo "TODO: add ip $ip"
      records_changed="yes"
    fi
  else
    if [ "$ip_exist_in_records" == "yes" ]; then
      echo "TODO: remove ip $ip"
      records_changed="yes"
    fi
  fi
done
echo "-----"

if [ "$records_changed" == "yes" ]; then
  # get DNS records
  source $HOME/cloudlfare_api_env.sh
  curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records?type=A&name=test1.notional.ventures&match=all" -H "Content-Type:application/json" -H "X-Auth-Email:$CLOUDFLARE_X_AUTH_EMAIL" -H "X-Auth-Key:$CLOUDFLARE_X_AUTH_KEY" > $HOME/dns_records.txt
fi