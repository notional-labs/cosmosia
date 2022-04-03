# usage: ./syncthing.run.sh syncthing_name

syncthing_name="$1"

if [[ -z $syncthing_name ]]
then
  echo "No syncthing_name. usage eg., ./syncthing.run.sh syncthing1"
  exit
fi

echo "#################################################################################################################"
echo "#prepare..."

pacman -Syu --noconfirm
pacman -S --noconfirm syncthing screen openssh


echo "extract config files from swarm secret..."

mkdir -p $HOME/tmp
tar -xvf "/run/secrets/$syncthing_name.tar.gz" -C $HOME/tmp/

#content of .tar.gz
: '
syncthing1/
syncthing1/ssh/
syncthing1/ssh/authorized_keys
syncthing1/ssh/ssh_host_rsa_key
syncthing1/ssh/ssh_host_ed25519_key
syncthing1/ssh/ssh_host_dsa_key.pub
syncthing1/ssh/ssh_host_dsa_key
syncthing1/ssh/ssh_host_ecdsa_key.pub
syncthing1/ssh/ssh_host_rsa_key.pub
syncthing1/ssh/ssh_host_ed25519_key.pub
syncthing1/ssh/ssh_host_ecdsa_key
syncthing1/syncthing/
syncthing1/syncthing/key.pem
syncthing1/syncthing/cert.pem
syncthing1/syncthing/config.xml
'

echo "#################################################################################################################"
echo "openssh..."

mkdir -p $HOME/.ssh
cp $HOME/tmp/syncthing1/ssh/authorized_keys $HOME/.ssh/
cp $HOME/tmp/syncthing1/ssh/ssh_host_* /etc/ssh/

# start sshd
/bin/sshd


echo "#################################################################################################################"
echo "syncthing..."

#run syncthing the 1st time to generate default config
screen -S syncthing -dm syncthing
sleep 30
killall syncthing
sleep 5
cp $HOME/tmp/syncthing1/syncthing/* $HOME/.config/syncthing/

# run syncthing again
syncthing


while true; do
  sleep 60
done
