# cosmosia (Cosmos Infrastructure Automation)
Build a reliable infrastructure for cosmos/tendermint based chains.

https://github.com/cosmos/chain-registry/issues/214

---

- Use Docker Swarm
- Rpc service
- Relay service
- Snapshot service?


---
### Rpc service
To create a RPC service, execute on Swarm manager node:

```bash
bash ./rpc/docker_service_create.sh cosmoshub
```

See supported chains in [chain_registry.ini](./data/chain_registry.ini)


### Add a new chain
Create a MR adding it to [chain_registry.ini](./data/chain_registry.ini)