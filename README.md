# cosmosia (Cosmos Infrastructure Automation)

Open solution to build a reliable infrastructure for cosmos/tendermint based chains ( see [background](https://github.com/cosmos/chain-registry/issues/214) ):
- API service: Load balancing for Rpc, Rest, Websocket, [GRPC](docs/grpc.md) and JSON-RPC with active-healthcheck, rate-limiting and ip-whitelist.
- Daily [snapshot service](https://snapshot.notional.ventures/) for goleveldb and [rocksdb](/docs/rocksdb.md)
- Monitoring tools for both [internal](docs/rpc_monitor.md) and [external](https://status.notional.ventures/) view.
- Auto pruning and rpc service with snapshot/data versioning

See [status page](https://status.notional.ventures/) of our cluster.

### Supported chains:
1. Osmosis (osmosis)
2. Starname (starname)
3. Regen (regen)
4. Akash (akash)
5. Gaia (cosmoshub)
6. Sentinel (sentinel)
7. E-Money (emoney)
8. Ixo (ixo)
9. Juno (juno)
10. Sifchain (sifchain)
11. Likecoin (likecoin)
12. Ki (kichain)
13. Cyber (cyber)
14. Cheqd (cheqd)
15. Stargaze (stargaze)
16. Band (bandchain)
17. Chihuahua (chihuahua)
18. Kava (kava)
19. BitCanna (bitcanna)
20. Konstellation (konstellation)
21. Omniflix (omniflixhub)
22. Terra (terra)
23. Vidulum (vidulum)
24. Provenance (provenance)
25. Dig (dig)
26. Gravity-Bridge (gravitybridge)
27. Comdex (comdex)
28. Cerberus (cerberus)
29. BitSong (bitsong)
30. ~~AssetMantle (assetmantle)~~
31. FetchAI (fetchhub)
32. Evmos (evmos)
33. Persistence (persistent)
34. Crypto.org (cryptoorgchain)
35. IRISnet (irisnet)
36. Axelar (axelar)
37. Pylons Testnet (pylons)
38. Umee (umee)
39. Sei-Chain Testnet (sei)



Add a new chain? Follow this [guide](docs/new_chain.md)

### Docs
See [Docs](./docs/)