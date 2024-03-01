# usage: ./docker_service_create.sh nodename
# eg., ./docker_service_create.sh cosmosia1

nodename="$1"
if [[ -z $nodename ]]; then
  echo "No nodename. usage eg., ./docker_service_create.sh cosmosia1"
  exit
fi

service_name="dummy_${nodename}"


# delete existing service
docker service rm $service_name

# create new service
docker service create \
  --name $service_name \
  --replicas 1 \
  --constraint "node.hostname==${nodename}" \
  --network bignet \
  --network cosmosia \
  --network agent \
  --network snapshot \
  --network net1 \
  --network net2 \
  --network net3 \
  --network net4 \
  --network net5 \
  --network net6 \
  --network net7 \
  --network net8 \
  --endpoint-mode dnsrr \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "while true; do sleep 5; done"

