# Snapshot Usage

Link: https://snapshot.notional.ventures/

All Notional snapshot are PebbleDB instead of GoLevelDB.

### Download and extract snapshot .tar.gz file
```console
# URL="http://cosmosia14.notional.ventures:11111/osmosis/data_20221106_211602.tar.gz"
# node_home="$HOME/.osmosisd"

cd $node_home
wget -O - "$URL" |tar -xzf -
```

### Build with PebbleDB backend
```console
go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
go mod tidy
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...
```

### Run with PebbleDB backend
```console
sed -i -e "s/^db_backend *=.*/db_backend = \"pebbledb\"/" $node_home/config/config.toml
```

### Note
Using this [workaround](pebbledb.md) when upgrading a node running PebbleDB

### Special chains
Some chains require building differently

**cosmoshub | cheqd | terra | assetmantle**
```console
go mod edit -dropreplace github.com/tecbot/gorocksdb
go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
go mod tidy
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...
```


**cyber | provenance**
```console
go mod tidy -compat=1.17
go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
go mod tidy
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...
```

**emoney**
```console
sed -i 's/db.NewGoLevelDB/sdk.NewLevelDB/g' app.go
go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
go mod tidy
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/e-money/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./...
```

**starname | sifchain**
```console
# $daemon_name is starnamed or sifnoded

go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
go mod tidy
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./cmd/$daemon_name
```

**axelar**
```console
# version is v0.26.0
axelard_version=${version##*v}

go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
go mod tidy
go build -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/cosmos/cosmos-sdk/version.Version=$axelard_version" -o /root/go/bin/axelard ./cmd/axelard
```

**pylons**
```console
go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble
go mod tidy
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb -X github.com/tendermint/tm-db.ForceSync=1" ./...
```
