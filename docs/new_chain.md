## Add a new chain

Command executed on a docker swarm manager node

1. Add info of the new chain to [chain_registry.ini](../data/chain_registry.ini)
2. Prepare 1st snapshot and copy to a `snapshot_node` (eg., https://github.com/notional-labs/cosmosia/blob/main/data/chain_registry.ini#L13). 
   
    Each snapshot has 3 files:
    - chain.json
    - data_datetime.tar.gz
    - addrbook.json
   
3. Start the snapshot service:
   ```bash
   cd snapshot
   sh docker_service_create_snapshot.sh chainname
   ```

4. Update proxy_static
   append a link to [snapshot.index.html](proxy_static/snapshot.index.html)
   ```html
   <p><a href="/chainname/">chainname</a></p>
   ```

   Restart the proxy_static
   ```bash
   cd proxy_static
   sh docker_service_create.sh
   ```

5. Start the rpc
   ```bash
   cd rpc
   sh docker_service_create.sh chainname
   ```

6. Start the load-balancer
   ```bash
   cd load_balancer
   sh sh docker_service_create.sh chainname
   ```

7. Update the proxy
   append a link to [index.html](proxy/index.html)
   ```html
   <p><a href="/chainname/">chainname</a></p>
   ```
   
   Restart the proxy
   ```bash
   cd proxy
   sh docker_service_create.sh
   ```
   
8. Update DNS record
   Add 4 CNAME records with value `cosmosia.notional.ventures`

   - api-chainname-ia
   - grpc-chainname-ia
   - rpc-chainname-ia
   - ws-chainname-ia
   
9. Update rpc_monitor
   Append new chainname to https://github.com/notional-labs/cosmosia/blob/main/rpc_monitor/get_status.sh#L2
   
   Restart rpc_monitor
   ```bash
   cd rpc_monitor
   sh docker_service_create.sh
   ```
   
10. Update [uptime monitor](https://status.notional.ventures/status/cosmosia)
   - Api Service
   - Snapshot Service