# cosmosia (Cosmos Infrastructure Automation)
Build a reliable infrastructure for cosmos/tendermint based chains.

https://github.com/cosmos/chain-registry/issues/214

---

- Use Docker Swarm
- Rpc service
- Relay service
- Snapshot service?

---
### Setup a cluster and cosmosia
See [prepare.md](./docs/prepare.md)

### Rpc service
To create a RPC service, execute on Swarm manager node:

```bash
bash ./rpc/docker_service_create.sh cosmoshub
```

Supported chains:
1. Osmosis
2. Starname
3. Regen
4. Akash
5. Gaia
6. Sentinel
7. E-Money
8. Ixo
9. Juno
10. Sifchain
11. Likecoin
12. Ki
13. Cyber
14. Cheqd
15. Stargaze
16. Band
17. Chihuahua
18. Kava
19. BitCanna
20. Konstellation
21. Omniflix
22. Terra


### Add a new chain
Create a MR adding it to [chain_registry.ini](./data/chain_registry.ini)
