# cosmosia (Cosmos Infrastructure Automation)

Open solution to build a reliable infrastructure for cosmos/tendermint based chains ( see [background](https://github.com/cosmos/chain-registry/issues/214) ):
- API service: Load balancing for Rpc, Rest, Websocket, [GRPC](docs/grpc.md) and JSON-RPC with active-healthcheck, rate-limiting and ip-whitelist.
- Daily [snapshot service](https://snapshot.notional.ventures/) for goleveldb and [rocksdb](/docs/rocksdb.md)
- Monitoring tools for both [internal](docs/rpc_monitor.md) and [external](https://status.notional.ventures/) view.
- Auto [pruning](https://github.com/notional-labs/cosmprund) and rpc service with snapshot/data versioning

See [status page](https://status.notional.ventures/) of our cluster.

### Supported chains:
| No  | Chain | Public RPC | [Statesync](docs/statesync.md) | [RocksDB](docs/rocksdb.md)
|:--- |:------|:----------:|:------------------------------:|:-------------------------:|
| 1. | Osmosis (osmosis)       | :link: | :x: | 
| 2. | Starname (starname)     | :link: |  :x: | 
| 3. | Regen (regen)           | :link: |  :white_check_mark: | :warning:
| 4. | Akash (akash)           | :link: |  :white_check_mark: | :white_check_mark:
| 5. | Gaia (cosmoshub)        | :link: |  :white_check_mark: | :white_check_mark:
| 6. | Sentinel (sentinel)     | :link: |  :white_check_mark: | :white_check_mark:
| 7. | E-Money (emoney)        | :link: |  :white_check_mark: | :white_check_mark:
| 8. | Ixo (ixo)               | :link: |  :white_check_mark: | :white_check_mark:
| 9. | Juno (juno)             | :link: |  :x: | 
| 10. | Sifchain (sifchain)    | :link: |  :white_check_mark: | :white_check_mark:
| 11. | Likecoin (likecoin)    | :link: |  :white_check_mark: | :white_check_mark:
| 12. | Ki (kichain)           | :link: |  :white_check_mark: | :white_check_mark:
| 13. | Cyber (cyber)          | :link: |  :x: | 
| 14. | Cheqd (cheqd)          | :link: |  :x: | 
| 15. | Stargaze (stargaze)    | :link: |  :x: | 
| 16. | Band (bandchain)       | :link: |  :white_check_mark: | :white_check_mark:
| 17. | Chihuahua (chihuahua)  | :link: |  :white_check_mark: | :white_check_mark:
| 18. | Kava (kava)            | :link: |  :white_check_mark: | :white_check_mark:
| 19. | BitCanna (bitcanna)    | :link: |  :white_check_mark: | :white_check_mark:
| 20. | Konstellation (konstellation) | :link: |  :white_check_mark: | :white_check_mark:
| 21. | Omniflix (omniflixhub) | :link: |  :white_check_mark: | :white_check_mark:
| 22. | Terra (terra)          | :link: |  :x: | 
| 23. | Vidulum (vidulum)      | :link: |  :white_check_mark: | :white_check_mark:
| 24. | Provenance (provenance) | :link: |  :white_check_mark: | :white_check_mark:
| 25. | Dig (dig)               | :link: |  :white_check_mark: | :white_check_mark:
| 26. | Gravity-Bridge (gravitybridge) | :link: |  :white_check_mark: | :white_check_mark:  
| 27. | Comdex (comdex)        | :link: |  :white_check_mark: | :white_check_mark:
| 28. | Cerberus (cerberus)    | :link: |  :white_check_mark: | :white_check_mark:
| 29. | BitSong (bitsong)      | :link: |  :white_check_mark: | :white_check_mark:
| 30. | ~~AssetMantle (assetmantle)~~ | :link: |  :white_check_mark: | :white_check_mark: 
| 31. | FetchAI (fetchhub)     | :link: |  :x: | 
| 32. | Evmos (evmos)          | :link: |  :white_check_mark: | :white_check_mark: 
| 33. | Persistence (persistent) | :link: |  :white_check_mark: | :warning:
| 34. | Crypto.org (cryptoorgchain) | :link: |  :white_check_mark: | :white_check_mark:
| 35. | IRISnet (irisnet)      | :link: |  :white_check_mark: | :white_check_mark:
| 36. | Axelar (axelar)        | :link: |  :white_check_mark: | :warning:
| 37. | Pylons Testnet (pylons) | :link: |  :white_check_mark: | 
| 38. | Umee (umee)            | :link: |  :white_check_mark: | 
| 39. | Sei-Chain Testnet (sei) | :link: |   | 



Add a new chain? Follow this [guide](docs/new_chain.md)

### Docs
See [Docs](./docs/)
