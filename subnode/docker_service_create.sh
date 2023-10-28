# usage: ./docker_service_create.sh subnode_name
# eg., ./docker_service_create.sh osmosis

subnode_name="$1"

if [[ -z $subnode_name ]]
then
  echo "No subnode_name. usage eg., ./docker_service_create.sh osmosis"
  exit
fi

eval "$(awk -v TARGET=$subnode_name -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ' ../data/subnode_registry.ini )"

echo "network=$network"

subnode_service_name="sub_${subnode_name}"


# delete existing service
docker service rm $subnode_service_name

# create new service
docker service create \
  --name $subnode_service_name \
  --replicas 1 \
  --network $network \
  --network subnode \
  --label 'cosmosia.service=subnode' \
  --endpoint-mode dnsrr \
  --constraint 'node.labels.cosmosia.subnode==true' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  --env-file ../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/subnode/run.sh > ~/run.sh && \
   /bin/bash ~/run.sh $subnode_name"
