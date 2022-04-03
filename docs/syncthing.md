# Syncthing

Snapshot data for each chain is created daily and the old data is deleted. So no need for a complex storage solution to
store snapshot data. We run a couple of [syncthing](https://syncthing.net/) services on the swarm. Syncthing is 
bi-direction, but we use them as active/backup. 

It is flexible if we want to add mirrors later in case public snapshot service eats too much bandwidth which may impact
rpc service.

`syncthing1` is the active node, `syncthing2` is the backup node. 

On each syncthing node, nginx also installed. So that a proxy service could use both node to provide HA.

Copy snapshot to the syncthing storage using `ssh`.

All keys, sensitive config files are stored in [docker swarm secret](https://docs.docker.com/engine/swarm/secrets/).

Each physical swarm node has only 1Gb port, so bandwidth used for syncthing is limited ~50% only. Rpc services will be 
 impacted less.
