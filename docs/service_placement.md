# Service Placement

## Server types
There are several server types in the cluster to optimize resource usage:
- snapshot storage type: used to store snapshots. This server needs large HDD space, but doesn't require CPU & RAM.
- pruned snapshot type: to run snapshot services for pruned node.
- pruned rpc type: to run rpc services for pruned node. This node needs fast nvme disks, high CPU and RAM.
- archive snapshot type: to run snapshot services for archive node. Similar to pruned snapshot type, but number of
services running on this server is much lower 1-2 services only while pruned snapshot type server could run 5-10 services.
- archive rpc type: to run rpc service for archive node. This node needs fast nvme disks, high CPU and RAM.
- load-balance type: to run load balance services. This node needs mostly bandwidth. 
- proxy type: to run proxy services. This node needs mostly bandwidth. 

On small cluster, a server could be multiple types at the same time.

## Snapshot Service Placement

Snapshot for each chain is configured in the [chain-registry](../data/chain_registry.ini)

See more on [snapshot doc](snapshot.md).

---
## RPC Service Placement

Pruned-rpc services run on swarm nodes with label `cosmosia.rpc.pruned=true`.

While archive rpc services run on specific swarm node with label eg `cosmosia.rpc.osmosis-archive=true`.


| No | Chain                 | Node1       | Node 2      | Node3       | Node 4      | Node 5      |
|---:|:----------------------|:-----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| 40 | evmos-testnet-archive | cosmosia4   | cosmosia5   |             |             |             |
| 45 | evmos-archive         | cosmosia11  | cosmosia12  | cosmosia13  |             |             |
| 47 | dig-archive           | cosmosia5   | cosmosia7   |             |             |             |
| 48 | osmosis-archive       | cosmosia21  |             |             |             |             |
| 49 | cosmoshub-archive     | cosmosia14  |             |             |             |             |
| 51 | quicksilver-archive   | cosmosia12  | cosmosia14  |             |             |             |
| 52 | terra-archive         | cosmosia20  |             |             |             |             |
| 53 | juno-archive          | cosmosia21  |             |


#### Docker commands

To add label to a node:
```console
docker node update --label-add cosmosia.rpc.osmosis-archive=true cosmosia21
```

To remove label to a node:
```console
docker node update --label-rm cosmosia.rpc.osmosis-archive cosmosia21
```

To list node with label:
```console
docker node ls -f node.label=cosmosia.rpc.osmosis-archive=true
```

---
## Load-Balancer Service Placement

https://github.com/notional-labs/cosmosia/issues/255


#### Docker commands

To add label to a node:
```console
docker node update --label-add cosmosia.lb=true cosmosia26
```

To remove label to a node:
```console
docker node update --label-rm cosmosia.lb cosmosia26
```

To list node with label:
```console
docker node ls -f node.label=cosmosia.lb=true
```
