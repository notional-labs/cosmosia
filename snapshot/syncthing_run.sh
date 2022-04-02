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
pacman -S --noconfirm syncthing

echo "#################################################################################################################"
echo "#config syncthing..."

echo "run syncthing the 1st time to generate default config"
syncthing
sleep 30

echo "kill syncthing"
killall syncthing
sleep 5

echo "extract config files from swarm secret"
tar -xvf "/run/secrets/$syncthing_name.tar.gz" -C $HOME/.config/syncthing/

echo "#################################################################################################################"
echo "run syncthing"
syncthing

while true; do
  # sleep 60 seconds...
  sleep 60
done
