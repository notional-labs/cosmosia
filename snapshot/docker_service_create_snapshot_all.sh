# deploy/re-deploy snapshot service for all chains

RPC_SERVICES=$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/86-move-service-to-use-pebble/data/chain_registry.ini |egrep -o "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')

for service_name in $RPC_SERVICES; do
  /bin/bash docker_service_create_snapshot.sh $service_name

  sleep 60
done