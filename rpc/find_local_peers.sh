chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./find_local_peers.sh cosmoshub"
  exit
fi


# requires to install dnsutils, inetutils, jq

# figure out local IP
local_ip=$(hostname -i)

# figure out all container IP of service
ips=$(dig +short "tasks.$chain_name" |sort)

# filter out local IP
ips=$(echo "$ips" |grep -v "$local_ip")

local_peers=""
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
echo "local_peers=$local_peers"