# delete existing service
docker service rm rr-dns

# create new service
docker service create \
  --name rr-dns \
  --replicas 1 \
  --network cosmosia \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/29-use-cloudflare-api-to-automate-dns-config/monitor/rr-dns/run.sh > ~/run.sh && /bin/bash ~/run.sh"
