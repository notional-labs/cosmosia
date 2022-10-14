
cd $HOME/cosmosia/rpc_monitor

TMP_DIR="./web/build"
TMP_STATUS_FILE="$TMP_DIR/snapshot_sizes.json"

curl -s "http://tasks.rpc_monitor:7749/snapshot_sizes.json" |jq -r '.[]| select( .service|contains("evmos") )'|jq -s '.' > $TMP_STATUS_FILE
