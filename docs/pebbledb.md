# PebbleDB Notes

## Workaround when upgrading a chain running PebbleDB
There is an issue when upgrading chain (`BINARY UPDATED BEFORE TRIGGER!`).
This is not a PebbleDB issue but like a bug of the sdk. At the upgrade-block, the sdk will panic without flushing data to disk 
or closing dbs properly.

**Workaround:**

1. After seeing `UPGRADE "xxxx" NEED at height....`, restart current version with `-X github.com/tendermint/tm-db.ForceSync=1`
2. Restart new version as normal

Example: Upgrading sifchain

```bash
# step1
git reset --hard
git checkout v0.14.0
go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@pebble
go mod tidy

# for cometbft
go mod edit -replace github.com/cometbft/cometbft-db=github.com/notional-labs/cometbft-db@pebble
go mod tidy

go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./...

$HOME/go/bin/sifnoded start --db_backend=pebbledb


# step 2
git reset --hard
git checkout v0.15.0
go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@pebble
go mod tidy

# for cometbft
go mod edit -replace github.com/cometbft/cometbft-db=github.com/notional-labs/cometbft-db@pebble
go mod tidy

go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...

$HOME/go/bin/sifnoded start --db_backend=pebbledb
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
