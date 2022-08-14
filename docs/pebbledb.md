## PebbleDB

Just like goleveldb, go-sqlite; PebbleDB is RocksDB in golang to avoid CGO overhead.

After [migrating 40 chains from goleveldb to pebbledb](https://github.com/notional-labs/cosmosia/issues/86), performance 
is about the same to goleveldb but [disk io](https://github.com/notional-labs/cosmosia/issues/81) is very much lower.
( Why diskio matters? I see bottleneck of the chain is iavl, and bottleneck of iavl is diskio ) 


However, there are 2 issues and workarounds:

Both issues are not the database issue but bugs of the sdk and the chain.

---

### Issue 1: Chain Upgrade Error
Node will panic at the upgrade-block and dbs are not closed properly, so data is not saved to disk.

After see `UPGRADE "xxxx" NEED at height....`
Then you restart with the new version, and see error `BINARY UPDATED BEFORE TRIGGER!`

**Workaround:**

- Restart current version with [pebble-sync-all](https://github.com/baabeetaa/tm-db/tree/pebble-sync-all) branch, you will see `UPGRADE "xxxx" NEED at height....`
- Restart new version with [pebble-sync-all](https://github.com/baabeetaa/tm-db/tree/pebble-sync-all) branch, wait for new blocks
- Restart new version with [pebble](https://github.com/baabeetaa/tm-db/tree/pebble) branch

---

### Issue 2: Large Size on Disk Data
The large data growing on disk issue happens on buggy chain only (eg., there are unclosed iterators)

https://github.com/notional-labs/cosmosia/issues/94

**Workaround:**

Just restart the chain
