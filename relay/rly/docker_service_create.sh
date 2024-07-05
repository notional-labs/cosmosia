# usage: ./docker_service_create.sh hubname
# eg., ./docker_service_create.sh whitewhale

hubname="$1"
if [[ -z $hubname ]]; then
  echo "No hubname. usage eg., ./docker_service_create.sh whitewhale"
  exit
fi

service_name="rly_cron_${hubname}"


# delete existing service
docker service rm $service_name

# create new service
docker service create \
  --name $service_name \
  --replicas 1 \
  --network bignet \
  --network net1 \
  --network net2 \
  --network net3 \
  --network net4 \
  --network net5 \
  --network net6 \
  --network net7 \
  --network net8 \
  --constraint "node.labels.cosmosia.relay==true" \
  --endpoint-mode dnsrr \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/relay/rly/run.sh > ~/run.sh && /bin/bash ~/run.sh $hubname"


