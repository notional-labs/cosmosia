# delete existing service
docker service rm rl_test

# create new service
docker service create \
  --name rl_test \
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
  --constraint 'node.hostname==cosmosia33' \
  --endpoint-mode dnsrr \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/491-relaying-test-relaying/relaying/run.sh > ~/run.sh && /bin/bash ~/run.sh"


