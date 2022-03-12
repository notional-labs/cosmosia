# delete existing service
docker service rm proxy_cache


docker service create \
  --name proxy_cache \
  --replicas 1 \
  --publish 8080:8080 \
  --mount type=bind,source=$HOME/cosmosia,destination=/cosmosia \
  --mount type=bind,source=$HOME/cosmosia_data/proxy_cache,destination=/root/proxy_cache_data \
  python:latest \
  /bin/bash /cosmosia/proxy_cache/start.sh
