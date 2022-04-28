

# deploy/re-deploy load-balancer for all chains


RPC_SERVICES="osmosis starname regen akash cosmoshub sentinel emoney ixo juno sifchain likecoin kichain cyber cheqd stargaze bandchain chihuahua kava bitcanna konstellation omniflixhub terra vidulum provenance dig gravitybridge comdex cerberus bitsong assetmantle fetchhub evmos"


for service_name in $RPC_SERVICES; do
  /bin/bash docker_service_create.sh $service_name

  sleep 60
done