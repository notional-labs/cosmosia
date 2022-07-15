# cosmosia (Cosmos Infrastructure Automation)

Open solution to build a reliable infrastructure for cosmos/tendermint based chains ( see [background](https://github.com/cosmos/chain-registry/issues/214) ):
- API service: Load balancing for Rpc, Rest, Websocket, [GRPC](docs/grpc.md) and JSON-RPC with active-healthcheck, rate-limiting and ip-whitelist.
- Daily [snapshot service](https://snapshot.notional.ventures/) for goleveldb and [rocksdb](/docs/rocksdb.md)
- Monitoring tools for both [internal](docs/rpc_monitor.md) and [external](https://status.notional.ventures/) view.
- Auto pruning and rpc service with snapshot/data versioning

See [status page](https://status.notional.ventures/) of our cluster.

### Supported chains:
1. Akash (akash)
2. ~~AssetMantle (assetmantle)~~
3. Axelar (axelar)
4. Band (bandchain)
5. BitCanna (bitcanna)
6. BitSong (bitsong)
7. Cerberus (cerberus)
8. Cheqd (cheqd)
9. Chihuahua (chihuahua)
10. Comdex (comdex)
11. Crypto.org (cryptoorgchain)
12. Cyber (cyber)
13. Dig (dig)
14. E-Money (emoney)
15. Evmos (evmos)
16. FetchAI (fetchhub)
17. Gaia (cosmoshub)
18. Gravity-Bridge (gravitybridge)
19. IRISnet (irisnet)
20. Ixo (ixo)
21. Juno (juno)
22. Kava (kava)
23. Ki (kichain)
24. Konstellation (konstellation)
25. Likecoin (likecoin)
26. Omniflix (omniflixhub)
27. Osmosis (osmosis)
28. Persistence (persistent)
29. Provenance (provenance)
30. Pylons Testnet (pylons)
31. Regen (regen)
32. Sei-Chain Testnet (sei)
33. Sentinel (sentinel)
34. Sifchain (sifchain)
35. Stargaze (stargaze)
36. Starname (starname)
37. Terra (terra)
38. Umee (umee)
39. Vidulum (vidulum)



Add a new chain? Follow this [guide](docs/new_chain.md)

### Docs
See [Docs](./docs/)
