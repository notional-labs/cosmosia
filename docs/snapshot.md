# Snapshot

Link: https://snapshot.notional.ventures/

### Snapshot Interval
- Daily snapshot for pruned node.
- Weekly snapshot for archive node.

### Config
Each swarm node stores snapshots for several chains.

Snapshot node is configured in `chain-registry.ini`:
```bash
[cosmoshub]
...
snapshot_node = "cosmosia1"
```
