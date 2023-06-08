## Add a new chain

### Video Log

[Cosmosia Video Log - How to add a new chain](https://www.youtube.com/embed/AXyyAp6op7E ':include :type=iframe width=100% height=400px')


### Steps

Command executed on a docker swarm manager node. In this example, we will add `cosmoshub` chain

1. Add info of the new chain to [chain_registry.ini](../data/chain_registry.ini)

   > Note: The params
   > - `snapshot_node`: Old
   > - `snapshot_storage_node`: Storage node 
   > - `snapshot_prune`: prune strategy. Default `cosmos-pruner`
   > - `network`: 

   When finished adding, create a commit and push to notional-labs/cosmosia.

2. Prepare 1st snapshot and copy to a `snapshot_storage_node` included in [`chain_registry.ini`](https://github.com/notional-labs/cosmosia/blob/main/data/chain_registry.ini#L8). 
   
   The snapshot data for each chain is located at `/mnt/data/<chain-name>`. Normally, each snapshot should have 4 files:
   
    - `chain.json`: Contain information of the chain
    - `data_<date-time>.tar.gz`: Snapshot data, up to the time of generation
    - `genesis.json`
    - `addrbook.json`

   To create a new chain, create a folder `` in `/mnt/data/snapshots` and add basic data in the folder:
    - Copy `chain.json` from other chains, and replace `file_size` and `data_version` to default value `0`. Change old `<chain-name>` in `snapshot_url` to the new chain name `cosmoshub`, and copy `.tar.gz` file name.
    - Create new snapshot file with the name copied above: `touch data_<date-time>.tar.gz`
   
3. Go to `proxy_static` and start the snapshot service:

   - Edit `/usr/share/nginx/html/index.html`:
      ```bash
      nano /usr/share/nginx/html/index.html
      ```
      Add new entry of snapshot url, in this format:
      ```html
      <p><a href="http://<snapshot_storage_node>.notional.ventures:11111/cosmoshub/">cosmoshub</a></p>
      ```
   - Edit `/etc/nginx/redirect_snapshots.conf`:
      ```
      rewrite ^/cosmoshub/(.*)$ http://<snapshot_storage_node>.notional.ventures:11111/cosmoshub/$1$is_args$args redirect;
      ```
   - Test nginx and reload:
      ```bash
      nginx -t
      nginx -s reload
      ```
4. Create docker service
   ```bash
   cd snapshot
   sh docker_service_create.sh <chain-name>
   ```

   It will create a container in `<snapshot_storage_node>` and setup basic tools. Head over the container and stop `crond`
   ```bash
   killall crond
   ```

4. Restart proxy_public
   ```bash
   cd proxy_public
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
   sh docker_service_create.sh chainname
   ```

7. Restart the proxy
   ```bash
   cd proxy
   sh docker_service_create.sh
   ```
   
8. Update [uptime monitor](https://status.notional.ventures/status/cosmosia)

      - Api Service
      - Snapshot Service