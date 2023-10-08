# Status Page

use [uptime-kuma](https://github.com/louislam/uptime-kuma) - a self-hosted monitoring tool like "Uptime Robot" 

```bash
docker service create \
  --name uptime-kuma \
  --replicas 1 \
  --publish target=3001,published=3001 \
  --mount type=bind,source=/mnt/data/uptime-kuma,destination=/app/data \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia7' \
  --restart-condition any \
  louislam/uptime-kuma:1.15.1
```