# Snapshot

## Snapshot storage
- Daily snapshots are stored on container. Data will be lost if container down. So we need to backup with `Snapshot Backup`
- Weekly (could be changed to daily, 2 days, 3 days...) snapshot are stored on `Snapshot Backup`

### Snapshot Backup
Backup on single node.

There is an option to use [syncthing](syncthing.md) for replicating but its turned off.

```bash
# du -h
211G	./stargaze
28G	./emoney
58G	./akash
71G	./provenance
262G	./bandchain
73G	./regen
61G	./chihuahua
28G	./bitcanna
2.8G	./comdex
8.5G	./cerberus
36G	./vidulum
21G	./assetmantle
108G	./cosmoshub
119G	./cyber
58G	./ixo
12G	./kichain
87G	./cheqd
4.0K	./.stfolder
53G	./juno
91G	./osmosis
59G	./kava
89G	./dig
56G	./omniflixhub
196M	./bitsong
56G	./starname
227G	./gravitybridge
21G	./likecoin
74G	./konstellation
128G	./terra
32G	./fetchhub
49G	./sifchain
6.7M	./_firstsync
98G	./sentinel
2.3T	.
```