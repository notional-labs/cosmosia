# Snapshot

Earlier versions of Cosmosia, I backup snapshots to a centralized node and noticed that network is the bottleneck.
Servers have 1Gb port only. So it wont scale. Therefore, I updated to store snapshots to all nodes on the swarm clusters.
Each swarm nodes stores snapshot for several chains. This scales much better.


Daily snapshots are stored on hosts. Each chain is configured by `snapshot_node` in the `chain_registry.ini` to indicate which host to store the snapshot.

```bash
[cosmoshub]
...
snapshot_time = "1:0"
snapshot_node = "cosmosia1"
```




