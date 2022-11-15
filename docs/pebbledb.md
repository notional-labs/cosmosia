# PebbleDB Notes

## Workaround when upgrading a chain running PebbleDB

Just like goleveldb, go-sqlite; PebbleDB is RocksDB in golang to avoid CGO overhead.

After [migrating 40 chains from goleveldb to pebbledb](https://github.com/notional-labs/cosmosia/issues/86), performance 
is about the same to goleveldb but [disk io](https://github.com/notional-labs/cosmosia/issues/81) is very much lower.
( Why diskio matters? I see bottleneck of the chain is iavl, and bottleneck of iavl is diskio ) 

However, there is an issue when upgrading chain (`BINARY UPDATED BEFORE TRIGGER!`).
This is not a database issue but bugs of the sdk. At the upgrade-block, the sdk will panic without flushing data to disk 
or closing dbs properly. You will properly see this common error:
> ```bash
> panic: runtime error: invalid memory address or nil pointer dereference
> [signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x160652d]

**Workaround:**

1. After seeing `panic: UPGRADE "xxxx" NEED at height....`, restart current version with `-X github.com/tendermint/tm-db.ForceSync=1`
2. Restart new version as normal

Example: Upgrading sifchain

```bash
# step1
git reset --hard
git checkout v0.14.0
go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
go mod tidy
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./cmd/sifnoded

$HOME/go/bin/sifnoded start --db_backend=pebbledb # or supervisorctl start chain


# step 2
## Stop the node again
git reset --hard
git checkout v0.15.0
go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
go mod tidy
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./cmd/sifnoded

$HOME/go/bin/sifnoded start --db_backend=pebbledb # or supervisorctl start chain
```

## Converting LevelDB to PebbleDB
There is a tool to convert databases in data folder from GoLevelDB to PebbleDB.

```console
cd $HOME

# require to install level2pebble first
git clone https://github.com/notional-labs/level2pebble
cd level2pebble
make install

# download the script level2pebble_data.sh
curl -s "https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/scripts/level2pebble_data.sh" > $HOME/level2pebble_data.sh

# convert (example osmosis data dir) 
sh level2pebble_data.sh $HOME/.osmosisd/data
```
