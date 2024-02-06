# PebbleDB Notes

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
