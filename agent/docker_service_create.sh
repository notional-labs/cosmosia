# delete existing service
docker service rm agent

# create new service
docker service create \
  --name agent \
  --replicas 1 \
  --network snapshot \
  --mode global \
  --constraint 'node.role==manager' \
  --endpoint-mode dnsrr \
  --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "while true; do sleep 5; done"
