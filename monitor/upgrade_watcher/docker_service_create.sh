# Note:
# set grafana admin default password by using docker swarm config with key GRAFANA_PASSWORD

if [ -f "../../env.sh" ]; then
  source ../../env.sh
else
    echo "../../env.sh file does not exist."
    exit
fi

# delete existing service
docker service rm upgrade_watcher

# create new service
docker service create \
  --name upgrade_watcher \
  --replicas 1 \
  --network bignet \
  --constraint 'node.hostname==cosmosia11' \
  --mount type=bind,source=/mnt/data/upgrade_watcher,destination=/data \
  --endpoint-mode dnsrr \
  --restart-condition any \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/605-add-upgrade-watcher/monitor/upgrade_watcher/run.sh > ~/run.sh && /bin/bash ~/run.sh"


