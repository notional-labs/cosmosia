# delete existing service
docker service rm mantlemint

docker service create \
  --name mantlemint \
  --replicas 1 \
  --network cosmosia \
  --label 'cosmosia.service=mantlemint' \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --constraint 'node.hostname==cosmosia19' \
  archlinux:latest \
  /bin/bash -c \
  "while true; do sleep 60; done"
