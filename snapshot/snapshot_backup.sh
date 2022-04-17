

# Daily snapshots are created and stored on container and data is lost when container reset.
# This script copy a backup to the `syncthing` weekly for persistence.
# Data store in `syncthing` is replated 2x on 2 nodes (active/backup) so data is safe.
# This script is to copy snapshot data from container to `syncthing` active node.


source $HOME/chain_info.sh

########################################################################################################################

# Check if is there any snapshot on syncthing
snapshot_url=$(curl --silent --max-time 3 "http://syncthing1/$chain_name/chain.json" |jq -r .snapshot_url)

if [[ "${snapshot_url}" == "null" ]]; then
  # There is no backup on syncthing => need to copy
  scp -prq -i ~/.ssh/cosmosia/id_rsa /snapshot/* root@syncthing1:/data/default/$chain_name/

  exit 0
fi


# There is another backup, compare date
date_str=${snapshot_url##*/data_}
date_str=${date_str%%_*}

snapshot_date=$(date -jf '%Y%m%d' $date_str +%s)
current_secs=`date +%s`
diff_secs=$((${current_secs} - ${snapshot_date}))

# 7 days
THRESHOLD_TIME=604800
if [[ ${diff_secs} -le ${THRESHOLD_TIME} ]]; then
  # no need to copy data, exit

  exit 0
fi

# copy new snapshot
scp -prq -i ~/.ssh/cosmosia/id_rsa /snapshot/* root@syncthing1:/data/default/$chain_name/

