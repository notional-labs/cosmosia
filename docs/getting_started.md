## Getting Started

Tutorial to setup a single node cluster. Keep it as simple as possible for getting started.

Environment:
- OS: ArchLinux
- docker is installed



```console
pacman -Sy git nano jq

mkdir -p /mnt/data
mkdir -p /mnt/data/docker

mkdir -p /etc/docker
cat <<EOT > /etc/docker/daemon.json
{
  "data-root": "/mnt/data/docker",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOT

systemctl restart docker
docker swarm init

docker network create -d overlay --attachable cosmosia
docker network create -d overlay --attachable agent
docker network create -d overlay --attachable snapshot
docker network create -d overlay --attachable net1
docker network create -d overlay --attachable net2
docker network create -d overlay --attachable net3
docker network create -d overlay --attachable net4
docker network create -d overlay --attachable net5
docker network create -d overlay --attachable net6
docker network create -d overlay --attachable net7
docker network create -d overlay --attachable net8


cd ~/
git clone https://github.com/notional-labs/cosmosia
cd ~/cosmosia
cp env.sample.sh env.sh
```

set label to control which swarm nodes will run pruned rpcs. In this test, there is only one swarm-node named `cosmosia38`
```
[root@cosmosia38 data]# docker node ls
ID                            HOSTNAME     STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
yioc5mq44rq6vi0cct2zeclo9 *   cosmosia38   Ready     Active         Leader           24.0.0
```

```
docker node update --label-add cosmosia.rpc.pruned=true cosmosia38
```

lets deploy a rpc service, in this example we'll deploy a pruned node for `composable`  chain
```
cd ~/cosmosia/rpc/
[root@cosmosia38 rpc]# sh docker_service_create.sh composable
```

check running services:
```
docker service ls
ID             NAME               MODE         REPLICAS   IMAGE              PORTS
p74zgtmxrs8p   rpc_composable_5   replicated   1/1        archlinux:latest
```

`rpc_composable_5` is the service.
It could take a while to init and downloading snapshot, maybe 5 mins or 30 mins depending on internet speed.

Now deploy load-balancer for this rpc service. In this test, it does not make much sense to have load-balancer with single instance. However, Its usefull when you want to add more instances later wihout break the architecture.

set label to control which swarm nodes will run load-balancer services:
```
docker node update --label-add cosmosia.lb=true cosmosia38
```
then
```
cd ~/cosmosia/load_balancer/
sh docker_service_create.sh composable rpc_composable_5 haproxy
```

check running services:
```console
 docker service ls
ID             NAME               MODE         REPLICAS   IMAGE              PORTS
ldrqnj7fusi2   lb_composable      replicated   1/1        archlinux:latest
p74zgtmxrs8p   rpc_composable_5   replicated   1/1        archlinux:latest
```

The last task is to run a proxy service so you could able to access the rpc service from outside.

set label to control which swarm nodes will run the legacy proxy service:
```
docker node update --label-add cosmosia.proxy.legacy=true cosmosia38
```

deploy legacy proxy service:
```
cd ~/cosmosia/proxy/legacy/
sh docker_service_create.sh
```

Now you can access rpc endpoints at `http://PUBLIC_IP_OF_SWARM_NODE/composable/`
