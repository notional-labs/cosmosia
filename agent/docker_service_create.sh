# delete existing service
docker service rm agent

# create new service
docker service create \
  --name agent \
  --network bignet \
  --network snapshot \
  --mode global \
  --network agent \
  --hostname="{{.Service.Name}}.{{.Node.Hostname}}" \
  --endpoint-mode dnsrr \
  --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/agent/run.sh > ~/run.sh && \
  /bin/bash ~/run.sh"
