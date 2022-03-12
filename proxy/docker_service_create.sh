# delete existing service
docker service rm proxy


docker service create \
  --name proxy \
  --replicas 1 \
  --publish 80:80 \
  --mount type=bind,source=$HOME/cosmosia,destination=/cosmosia \
  --mount type=bind,source=$HOME/cosmosia/proxy/html,destination=/usr/share/nginx/html:ro \
  --mount type=bind,source=$HOME/cosmosia/proxy/nginx.conf,destination=/etc/nginx/nginx.conf:ro \
  --network cosmosia \
  nginx:latest
