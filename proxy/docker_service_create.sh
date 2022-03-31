
git_branch=$(git symbolic-ref --short -q HEAD)

# delete existing service
docker service rm proxy

# create new service
docker service create \
  --name proxy \
  --replicas 1 \
  --publish 80:80 \
  --publish 9001-9099:9001-9099 \
  --publish 19999:19999 \
  --network cosmosia \
  --constraint 'node.role==manager' \
  --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
  --restart-condition any \
  --restart-delay 3s \
  --restart-max-attempts 3 \
  --restart-window 10m \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/$git_branch/proxy/run.sh > ~/run.sh && /bin/bash ~/run.sh"