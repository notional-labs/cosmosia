# Snapshot

Daily snapshots are stored on hosts. Each chain is configured by `snapshot_node` in the `chain_registry.ini` to indicate which host to store the snapshot.

```bash
[cosmoshub]
...
snapshot_time = "1:0"
snapshot_node = "cosmosia1"
```
