### setup swarm cluster
Follow [Getting started with swarm mode](https://docs.docker.com/engine/swarm/swarm-tutorial/) tutorial to setup a swarm cluster

#### set resource limits
```bash
echo "root hard nofile 150000" >> /etc/security/limits.conf
echo "root soft nofile 150000" >> /etc/security/limits.conf
echo "* hard nofile  150000" >> /etc/security/limits.conf
echo "* soft nofile 150000" >> /etc/security/limits.conf
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

- create `cosmosia` overlay network:

```bash
docker network create -d overlay --attachable cosmosia
```

- clone repos to a manager node to $HOME:
```bash
cd $HOME
git clone https://github.com/baabeetaa/cosmosia
```

