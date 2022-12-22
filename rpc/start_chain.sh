chain_name="$1"
rpc_service_name="$2"

########################################################################################################################
# functions
# requires to install dnsutils, inetutils, jq

find_local_peers () {
  chain_name="$1"

  # figure out local IP
  local_ip=$(hostname -i)

  # figure out all container IP of service
  ips=$(dig +short "tasks.$rpc_service_name" |sort)

  # filter out local IP
  ips=$(echo "$ips" |grep -v "$local_ip")
  local_peers=""

  if [[ -z "$ips" ]]; then
    echo "${local_peers}"
    exit
  fi

  while read -r ip_addr || [[ -n $ip_addr ]]; do
    # figure out hostname of peer
    peer_hostname=$(dig +short -x $ip_addr)

    # figure out node_id
    node_id=$(curl -s "http://${ip_addr}:26657/status" |jq -r '.result.node_info.id')

    if [[ ! -z "$node_id" ]]; then
      peer="${node_id}@${peer_hostname}:26656"

      if [[ ! -z "$local_peers" ]]; then
        local_peers="${local_peers},"
      fi

      local_peers="${local_peers}${peer}"
    fi
  done < <(echo "$ips")


  ## show result
  echo "$local_peers"
}


# args
# @1 start_flags string
# @2 local_peers string
update_start_flags () {
  start_flags="$1"
  local_peers="$2"

  if [[ -z "$local_peers" ]]; then
    echo "${start_flags}"
    exit
  fi


  found_p2p_persistent_peers=false
  new_start_flags=""
  for flag in $start_flags; do
    new_flag="$flag"
    # trim spaces
    new_flag=$(echo "${new_flag}" |xargs)

    if [[ $new_flag == --p2p.persistent_peers* ]]; then
      new_flag="$new_flag,${local_peers}"
      found_p2p_persistent_peers=true
    fi

    if [[ ! -z "$new_start_flags" ]]; then
      new_start_flags="${new_start_flags} "
    fi
    new_start_flags="${new_start_flags}${new_flag}"
  done

  if [[ "$found_p2p_persistent_peers" == false ]]; then
    if [[ ! -z "$new_start_flags" ]]; then
      new_start_flags="${new_start_flags} "
    fi

    new_start_flags="${new_start_flags}--p2p.persistent_peers=${local_peers}"
  fi

  echo "${new_start_flags}"
}

find_current_data_version () {
  ver=0
  ver=$(curl -Ls "https://snapshot.notional.ventures/$chain_name/chain.json" |jq -r '.data_version // 0')
  echo $ver
}

########################################################################################################################
# main

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./start_script_gen.sh cosmoshub"
  exit
fi

# fix supervisorctl creates a dbus-daemon process everytime starting chain
killall dbus-daemon

# get the data version from chain.json, service name is rpc_$chain_name_$version
data_version=$(find_current_data_version)
[[ -z $rpc_service_name ]] && rpc_service_name="rpc_${chain_name}_${data_version}"


echo "read chain info:"
eval "$(curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini |awk -v TARGET=$chain_name -F ' = ' '
  {
    if ($0 ~ /^\[.*\]$/) {
      gsub(/^\[|\]$/, "", $0)
      SECTION=$0
    } else if (($2 != "") && (SECTION==TARGET)) {
      print $1 "=" $2
    }
  }
  ')"

echo "daemon_name=$daemon_name"
echo "start_flags=$start_flags"

local_peers=$(find_local_peers $chain_name)
new_start_flags=$(update_start_flags "$start_flags" "$local_peers")

echo "local_peers=$local_peers"
echo "new_start_flags=$new_start_flags"

$HOME/go/bin/$daemon_name start --db_backend=pebbledb $new_start_flags
