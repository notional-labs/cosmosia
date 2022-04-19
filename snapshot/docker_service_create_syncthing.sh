# usage: ./docker_service_create_syncthing.sh syncthing_name
# syncthing_name must be syncthing1 or syncthing2
# eg., ./docker_service_create_syncthing.sh syncthing1

syncthing_name="$1"

if [[ -z $syncthing_name ]]
then
  echo "No syncthing_name. usage eg., ./docker_service_create_syncthing.sh syncthing1"
  exit
fi

git_branch=$(git symbolic-ref --short -q HEAD)


# delete existing service
docker service rm $syncthing_name


SSH_PORT="2022:22"
HOST="cosmosia5"
if [[ "$syncthing_name" == "syncthing2" ]]; then
  SSH_PORT="2023:22"
  HOST="cosmosia3"
fi

docker service create \
  --name $syncthing_name \
  --mount type=bind,source=/mnt/data/syncthing,destination=/data \
  --replicas 1 \
  --network cosmosia \
  --publish $SSH_PORT \
  --constraint "node.hostname==$HOST" \
  --restart-condition any \
  --restart-delay 3m \
  --restart-max-attempts 3 \
  --restart-window 10m \
  --secret $syncthing_name.tar.gz \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/baabeetaa/cosmosia/$git_branch/snapshot/syncthing_run.sh > ~/run.sh &&
  /bin/bash ~/run.sh $syncthing_name"
