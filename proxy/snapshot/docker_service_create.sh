SERVICE_NAME="proxysnapshot"

# delete existing service
docker service rm $SERVICE_NAME

# create new service
docker service create \
  --name $SERVICE_NAME \
  --mode global \
  --constraint "node.labels.cosmosia.storage==true" \
  --publish mode=host,target=80,published=11111 \
  --endpoint-mode dnsrr \
  --hostname="{{.Service.Name}}.{{.Node.Hostname}}" \
  --network bignet \
  --network snapshot \
  --network net1 \
  --network net2 \
  --network net3 \
  --network net4 \
  --network net5 \
  --network net6 \
  --network net7 \
  --network net8 \
  --mount type=bind,source=/mnt/data/snapshots,destination=/snapshots,readonly \
  --restart-condition any \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy/snapshot/run.sh > ~/run.sh && \
  /bin/bash ~/run.sh"
