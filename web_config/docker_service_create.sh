# delete existing service
docker service rm web_config

# create new service
docker service create \
  --name web_config \
  --replicas 1 \
  --network cosmosia \
  --constraint 'node.role==manager' \
  --endpoint-mode dnsrr \
  --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/web_config/run.sh > ~/run.sh && /bin/bash ~/run.sh"


