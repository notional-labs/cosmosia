

# deploy/re-deploy snapshot service for all chains


RPC_SERVICES=$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |egrep -o "\[.*\]" | sed 's/^\[\(.*\)\]$/\1/')


echo $RPC_SERVICES | while read service_name; do
  /bin/bash docker_service_create_snapshot.sh $service_name

  sleep 60
done