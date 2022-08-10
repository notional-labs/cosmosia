## PebbleDB

Just like goleveldb, go-sqlite; PebbleDB is RocksDB in golang to avoid CGO overhead.

After [migrating 40 chains from goleveldb to rocksdb](https://github.com/notional-labs/cosmosia/issues/86), performance 
is about the same to goleveldb but [disk io](https://github.com/notional-labs/cosmosia/issues/81) is very much lower.
( Why diskio matters? I see bottleneck of the chain is iavl, and bottleneck of iavl is diskio ) 


However, there are some known issues and workarounds:

---

### Chain Upgrade Error
Node will panic at the upgrade-block, for some reasons: maybe dbs are not closed properly, so data is not saved to disk.

After see `UPGRADE "xxxx" NEED at height....`
Then you restart with the new version, and see error `BINARY UPDATED BEFORE TRIGGER!`

**Workaround:**

- Restart current version with [pebble-sync-all](https://github.com/baabeetaa/tm-db/tree/pebble-sync-all) branch, you will see `UPGRADE "xxxx" NEED at height....`
- Restart new version with [pebble-sync-all](https://github.com/baabeetaa/tm-db/tree/pebble-sync-all) branch, wait for new blocks
- Restart new version with [pebble](https://github.com/baabeetaa/tm-db/tree/pebble) branch

---

### Large Size on Disk Data
PebbleDB grows much faster than goleveldb. Idk because i use default config when creating dbs or not.
Eg., It grows about few hundreds GBs in a few days for osmosis chain.

**Workaround:**

Use [pebblecompact_data.sh](https://github.com/notional-labs/cosmosia/blob/main/snapshot/scripts/pebblecompact_data.sh) script to compact it daily or few days.

The compaction takes about 13 min for ~650 GB data on fast NVME.

Put it to a cronjob so it will run automatically.