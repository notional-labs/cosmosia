chain_name="$1"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./find_local_peers.sh cosmoshub"
  exit
fi


# requires to install dnsutils,inetutils

# figure out all container IP of service
ips=$(dig +short "tasks.$chain_name" |sort)

# figure out local IP
local_ip=$(hostname -i)

# filter out local_ip from $ips

local_peers=$(echo "$ips" |grep -v "$local_ip")

# show result
echo "ips=$ips"
echo "local_ip=$local_ip"
echo "local_peers=$local_peers"