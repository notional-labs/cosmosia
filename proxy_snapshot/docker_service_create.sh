
# delete existing service
docker service rm proxy_snapshot

# create new service
docker service create \
  --name proxy_snapshot \
  --replicas 1 \
  --publish mode=host,target=8864,published=80 \
  --network cosmosia \
  --restart-condition any \
  --restart-delay 3s \
  --restart-max-attempts 3 \
  --restart-window 10m \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/main/proxy_snapshot/run.sh > ~/run.sh && /bin/bash ~/run.sh"


