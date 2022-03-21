# delete existing service
docker service rm proxy


docker service create \
  --name proxy \
  --replicas 1 \
  --publish 80:80 \
  --publish 9001:9001 \
  --network cosmosia \
  --restart-condition any \
  --restart-delay 3s \
  --restart-max-attempts 3 \
  --restart-window 10s \
  ubuntu:20.04 \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy/run.sh > ~/run.sh && /bin/bash ~/run.sh"