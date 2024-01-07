# usage: ./create_snapshot_from_rpc.sh <remote_ip>
# eg., ./create_snapshot_from_rpc.sh 37.27.68.154

remote_ip="$1"

if [[ -z $remote_ip ]]; then
  echo "No remote_ip. Exit"
  exit
fi

mkdir -p $HOME/.ssh
curl -Ls http://tasks.web_config/config/cosmosia.id_rsa.pub > $HOME/.ssh/id_rsa.pub
curl -Ls http://tasks.web_config/config/cosmosia.id_rsa > $HOME/.ssh/id_rsa
chmod -R 700 ~/.ssh

pacman -Sy --noconfirm openssh pigz

supervisorctl stop chain
sleep 5

source $HOME/env.sh

echo "#################################################################################################################"
echo "creating snapshot file..."
cd $node_home

TAR_FILENAME="data_$(date +%Y%m%d_%T |sed 's/://g').tar.gz"

# snapshot file includes ALL dirs in $node_home excluding config dir
included_dirs=$(ls -d * |grep -v config| tr '\n' ' ')

tar -cvf - $included_dirs |pigz --best -p8 |ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${remote_ip} "cat > /mnt/data/snapshots/${chain_name}/${TAR_FILENAME}"


FILESIZE=0
FILESIZE=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${remote_ip} stat -c%s "/mnt/data/snapshots/${chain_name}/${TAR_FILENAME}")
if [[ -z $FILESIZE ]]; then
  FILESIZE=0
fi

cat <<EOT > $HOME/chain.json
{
    "snapshot_url": "http://${remote_ip}:11111/$chain_name/$TAR_FILENAME",
    "file_size": $FILESIZE,
    "data_version": 0
}
EOT


scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -prq "$HOME/chain.json" "root@${remote_ip}:/mnt/data/snapshots/${chain_name}/"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${remote_ip} "cd /mnt/data/snapshots/${chain_name}/ && rm \$(ls *.tar.gz |sort |head -n -2)"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -prq "${node_home}/config/genesis.json" "root@${remote_ip}:/mnt/data/snapshots/${chain_name}/"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -prq "${node_home}/config/addrbook.json" "root@${remote_ip}:/mnt/data/snapshots/${chain_name}/"