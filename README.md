# cosmosia (Cosmos Infrastructure Automation)

Open solution to build a reliable infrastructure for cosmos/tendermint based chains ( see [background](https://github.com/cosmos/chain-registry/issues/214) ):
- API service: Load balancing for Rpc, Rest, Websocket, [GRPC](docs/grpc.md) and JSON-RPC with active-healthcheck, rate-limiting and ip-whitelist.
- Daily [snapshot service](https://snapshot.notional.ventures/) for [pebbledb](docs/pebbledb.md)
- Monitoring tools for both [internal](docs/rpc_monitor.md) and [external](https://status.notional.ventures/) view.
- Auto [pruning](https://github.com/notional-labs/cosmprund) and rpc service with snapshot/data versioning

See [status page](https://status.notional.ventures/) of our cluster.

### Supported chains:
| No | Chain                                            | Snapshot                                                                       | Public<br>RPC                                                                         | Public<br>API                                                                         | Public<br>GRPC                                                                         | [Statesync](docs/statesync.md) |
|---:|:-------------------------------------------------|:------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------:|:------------------------------:|
| 1  | Osmosis<br>(osmosis)                             | [<sub>:link:</sub>](https://snapshot.notional.ventures/osmosis/)               | [<sub>:link:</sub>](https://rpc-osmosis-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://api-osmosis-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://grpc-osmosis-ia.cosmosia.notional.ventures/)               | :x:                            | 
| 2  | Starname<br>(starname)                           | [<sub>:link:</sub>](https://snapshot.notional.ventures/starname/)              | [<sub>:link:</sub>](https://rpc-starname-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://api-starname-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://grpc-starname-ia.cosmosia.notional.ventures/)              | :x:                            |
| 3  | Regen<br>(regen)                                 | [<sub>:link:</sub>](https://snapshot.notional.ventures/regen/)                 | [<sub>:link:</sub>](https://rpc-regen-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://api-regen-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://grpc-regen-ia.cosmosia.notional.ventures/)                 | :white_check_mark:             |
| 4  | Akash<br>(akash)                                 | [<sub>:link:</sub>](https://snapshot.notional.ventures/akash/)                 | [<sub>:link:</sub>](https://rpc-akash-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://api-akash-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://grpc-akash-ia.cosmosia.notional.ventures/)                 | :white_check_mark:             |
| 5  | Gaia<br>(cosmoshub)                              | [<sub>:link:</sub>](https://snapshot.notional.ventures/cosmoshub/)             | [<sub>:link:</sub>](https://rpc-cosmoshub-ia.cosmosia.notional.ventures/)             | [<sub>:link:</sub>](https://api-cosmoshub-ia.cosmosia.notional.ventures/)             | [<sub>:link:</sub>](https://grpc-cosmoshub-ia.cosmosia.notional.ventures/)             | :white_check_mark:             |
| 6  | Sentinel<br>(sentinel)                           | [<sub>:link:</sub>](https://snapshot.notional.ventures/sentinel/)              | [<sub>:link:</sub>](https://rpc-sentinel-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://api-sentinel-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://grpc-sentinel-ia.cosmosia.notional.ventures/)              | :white_check_mark:             |
| 7  | E-Money<br>(emoney)                              | [<sub>:link:</sub>](https://snapshot.notional.ventures/emoney/)                | [<sub>:link:</sub>](https://rpc-emoney-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://api-emoney-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://grpc-emoney-ia.cosmosia.notional.ventures/)                | :white_check_mark:             |
| 8  | Ixo<br>(ixo)                                     | [<sub>:link:</sub>](https://snapshot.notional.ventures/ixo/)                   | [<sub>:link:</sub>](https://rpc-ixo-ia.cosmosia.notional.ventures/)                   | [<sub>:link:</sub>](https://api-ixo-ia.cosmosia.notional.ventures/)                   | [<sub>:link:</sub>](https://grpc-ixo-ia.cosmosia.notional.ventures/)                   | :white_check_mark:             |
| 9  | Juno<br>(juno)                                   | [<sub>:link:</sub>](https://snapshot.notional.ventures/juno/)                  | [<sub>:link:</sub>](https://rpc-juno-ia.cosmosia.notional.ventures/)                  | [<sub>:link:</sub>](https://api-juno-ia.cosmosia.notional.ventures/)                  | [<sub>:link:</sub>](https://grpc-juno-ia.cosmosia.notional.ventures/)                  | :x:                            |
| 10 | Sifchain<br>(sifchain)                           | [<sub>:link:</sub>](https://snapshot.notional.ventures/sifchain/)              | [<sub>:link:</sub>](https://rpc-sifchain-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://api-sifchain-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://grpc-sifchain-ia.cosmosia.notional.ventures/)              | :white_check_mark:             |
| 11 | Likecoin<br>(likecoin)                           | [<sub>:link:</sub>](https://snapshot.notional.ventures/likecoin/)              | [<sub>:link:</sub>](https://rpc-likecoin-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://api-likecoin-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://grpc-likecoin-ia.cosmosia.notional.ventures/)              | :white_check_mark:             |
| 12 | Ki<br>(kichain)                                  | [<sub>:link:</sub>](https://snapshot.notional.ventures/kichain/)               | [<sub>:link:</sub>](https://rpc-kichain-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://api-kichain-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://grpc-kichain-ia.cosmosia.notional.ventures/)               | :white_check_mark:             |
| 13 | Cyber<br>(cyber)                                 | [<sub>:link:</sub>](https://snapshot.notional.ventures/cyber/)                 | [<sub>:link:</sub>](https://rpc-cyber-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://api-cyber-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://grpc-cyber-ia.cosmosia.notional.ventures/)                 | :x:                            |
| 14 | Cheqd<br>(cheqd)                                 | [<sub>:link:</sub>](https://snapshot.notional.ventures/cheqd/)                 | [<sub>:link:</sub>](https://rpc-cheqd-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://api-cheqd-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://grpc-cheqd-ia.cosmosia.notional.ventures/)                 | :x:                            |
| 15 | Stargaze<br>(stargaze)                           | [<sub>:link:</sub>](https://snapshot.notional.ventures/stargaze/)              | [<sub>:link:</sub>](https://rpc-stargaze-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://api-stargaze-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://grpc-stargaze-ia.cosmosia.notional.ventures/)              | :x:                            |
| 16 | Band<br>(bandchain)                              | [<sub>:link:</sub>](https://snapshot.notional.ventures/bandchain/)             | [<sub>:link:</sub>](https://rpc-bandchain-ia.cosmosia.notional.ventures/)             | [<sub>:link:</sub>](https://api-bandchain-ia.cosmosia.notional.ventures/)             | [<sub>:link:</sub>](https://grpc-bandchain-ia.cosmosia.notional.ventures/)             | :white_check_mark:             |
| 17 | Chihuahua<br>(chihuahua)                         | [<sub>:link:</sub>](https://snapshot.notional.ventures/chihuahua/)             | [<sub>:link:</sub>](https://rpc-chihuahua-ia.cosmosia.notional.ventures/)             | [<sub>:link:</sub>](https://api-chihuahua-ia.cosmosia.notional.ventures/)             | [<sub>:link:</sub>](https://grpc-chihuahua-ia.cosmosia.notional.ventures/)             | :white_check_mark:             |
| 18 | Kava<br>(kava)                                   | [<sub>:link:</sub>](https://snapshot.notional.ventures/kava/)                  | [<sub>:link:</sub>](https://rpc-kava-ia.cosmosia.notional.ventures/)                  | [<sub>:link:</sub>](https://api-kava-ia.cosmosia.notional.ventures/)                  | [<sub>:link:</sub>](https://grpc-kava-ia.cosmosia.notional.ventures/)                  | :white_check_mark:             |
| 19 | BitCanna<br>(bitcanna)                           | [<sub>:link:</sub>](https://snapshot.notional.ventures/bitcanna/)              | [<sub>:link:</sub>](https://rpc-bitcanna-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://api-bitcanna-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://grpc-bitcanna-ia.cosmosia.notional.ventures/)              | :white_check_mark:             |
| 20 | Konstellation<br>(konstellation)                 | [<sub>:link:</sub>](https://snapshot.notional.ventures/konstellation/)         | [<sub>:link:</sub>](https://rpc-konstellation-ia.cosmosia.notional.ventures/)         | [<sub>:link:</sub>](https://api-konstellation-ia.cosmosia.notional.ventures/)         | [<sub>:link:</sub>](https://grpc-konstellation-ia.cosmosia.notional.ventures/)         | :white_check_mark:             |
| 21 | Omniflix<br>(omniflixhub)                        | [<sub>:link:</sub>](https://snapshot.notional.ventures/omniflixhub/)           | [<sub>:link:</sub>](https://rpc-omniflixhub-ia.cosmosia.notional.ventures/)           | [<sub>:link:</sub>](https://api-omniflixhub-ia.cosmosia.notional.ventures/)           | [<sub>:link:</sub>](https://grpc-omniflixhub-ia.cosmosia.notional.ventures/)           | :white_check_mark:             |
| 22 | Terra<br>(terra)                                 | [<sub>:link:</sub>](https://snapshot.notional.ventures/terra/)                 | [<sub>:link:</sub>](https://rpc-terra-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://api-terra-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://grpc-terra-ia.cosmosia.notional.ventures/)                 | :x:                            |
| 23 | Vidulum<br>(vidulum)                             | [<sub>:link:</sub>](https://snapshot.notional.ventures/vidulum/)               | [<sub>:link:</sub>](https://rpc-vidulum-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://api-vidulum-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://grpc-vidulum-ia.cosmosia.notional.ventures/)               | :white_check_mark:             |
| 24 | Provenance<br>(provenance)                       | [<sub>:link:</sub>](https://snapshot.notional.ventures/provenance/)            | [<sub>:link:</sub>](https://rpc-provenance-ia.cosmosia.notional.ventures/)            | [<sub>:link:</sub>](https://api-provenance-ia.cosmosia.notional.ventures/)            | [<sub>:link:</sub>](https://grpc-provenance-ia.cosmosia.notional.ventures/)            | :white_check_mark:             |
| 25 | Dig<br>(dig)                                     | [<sub>:link:</sub>](https://snapshot.notional.ventures/dig/)                   | [<sub>:link:</sub>](https://rpc-dig-ia.cosmosia.notional.ventures/)                   | [<sub>:link:</sub>](https://api-dig-ia.cosmosia.notional.ventures/)                   | [<sub>:link:</sub>](https://grpc-dig-ia.cosmosia.notional.ventures/)                   | :white_check_mark:             |
| 26 | Gravity-Bridge<br>(gravitybridge)                | [<sub>:link:</sub>](https://snapshot.notional.ventures/gravitybridge/)         | [<sub>:link:</sub>](https://rpc-gravitybridge-ia.cosmosia.notional.ventures/)         | [<sub>:link:</sub>](https://api-gravitybridge-ia.cosmosia.notional.ventures/)         | [<sub>:link:</sub>](https://grpc-gravitybridge-ia.cosmosia.notional.ventures/)         | :white_check_mark:             |  
| 27 | Comdex<br>(comdex)                               | [<sub>:link:</sub>](https://snapshot.notional.ventures/comdex/)                | [<sub>:link:</sub>](https://rpc-comdex-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://api-comdex-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://grpc-comdex-ia.cosmosia.notional.ventures/)                | :white_check_mark:             |
| 28 | Cerberus<br>(cerberus)                           | [<sub>:link:</sub>](https://snapshot.notional.ventures/cerberus/)              | [<sub>:link:</sub>](https://rpc-cerberus-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://api-cerberus-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://grpc-cerberus-ia.cosmosia.notional.ventures/)              | :white_check_mark:             |
| 29 | BitSong<br>(bitsong)                             | [<sub>:link:</sub>](https://snapshot.notional.ventures/bitsong/)               | [<sub>:link:</sub>](https://rpc-bitsong-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://api-bitsong-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://grpc-bitsong-ia.cosmosia.notional.ventures/)               | :white_check_mark:             |
| 30 | AssetMantle<br>(assetmantle)                     | [<sub>:link:</sub>](https://snapshot.notional.ventures/assetmantle/)           | [<sub>:link:</sub>](https://rpc-assetmantle-ia.cosmosia.notional.ventures/)           | [<sub>:link:</sub>](https://api-assetmantle-ia.cosmosia.notional.ventures/)           | [<sub>:link:</sub>](https://grpc-assetmantle-ia.cosmosia.notional.ventures/)           | :white_check_mark:             | 
| 31 | FetchAI<br>(fetchhub)                            | [<sub>:link:</sub>](https://snapshot.notional.ventures/fetchhub/)              | [<sub>:link:</sub>](https://rpc-fetchhub-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://api-fetchhub-ia.cosmosia.notional.ventures/)              | [<sub>:link:</sub>](https://grpc-fetchhub-ia.cosmosia.notional.ventures/)              | :x:                            |
| 32 | Evmos<br>(evmos)                                 | [<sub>:link:</sub>](https://snapshot.notional.ventures/evmos/)                 | [<sub>:link:</sub>](https://rpc-evmos-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://api-evmos-ia.cosmosia.notional.ventures/)                 | [<sub>:link:</sub>](https://grpc-evmos-ia.cosmosia.notional.ventures/)                 | :white_check_mark:             | 
| 33 | Persistence<br>(persistent)                      | [<sub>:link:</sub>](https://snapshot.notional.ventures/persistent/)            | [<sub>:link:</sub>](https://rpc-persistent-ia.cosmosia.notional.ventures/)            | [<sub>:link:</sub>](https://api-persistent-ia.cosmosia.notional.ventures/)            | [<sub>:link:</sub>](https://grpc-persistent-ia.cosmosia.notional.ventures/)            | :white_check_mark:             |
| 34 | Crypto.org<br>(cryptoorgchain)                   | [<sub>:link:</sub>](https://snapshot.notional.ventures/cryptoorgchain/)        | [<sub>:link:</sub>](https://rpc-cryptoorgchain-ia.cosmosia.notional.ventures/)        | [<sub>:link:</sub>](https://api-cryptoorgchain-ia.cosmosia.notional.ventures/)        | [<sub>:link:</sub>](https://grpc-cryptoorgchain-ia.cosmosia.notional.ventures/)        | :white_check_mark:             |
| 35 | IRISnet<br>(irisnet)                             | [<sub>:link:</sub>](https://snapshot.notional.ventures/irisnet/)               | [<sub>:link:</sub>](https://rpc-irisnet-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://api-irisnet-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://grpc-irisnet-ia.cosmosia.notional.ventures/)               | :white_check_mark:             |
| 36 | Axelar<br>(axelar)                               | [<sub>:link:</sub>](https://snapshot.notional.ventures/axelar/)                | [<sub>:link:</sub>](https://rpc-axelar-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://api-axelar-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://grpc-axelar-ia.cosmosia.notional.ventures/)                | :white_check_mark:             |
| 37 | Pylons Testnet<br>(pylons)                       | [<sub>:link:</sub>](https://snapshot.notional.ventures/pylons/)                | [<sub>:link:</sub>](https://rpc-pylons-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://api-pylons-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://grpc-pylons-ia.cosmosia.notional.ventures/)                | :white_check_mark:             |
| 38 | Umee<br>(umee)                                   | [<sub>:link:</sub>](https://snapshot.notional.ventures/umee/)                  | [<sub>:link:</sub>](https://rpc-umee-ia.cosmosia.notional.ventures/)                  | [<sub>:link:</sub>](https://api-umee-ia.cosmosia.notional.ventures/)                  | [<sub>:link:</sub>](https://grpc-umee-ia.cosmosia.notional.ventures/)                  | :white_check_mark:             |
| 39 | Sei-Chain Testnet<br>(sei)                       | [<sub>:link:</sub>](https://snapshot.notional.ventures/sei/)                   | [<sub>:link:</sub>](https://rpc-sei-ia.cosmosia.notional.ventures/)                   | [<sub>:link:</sub>](https://api-sei-ia.cosmosia.notional.ventures/)                   | [<sub>:link:</sub>](https://grpc-sei-ia.cosmosia.notional.ventures/)                   |                                |
| 40 | Evmos Testnet Archive<br>(evmos-testnet-archive) | [<sub>:link:</sub>](https://snapshot.notional.ventures/evmos-testnet-archive/) | [<sub>:link:</sub>](https://rpc-evmos-testnet-archive-ia.cosmosia.notional.ventures/) | [<sub>:link:</sub>](https://api-evmos-testnet-archive-ia.cosmosia.notional.ventures/) | [<sub>:link:</sub>](https://grpc-evmos-testnet-archive-ia.cosmosia.notional.ventures/) |                                |
| 41 | Injective<br>(injective)                         | [<sub>:link:</sub>](https://snapshot.notional.ventures/injective/)             | [<sub>:link:</sub>](https://rpc-injective-ia.cosmosia.notional.ventures/)             | [<sub>:link:</sub>](https://api-injective-ia.cosmosia.notional.ventures/)             | [<sub>:link:</sub>](https://grpc-injective-ia.cosmosia.notional.ventures/)             |                                |
| 42 | Kujira<br>(kujira)                               | [<sub>:link:</sub>](https://snapshot.notional.ventures/kujira/)                | [<sub>:link:</sub>](https://rpc-kujira-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://api-kujira-ia.cosmosia.notional.ventures/)                | [<sub>:link:</sub>](https://grpc-kujira-ia.cosmosia.notional.ventures/)                |                                |
| 43 | Passage<br>(passage)                             | [<sub>:link:</sub>](https://snapshot.notional.ventures/passage/)               | [<sub>:link:</sub>](https://rpc-passage-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://api-passage-ia.cosmosia.notional.ventures/)               | [<sub>:link:</sub>](https://grpc-passage-ia.cosmosia.notional.ventures/)               |                                |
| 44 | Osmosis Testnet<br>(osmosis-testnet)             | [<sub>:link:</sub>](https://snapshot.notional.ventures/osmosis-testnet/)       | [<sub>:link:</sub>](https://rpc-osmosis-testnet-ia.cosmosia.notional.ventures/)       | [<sub>:link:</sub>](https://api-osmosis-testnet-ia.cosmosia.notional.ventures/)       | [<sub>:link:</sub>](https://grpc-osmosis-testnet-ia.cosmosia.notional.ventures/)       |                                |



Add a new chain? Follow this [guide](docs/new_chain.md)

### Docs
See [Docs](./docs/)
