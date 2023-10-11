# delete existing service
docker service rm web_config

# create new service
docker service create \
  --name web_config \
  --replicas 1 \
  --network cosmosia \
  --network snapshot \
  --network notionalapi \
  --network net1 \
  --network net2 \
  --network net3 \
  --network net4 \
  --network net5 \
  --network net6 \
  --network net7 \
  --network net8 \
  --constraint 'node.role==manager' \
  --endpoint-mode dnsrr \
  --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/web_config/run.sh > ~/run.sh && /bin/bash ~/run.sh"


