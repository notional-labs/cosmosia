#!/bin/bash

# GET ARGUMENTS
########################################################################################################################
export OPTION=$1

# SET BASIC FUNCTIONS
########################################################################################################################

# fetch new chain configuration
get_latest_env () {

# activate old env vars
echo "read chain info:"

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

# fix injective close-source
if [[ $git_repo == "https://github.com/InjectiveLabs/injective-core" ]]; then
  gh_access_token="$(curl -s "http://tasks.web_config/config/gh_access_token")"
  git_repo="https://${gh_access_token}@github.com/InjectiveLabs/injective-core"
fi

}

# get snapshot config functions
get_docker_snapshot_config () {
str_snapshot_cfg="$(curl -s "http://tasks.web_config/config/cosmosia.snapshot.${chain_name}" |sed 's/ = /=/g')"
echo $str_snapshot_cfg

# figure out IP of the snapshot_storage_node
snapshot_storage_node_ip=$(curl -s "http://tasks.web_config/node_ip/${snapshot_storage_node}")

# fetch snapshot configuration
str_snapshot_cfg=$(get_docker_snapshot_config)
echo "str_snapshot_cfg=${str_snapshot_cfg}"
eval "${str_snapshot_cfg}"
}

update_rpc_env () {
# remove old env vars
rm $HOME/env.sh

# write env vars to bash file, so that cronjobs or other scripts could know
cat <<EOT >> $HOME/env.sh
chain_name="$chain_name"
git_repo="$git_repo"
version="$version"
daemon_name="$daemon_name"
node_home="$node_home"
minimum_gas_prices="$minimum_gas_prices"
start_flags="$start_flags"
db_backend="$db_backend"
go_version="$go_version"
build_script="$build_script"
EOT

if [ $( echo "${chain_name}" | grep -cE "agoric" ) -ne 0 ]; then
  cat <<EOT >> ./env.sh
# fix agoric
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh" # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOT
fi

}

update_snapshot_env () {
# remove old env vars
rm $HOME/env.sh

# write env vars to bash file, so that cronjobs or other scripts could know
cat <<EOT >> $HOME/env.sh
chain_name="$chain_name"
git_repo="$git_repo"
version="$version"
daemon_name="$daemon_name"
node_home="$node_home"
minimum_gas_prices="$minimum_gas_prices"
start_flags="$start_flags"
snapshot_node="$snapshot_node"
snapshot_storage_node="$snapshot_storage_node"
snapshot_storage_node_ip="$snapshot_storage_node_ip"
snapshot_prune="$snapshot_prune"
db_backend="$db_backend"
go_version="$go_version"
build_script="$build_script"
EOT

if [ $( echo "${chain_name}" | grep -cE "agoric" ) -ne 0 ]; then
  cat <<EOT >> ./env.sh
# fix agoric
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh" # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOT
fi

}

update_start_script () {

# stop chain before update start script
supervisorctl stop chain
sleep 5

# remove old start chain script
rm $HOME/start_chain.sh

# start_chain.sh script
cat <<EOT >> $HOME/start_chain.sh
source $HOME/env.sh
# fix supervisorctl creates a dbus-daemon process everytime starting chain
killall dbus-daemon
$HOME/go/bin/$daemon_name start $start_flags 1>&2
EOT

# start chain after update start script
supervisorctl stop chain
sleep 5

}

# SET ADVANCE FUNTIONS
################################################################################
########################################
update_rpc_config () {
get_latest_env
update_rpc_env
update_start_script
}

update_snapshot_config () {
get_latest_env
get_docker_snapshot_config 
update_rpc_env
update_start_script
}

# SWITCH CASE PROCESS ARGUMENT AS OPTION
################################################################################
########################################

case $OPTION in
  "1")
    update_rpc_config
    ;;
  "2")
    update_snapshot_config
    ;;
  *)
    echo "Incorrect option. Only in [ 1: rpc, 2: snapshot ]"
    echo "Eg: ./update_config 1"
    echo "Eg: curl -Ls -o- https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/update_config.sh | bash -s -- 1"
    ;;
esac
