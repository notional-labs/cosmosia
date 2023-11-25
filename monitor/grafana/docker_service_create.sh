# Note:
# set grafana admin default password by using docker swarm config with key GRAFANA_PASSWORD

if [ -f "../../env.sh" ]; then
  source ../../env.sh
else
    echo "../../env.sh file does not exist."
    exit
fi

# delete existing service
docker service rm grafana

# create new service
docker service create \
  --name grafana \
  --replicas 1 \
  --network cosmosia \
  --network net1 \
  --network net2 \
  --network net3 \
  --network net4 \
  --network net5 \
  --network net6 \
  --network net7 \
  --network net8 \
  --constraint 'node.hostname==cosmosia11' \
  --endpoint-mode dnsrr \
  --restart-condition any \
  --env-file ../../env.sh \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/monitor/grafana/run.sh > ~/run.sh && /bin/bash ~/run.sh"


