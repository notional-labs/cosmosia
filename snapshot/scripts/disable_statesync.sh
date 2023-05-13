# usage: ./disable_statesync.sh chain_name
# eg., ./disable_statesync.sh cosmoshub

chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./disable_statesync.sh cosmoshub"
  exit
fi


eval "$(curl -s "$CHAIN_REGISTRY_INI_URL" |awk -v TARGET=$chain_name -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ')"

echo "node_home=$node_home"

sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = 0/" $node_home/config/app.toml
sed -i '/^\[statesync]/,/^\[/{s/^enable[[:space:]]*=.*/enable = false/}' $node_home/config/config.toml
sed -i -e "s/^addr_book_strict *=.*/addr_book_strict = true/" $node_home/config/config.toml
sed -i -e "s/^pex *=.*/pex = true/" $node_home/config/config.toml