## Add a new chain

### Video Log

[Cosmosia Video Log - How to add a new chain](https://www.youtube.com/embed/AXyyAp6op7E ':include :type=iframe width=100% height=400px')


### Steps

Command executed on a docker swarm manager node. In this example, we will add `cosmoshub` chain

1. Add info of the new chain to [chain_registry.ini](../data/chain_registry.ini)

   > Note: The params
   > - `snapshot_node`: Snapshot running node. The generated snapshot data will be transfered to `snapshot_storage_node`.
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
4. Go to swarm manager server and create docker service for snapshot
   - Create docker service
      ```bash
      cd cosmosia/snapshot
      git pull # Updated latest data
      sh docker_service_create.sh <chain-name>
      ```
      It will create a container in `<snapshot_node>` and setup basic tools. 

   - Head over the container and stop `crond`
      ```bash
      killall crond
      ```
   - Download Golevel snapshot, and extract to data folder
   - Convert to PebbleDB with [Cosmosia convert script](https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/scripts/level2pebble_data.sh):
      - Install `level2pebble`:
         ```bash
         cd ~ && wget https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/scripts/level2pebble_data.sh
         git clone https://github.com/notional-labs/level2pebble
         cd level2pebble && make install
         ```
      - Convert Golevel data to PebbleDB:
         ```bash
         cd ~ && sh level2pebble_data.sh $HOME/<chain-home>/data
         ```
   - Start chain:
      ```bash
      supervisorctl start chain
      ```
   - Query status with:
      ```bash
      curl localhost:26657/status
      ```
      or check error log:
      ```bash
      tail -n1000 /var/log/chain.error.log
      ```
   - When the chain is caught up, stop and create a snapshot:
      ```bash
      supervisorctl stop chain
      screen -S snapshot # create a new screen
      # While in the screen
      bash snapshot_cronjob.sh && crond
      ```
      and wait for the script to finish. After script finished, `crond` will start.

5. Go to swarm manager server and create docker service for RPC
   - Create docker service
      ```bash
      cd cosmosia/rpc
      git pull # Updated latest data
      sh docker_service_create.sh <chain-name>
      ```
      Get `rpc_chain-name_version` from this line of output:
      ```
      Error: No such service: <rpc_chain-name_version>
      ```
   - Create load balancer with `rpc_chain-name_version`:
      ```bash
      cd ../load_balancer/
      bash docker_service_create.sh <chain-name> <rpc_chain-name_version>
      ```
      <!-- Get `lb_chain-name` from this line of output: -->
      <!-- ``` -->
      <!-- Error: No such service: <lb_chain-name> -->
      <!-- ``` -->
   <!-- - Depend on how many nodes we want to run, we can define it in `docs/service_placement.md` -->

   
6. Go to swarm manager server and restart `proxy_public`
   ```bash
   cd cosmosia/proxy/public
   git pull # Updated latest data
   bash docker_service_create.sh
   ```
   You can check if the endpoint is working: `https://rpc-<chain-name>-ia.cosmosia.notional.ventures`

7. [Optional] `proxy_internal`
   ```bash
   cd cosmosia/proxy/internal
   git pull # Updated latest data
   bash docker_service_create.sh
   ```
8. Update [uptime monitor](https://status.notional.ventures/status/cosmosia)

      - Api Service
      - Snapshot Service