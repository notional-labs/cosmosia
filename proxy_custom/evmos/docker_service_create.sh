# delete existing service
docker service rm proxy_custom_evmos

# get evmos_dns_secret_token.txt.txt from docker swarm
evmos_dns_secret_token=$(docker config inspect evmos_dns_secret_token.txt |jq -r '.[0].Spec.Data' |base64 --decode)

if [[ -z evmos_dns_secret_token ]]; then
  echo "No evmos_dns_secret_token, Pls set docker config named evmos_dns_secret_token.txt and try again!"
  exit
fi

# create new service
docker service create \
  --name proxy_custom_evmos \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia10' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --env EVMOS_DNS_SECRET_TOKEN=${evmos_dns_secret_token} \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/custom_proxy_evmos/proxy_custom/evmos/run.sh > ~/run.sh && /bin/bash ~/run.sh"
