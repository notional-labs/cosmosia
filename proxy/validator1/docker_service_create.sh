SERVICE_NAME="proxyvalidator1"

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=5000,published=5000 \
  --publish mode=host,target=5001,published=5001 \
  --publish mode=host,target=5002,published=5002 \
  --publish mode=host,target=5003,published=5003 \
  --publish mode=host,target=5004,published=5004 \
  --endpoint-mode dnsrr \
  --hostname="{{.Service.Name}}.{{.Node.Hostname}}" \
  --network bignet \
  --constraint 'node.hostname==cosmosia61' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/validator1/run.sh > ~/run.sh && \
  /bin/bash ~/run.sh"
