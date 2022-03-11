# cosmosia
Cosmos Infrastructure Automation

https://github.com/cosmos/chain-registry/issues/214


## Phases
Break into 2 phases to make it easier:
- Phase 1: Bring up the cluster without “enterprise grade features” (like HA, data redundancy, rate limiting…)
- Phase 2: Focus on the “enterprise grade features”


## Services
Services run on docker swarm

### proxy service
The reason for using the proxy service is: docker swarm routing mesh does not support load-balancing ws with sticky sessions.

using caddy/nginx, running on swarm with replica=1. It's not 100% uptime, but downtime is very low.

There are 2 separated services for internal and public as the public apis need https/wss, rate limiting…. while the internal apis don't need these features.

Note: need to automate hot reload the config as the backends are containers on the swarm and IPs are dynamic. 


### Rpc services
Each chain needs a rpc service. There are ~50 chains.
Limit in phrase 1: run 2-3 chains only

Use quicksync only. Maybe switch to statesync in later version as statesync does not work reliable atm, it depends on rpc nodes with snapshot enabled. 


### Relay service

Support 2-3 chains only in phase 1.
