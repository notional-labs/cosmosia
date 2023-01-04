# Service Placement

To optimize resource usage including network/bandwidth, disk space and disk io; need to control service placements.


## Snapshot Service Placement

Snapshot for each chain is configured in the [chain-registry](../data/chain_registry.ini)

See more on [snapshot doc](snapshot.md).

---
## RPC Service Placement

https://github.com/notional-labs/cosmosia/issues/195

| No | Chain                 | Node1       | Node 2      | Node3       | Node 4      | Node 5      |
|---:|:----------------------|:-----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| 1  | osmosis               | cosmosia1   | cosmosia4   |             |             |             |
| 2  | starname              | cosmosia2   | cosmosia3   |             |             |             |
| 3  | regen                 | cosmosia3   | cosmosia4   |             |             |             |
| 4  | akash                 | cosmosia4   | cosmosia5   |             |             |             |
| 5  | cosmoshub             | cosmosia3   | cosmosia5   |             |             |             |
| 6  | sentinel              | cosmosia5   | cosmosia6   |             |             |             |
| 7  | emoney                | cosmosia7   | cosmosia8   |             |             |             |
| 8  | ixo                   | cosmosia7   | cosmosia8   |             |             |             |
| 9  | juno                  | cosmosia2   | cosmosia3   |             |             |             |
| 10 | sifchain              | cosmosia7   | cosmosia9   |             |             |             |
| 11 | likecoin              | cosmosia7   | cosmosia9   |             |             |             |
| 12 | kichain               | cosmosia7   | cosmosia8   |             |             |             |
| 13 | cyber                 | cosmosia13  | cosmosia14  |             |             |             |
| 14 | cheqd                 | cosmosia7   | cosmosia8   |             |             |             |
| 15 | stargaze              | cosmosia15  | cosmosia16  |             |             |             |
| 16 | bandchain             | cosmosia16  | cosmosia17  |             |             |             |
| 17 | chihuahua             | cosmosia17  | cosmosia18  |             |             |             |
| 18 | kava                  | cosmosia18  | cosmosia1   |             |             |             |
| 19 | bitcanna              | cosmosia1   | cosmosia2   |             |             |             |
| 20 | konstellation         | cosmosia2   | cosmosia3   |             |             |             |
| 21 | omniflixhub           | cosmosia3   | cosmosia4   |             |             |             |
| 22 | terra                 | cosmosia4   | cosmosia5   |             |             |             |
| 23 | vidulum               | cosmosia5   | cosmosia6   |             |             |             |
| 24 | provenance            | cosmosia6   | cosmosia7   |             |             |             |
| 25 | dig                   | cosmosia7   | cosmosia8   |             |             |             |
| 26 | gravitybridge         | cosmosia8   | cosmosia9   |             |             |             |
| 27 | comdex                | cosmosia9   | cosmosia10  |             |             |             |
| 28 | cerberus              | cosmosia2   | cosmosia3   |             |             |             |
| 29 | bitsong               | cosmosia2   | cosmosia3   |             |             |             |
| 30 | assetmantle           | cosmosia7   | cosmosia9   |             |             |             |
| 31 | fetchhub              | cosmosia13  | cosmosia14  |             |             |             |
| 32 | evmos                 | cosmosia8   | cosmosia9   | cosmosia10  |             |             |
| 33 | persistent            | cosmosia15  | cosmosia16  |             |             |             |
| 34 | cryptoorgchain        | cosmosia16  | cosmosia17  |             |             |             |
| 35 | irisnet               | cosmosia17  | cosmosia18  |             |             |             |
| 36 | axelar                | cosmosia18  | cosmosia1   |             |             |             |
| 37 | pylons                |             |             |             |             |             |
| 38 | umee                  | cosmosia2   | cosmosia3   |             |             |             |
| 39 | sei                   | cosmosia9   | cosmosia10  |             |             |             |
| 40 | evmos-testnet-archive | cosmosia4   | cosmosia5   |             |             |             |
| 41 | injective             | cosmosia5   | cosmosia6   |             |             |             |
| 42 | kujira                | cosmosia6   | cosmosia7   |             |             |             |
| 43 | passage               | cosmosia7   | cosmosia8   |             |             |             |
| 44 | osmosis-testnet       | cosmosia8   | cosmosia9   |             |             |             |
| 45 | evmos-archive         | cosmosia11  | cosmosia12  | cosmosia13  |             |             |
| 46 | stride                | cosmosia9   | cosmosia10  |             |             |             |
| 47 | dig-archive           | cosmosia5   | cosmosia6   |             |             |             |
| 48 | osmosis-archive       | cosmosia16  |             |             |             |             |
| 49 | cosmoshub-archive     | cosmosia14  |             |             |             |             |
| 50 | quicksilver           | cosmosia6   | cosmosia8   |             |             |             |
| 51 | quicksilver-archive   | cosmosia12  | cosmosia14  |             |             |             |
| 52 | terra-archive         | cosmosia20  |             |             |             |             |


