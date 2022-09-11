### hardware
Our servers specs:
- CPU: AMD Ryzen™ 9 5950X
- RAM: 128 GB
- Disk: 2 x 3.84 TB NVMe


### setup swarm cluster
Follow [Getting started with swarm mode](https://docs.docker.com/engine/swarm/swarm-tutorial/) tutorial to setup a swarm cluster

```bash
# set utc timezone
timedatectl set-timezone UTC

# set resource limits
echo "root hard nofile 500000" >> /etc/security/limits.conf
echo "root soft nofile 500000" >> /etc/security/limits.conf
echo "* hard nofile  500000" >> /etc/security/limits.conf
echo "* soft nofile 500000" >> /etc/security/limits.conf
```

Settings
```bash
docker swarm update --task-history-limit 0
```

#### config log rotation
- config log rotation on all swarm nodes by editing (creating if not exist) the file `/etc/docker/daemon.json` with the content bellow.
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

- Then restart docker:
```bash
systemctl restart docker
```

### setup cosmosia

- create overlay networks:

```bash
# https://github.com/notional-labs/cosmosia/issues/134

# cosmosia overlay network used for loadbalance and proxy
docker network create -d overlay --attachable cosmosia

# create an overlay network for snapshot service
docker network create -d overlay --attachable snapshot

# create 8 overlay networks for rpc services
docker network create -d overlay --attachable net1
docker network create -d overlay --attachable net2
docker network create -d overlay --attachable net3
docker network create -d overlay --attachable net4
docker network create -d overlay --attachable net5
docker network create -d overlay --attachable net6
docker network create -d overlay --attachable net7
docker network create -d overlay --attachable net8
```

- clone repos to a manager node to $HOME:
```bash
cd $HOME
git clone https://github.com/notional-labs/cosmosia
```

### LVM
see [LVM](./lvm.md)
