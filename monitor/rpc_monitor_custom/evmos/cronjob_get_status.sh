
cd $HOME/cosmosia/rpc_monitor

TMP_DIR="./web/build"
TMP_STATUS_FILE="$TMP_DIR/status.json"

curl -s "https://tasks.rpc_monitor:7749/status.json" |jq -r '.[]| select( .service|contains("evmos") )'|jq -s '.' > $TMP_STATUS_FILE
