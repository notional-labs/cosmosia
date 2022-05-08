# delete existing service
docker service rm proxy_private

# create new service
docker service create \
  --name proxy_private \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=9001,published=9001 \
  --publish mode=host,target=9002,published=9002 \
  --publish mode=host,target=9003,published=9003 \
  --publish mode=host,target=9004,published=9004 \
  --publish mode=host,target=9005,published=9005 \
  --publish mode=host,target=9006,published=9006 \
  --publish mode=host,target=9007,published=9007 \
  --publish mode=host,target=9008,published=9008 \
  --publish mode=host,target=9009,published=9009 \
  --publish mode=host,target=9010,published=9010 \
  --publish mode=host,target=9011,published=9011 \
  --publish mode=host,target=9012,published=9012 \
  --publish mode=host,target=9013,published=9013 \
  --publish mode=host,target=9014,published=9014 \
  --publish mode=host,target=9015,published=9015 \
  --publish mode=host,target=9016,published=9016 \
  --publish mode=host,target=9017,published=9017 \
  --publish mode=host,target=9018,published=9018 \
  --publish mode=host,target=9019,published=9019 \
  --publish mode=host,target=9020,published=9020 \
  --publish mode=host,target=9021,published=9021 \
  --publish mode=host,target=9022,published=9022 \
  --publish mode=host,target=9023,published=9023 \
  --publish mode=host,target=9024,published=9024 \
  --publish mode=host,target=9025,published=9025 \
  --publish mode=host,target=9026,published=9026 \
  --publish mode=host,target=9027,published=9027 \
  --publish mode=host,target=9028,published=9028 \
  --publish mode=host,target=9029,published=9029 \
  --publish mode=host,target=9030,published=9030 \
  --publish mode=host,target=9031,published=9031 \
  --publish mode=host,target=9032,published=9032 \
  --publish mode=host,target=9033,published=9033 \
  --publish mode=host,target=9034,published=9034 \
  --publish mode=host,target=9035,published=9035 \
  --publish mode=host,target=19999,published=19999 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia7' \
  --restart-condition any \
  --restart-delay 3s \
  --restart-max-attempts 3 \
  --restart-window 10m \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/proxy_private/proxy_private/run.sh > ~/run.sh && /bin/bash ~/run.sh"


