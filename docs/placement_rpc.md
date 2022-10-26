# RPC Service Placement

https://github.com/notional-labs/cosmosia/issues/195

| No | Chain                 | Node1       | Node 2      | Node3       | Node 4      | Node 5      |
|---:|:----------------------|:-----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| 1  | osmosis               | cosmosia1   | cosmosia2   | cosmosia3   | cosmosia4   | cosmosia5   |
| 2  | starname              | cosmosia2   | cosmosia3   | cosmosia4   | cosmosia5   | cosmosia6   |
| 3  | regen                 | cosmosia3   | cosmosia4   | cosmosia5   | cosmosia6   | cosmosia7   |
| 4  | akash                 | cosmosia4   | cosmosia5   | cosmosia6   | cosmosia7   | cosmosia8   |
| 5  | cosmoshub             | cosmosia5   | cosmosia6   | cosmosia7   | cosmosia8   | cosmosia9   |
| 6  | sentinel              | cosmosia6   | cosmosia7   | cosmosia8   | cosmosia9   | cosmosia10  |
| 7  | emoney                | cosmosia7   | cosmosia8   | cosmosia9   | cosmosia10  | cosmosia11  |
| 8  | ixo                   | cosmosia8   | cosmosia9   | cosmosia10  | cosmosia11  | cosmosia12  |
| 9  | juno                  | cosmosia9   | cosmosia10  | cosmosia11  | cosmosia12  | cosmosia13  |
| 10 | sifchain              | cosmosia10  | cosmosia11  | cosmosia12  | cosmosia13  | cosmosia14  |
| 11 | likecoin              | cosmosia11  | cosmosia12  | cosmosia13  | cosmosia14  | cosmosia15  |
| 12 | kichain               | cosmosia12  | cosmosia13  | cosmosia14  | cosmosia15  | cosmosia16  |
| 13 | cyber                 | cosmosia13  | cosmosia14  | cosmosia15  | cosmosia16  | cosmosia17  |
| 14 | cheqd                 | cosmosia14  | cosmosia15  | cosmosia16  | cosmosia17  | cosmosia18  |
| 15 | stargaze              | cosmosia15  | cosmosia16  | cosmosia17  | cosmosia18  | cosmosia1   |
| 16 | bandchain             | cosmosia16  | cosmosia17  | cosmosia18  | cosmosia1   | cosmosia2   |
| 17 | chihuahua             | cosmosia17  | cosmosia18  | cosmosia1   | cosmosia2   | cosmosia3   |
| 18 | kava                  | cosmosia18  | cosmosia1   | cosmosia2   | cosmosia3   | cosmosia4   |
| 19 | bitcanna              | cosmosia1   | cosmosia2   | cosmosia3   | cosmosia4   | cosmosia5   |
| 20 | konstellation         | cosmosia2   | cosmosia3   | cosmosia4   | cosmosia5   | cosmosia6   |
| 21 | omniflixhub           | cosmosia3   | cosmosia4   | cosmosia5   | cosmosia6   | cosmosia7   |
| 22 | terra                 | cosmosia4   | cosmosia5   | cosmosia6   | cosmosia7   | cosmosia8   |
| 23 | vidulum               | cosmosia5   | cosmosia6   | cosmosia7   | cosmosia8   | cosmosia9   |
| 24 | provenance            | cosmosia6   | cosmosia7   | cosmosia8   | cosmosia9   | cosmosia10  |
| 25 | dig                   | cosmosia7   | cosmosia8   | cosmosia9   | cosmosia10  | cosmosia11  |
| 26 | gravitybridge         | cosmosia8   | cosmosia9   | cosmosia10  | cosmosia11  | cosmosia12  |
| 27 | comdex                | cosmosia9   | cosmosia10  | cosmosia11  | cosmosia12  | cosmosia13  |
| 28 | cerberus              | cosmosia10  | cosmosia11  | cosmosia12  | cosmosia13  | cosmosia14  |
| 29 | bitsong               | cosmosia11  | cosmosia12  | cosmosia13  | cosmosia14  | cosmosia15  |
| 30 | assetmantle           | cosmosia12  | cosmosia13  | cosmosia14  | cosmosia15  | cosmosia16  |
| 31 | fetchhub              | cosmosia13  | cosmosia14  | cosmosia15  | cosmosia16  | cosmosia17  |
| 32 | evmos                 | cosmosia14  | cosmosia15  | cosmosia16  | cosmosia17  | cosmosia18  |
| 33 | persistent            | cosmosia15  | cosmosia16  | cosmosia17  | cosmosia18  | cosmosia1   |
| 34 | cryptoorgchain        | cosmosia16  | cosmosia17  | cosmosia18  | cosmosia1   | cosmosia2   |
| 35 | irisnet               | cosmosia17  | cosmosia18  | cosmosia1   | cosmosia2   | cosmosia3   |
| 36 | axelar                | cosmosia18  | cosmosia1   | cosmosia2   | cosmosia3   | cosmosia4   |
| 37 | pylons                | cosmosia1   | cosmosia2   | cosmosia3   | cosmosia4   | cosmosia5   |
| 38 | umee                  | cosmosia2   | cosmosia3   | cosmosia4   | cosmosia5   | cosmosia6   |
| 39 | sei                   | cosmosia3   | cosmosia4   | cosmosia5   | cosmosia6   | cosmosia7   |
| 40 | evmos-testnet-archive | cosmosia4   | cosmosia5   | cosmosia6   | cosmosia7   | cosmosia8   |
| 41 | injective             | cosmosia5   | cosmosia6   | cosmosia7   | cosmosia8   | cosmosia9   |
| 42 | kujira                | cosmosia6   | cosmosia7   | cosmosia8   | cosmosia9   | cosmosia10  |
| 43 | passage               | cosmosia7   | cosmosia8   | cosmosia9   | cosmosia10  | cosmosia11  |
| 44 | osmosis-testnet       | cosmosia8   | cosmosia9   | cosmosia10  | cosmosia11  | cosmosia12  |
| 45 | evmos-archive         | cosmosia9   | cosmosia10  | cosmosia11  | cosmosia12  | cosmosia13  |
| 46 | stride                | cosmosia10  | cosmosia11  | cosmosia12  | cosmosia13  | cosmosia14  |
| 47 | dig-archive           | cosmosia11  | cosmosia12  | cosmosia13  | cosmosia14  | cosmosia15  |


### Docker commands

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
