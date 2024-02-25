# delete existing service
docker service rm test_sshd

# create new service
docker service create \
  --name test_sshd \
  --replicas 1 \
  --constraint "node.hostname==cosmosia70" \
  --network bignet \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/548-testing-ssh-server-on-container/test_sshd/run.sh > ~/run.sh && \
   /bin/bash ~/run.sh"


