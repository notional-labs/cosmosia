# usage: ./docker_service_rm.sh chain_name [-d]
# eg., ./docker_service_rm.sh cosmoshub
# use -d to delete the data

chain_name="$1"

if [ -f "../env.sh" ]; then
  source ../env.sh
else
    echo "../env.sh file does not exist."
    exit
fi

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./docker_service_rm.sh cosmoshub [-d]"
  exit
fi

# note: have to call shift to fix the issue that getopts doesn't work there are both params ($1) and the options
shift
opt_clear_data=false

OPTSTRING=":d"
# d: delete existing data, default is false

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    d)
      echo "opt_clear_data Option -d was triggered."
      opt_clear_data=true
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

# functions
get_docker_snapshot_config () {
  str_snapshot_cfg=""

  if [ -f /.dockerenv ]; then
    # inside container
    str_snapshot_cfg="$(curl -s "http://tasks.web_config/config/cosmosia.snapshot.${chain_name}" |sed 's/ = /=/g')"
  else
    # inside host

    # figure out container id of agent
    agent_id=$(docker ps -aqf "name=agent")

    # execute command in agent container to get data version
    str_snapshot_cfg=$(docker exec $agent_id curl -s "http://tasks.web_config/config/cosmosia.snapshot.${chain_name}" |sed 's/ = /=/g')
  fi

  echo $str_snapshot_cfg
}

# to get the url to the config file
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

echo "config=$config"
# load config
eval "$(curl -s "$config" |sed 's/ = /=/g')"

str_snapshot_cfg=$(get_docker_snapshot_config)
echo "str_snapshot_cfg=${str_snapshot_cfg}"
eval "${str_snapshot_cfg}"
echo "network=$network"

SERVICE_NAME="snapshot_$chain_name"

# figure out IP of the remote host
agent_id=$(docker ps -aqf "name=agent")
snapshot_node_ip=$(docker exec $agent_id curl -s "http://tasks.web_config:2375/nodes/${snapshot_node}" |jq -r ".Status.Addr")

# delete existing service
docker service rm $SERVICE_NAME

echo "sleep 20s..."
sleep 20

echo "opt_clear_data = $opt_clear_data"
if [ "$opt_clear_data" = true ] ; then
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${snapshot_node_ip} "rm -rf /mnt/data/rpc/${chain_name}"
fi
