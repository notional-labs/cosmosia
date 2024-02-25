# delete existing service
docker service rm test_sshproxy

# create new service
docker service create \
  --name test_sshproxy \
  --replicas 1 \
  --publish mode=host,target=22,published=22000 \
  --constraint "node.hostname==cosmosia70" \
  --network bignet \
  --endpoint-mode dnsrr \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/548-testing-ssh-server-on-container/test_sshproxy/run.sh > ~/run.sh && \
   /bin/bash ~/run.sh"


