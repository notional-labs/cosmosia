### setup swarm cluster
Follow [Getting started with swarm mode](https://docs.docker.com/engine/swarm/swarm-tutorial/) tutorial to setup a swarm cluster

### setup cosmosia

- create `cosmosia` overlay network:

```bash
docker network create -d overlay --attachable cosmosia
```

- clone repos to a manager node:
```bash
https://github.com/baabeetaa/cosmosia
```

