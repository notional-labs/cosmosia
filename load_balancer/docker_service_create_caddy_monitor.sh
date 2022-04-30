# delete existing service
docker service rm caddy_monitor_test

# create new service
docker service create \
  --name caddy_monitor_test \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=9090,published=9090 \
  --publish mode=host,target=3000,published=3000 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia7' \
  --endpoint-mode dnsrr \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c "while true; do sleep 5; done"


