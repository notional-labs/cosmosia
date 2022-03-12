# delete existing service
docker service rm proxy


docker service create \
  --name proxy \
  --replicas 1 \
  --publish 80:80 \
  --mount type=bind,source=$HOME/cosmosia/proxy/html,destination=/usr/share/nginx/html \
  --mount type=bind,source=$HOME/cosmosia/proxy/nginx,destination=/etc/nginx \
  --network cosmosia \
  nginx:latest
