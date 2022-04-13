# Status Page

use [uptime-kuma](https://github.com/louislam/uptime-kuma) - a self-hosted monitoring tool like "Uptime Robot" 

```bash
docker service create \
  --name uptime-kuma \
  --replicas 1 \
  --publish target=3001,published=3001 \
  --mount type=bind,source=/mnt/shared_storage/uptime-kuma,destination=/app/data \
  --network cosmosia \
  --constraint 'node.role==manager' \
  --restart-condition any \
  louislam/uptime-kuma:1
```