#### Docker commands

To add label to a node:
```console
docker node update --label-add cosmosia.rpc.osmosis=true cosmosia1
```

To remove label to a node:
```console
docker node update --label-rm cosmosia.rpc.osmosis cosmosia1
```

To list node with label:
```console
docker node ls -f node.label=cosmosia.rpc.osmosis=true
```

---
## Load-Balancer Service Placement

https://github.com/notional-labs/cosmosia/issues/197

Need at least 2 nodes in case one node down.

| No | Chain                 | Node1       | Node 2      |
|---:|:----------------------|:-----------:|:-----------:|
| 1  | osmosis               | cosmosia1   | cosmosia2   | 
| 2  | starname              | cosmosia2   | cosmosia3   |
| 3  | regen                 | cosmosia3   | cosmosia4   |
| 4  | akash                 | cosmosia4   | cosmosia5   |
| 5  | cosmoshub             | cosmosia5   | cosmosia6   |
| 6  | sentinel              | cosmosia6   | cosmosia7   |
| 7  | emoney                | cosmosia7   | cosmosia8   |
| 8  | ixo                   | cosmosia8   | cosmosia9   |
| 9  | juno                  | cosmosia9   | cosmosia10  |
| 10 | sifchain              | cosmosia10  | cosmosia11  |
| 11 | likecoin              | cosmosia11  | cosmosia12  |
| 12 | kichain               | cosmosia12  | cosmosia13  |
| 13 | cyber                 | cosmosia13  | cosmosia14  |
| 14 | cheqd                 | cosmosia14  | cosmosia15  |
| 15 | stargaze              | cosmosia15  | cosmosia16  |
| 16 | bandchain             | cosmosia16  | cosmosia17  |
| 17 | chihuahua             | cosmosia17  | cosmosia18  |
| 18 | kava                  | cosmosia18  | cosmosia1   |
| 19 | bitcanna              | cosmosia1   | cosmosia2   |
| 20 | konstellation         | cosmosia2   | cosmosia3   |
| 21 | omniflixhub           | cosmosia3   | cosmosia4   |
| 22 | terra                 | cosmosia4   | cosmosia5   |
| 23 | vidulum               | cosmosia5   | cosmosia6   |
| 24 | provenance            | cosmosia6   | cosmosia7   |
| 25 | dig                   | cosmosia7   | cosmosia8   |
| 26 | gravitybridge         | cosmosia8   | cosmosia9   |  
| 27 | comdex                | cosmosia9   | cosmosia10  |
| 28 | cerberus              | cosmosia10  | cosmosia11  |
| 29 | bitsong               | cosmosia11  | cosmosia12  |
| 30 | assetmantle           | cosmosia12  | cosmosia13  | 
| 31 | fetchhub              | cosmosia13  | cosmosia14  |
| 32 | evmos                 | cosmosia14  | cosmosia15  | 
| 33 | persistent            | cosmosia15  | cosmosia16  |
| 34 | cryptoorgchain        | cosmosia16  | cosmosia17  |
| 35 | irisnet               | cosmosia17  | cosmosia18  |
| 36 | axelar                | cosmosia18  | cosmosia1   |
| 37 | pylons                | cosmosia1   | cosmosia2   |
| 38 | umee                  | cosmosia2   | cosmosia3   |
| 39 | sei                   | cosmosia3   | cosmosia4   |
| 40 | evmos-testnet-archive | cosmosia4   | cosmosia5   |
| 41 | injective             | cosmosia5   | cosmosia6   |
| 42 | kujira                | cosmosia6   | cosmosia7   |
| 43 | passage               | cosmosia7   | cosmosia8   |
| 44 | osmosis-testnet       | cosmosia8   | cosmosia9   |
| 45 | evmos-archive         | cosmosia9   | cosmosia10  |
| 46 | stride                | cosmosia10  | cosmosia11  |
| 47 | dig-archive           | cosmosia11  | cosmosia12  |
| 48 | osmosis-archive       | cosmosia12  | cosmosia13  |
| 48 | cosmoshub-archive     | cosmosia15  | cosmosia16  |
| 50 | quicksilver           | cosmosia13  | cosmosia14  |
| 51 | quicksilver-archive   | cosmosia14  | cosmosia15  |
| 52 | terra-archive         | cosmosia16  | cosmosia17  |


#### Docker commands

To add label to a node:
```console
docker node update --label-add cosmosia.lb.osmosis=true cosmosia1
```

To remove label to a node:
```console
docker node update --label-rm cosmosia.lb.osmosis cosmosia1
```

To list node with label:
```console
docker node ls -f node.label=cosmosia.lb.osmosis=true
```
