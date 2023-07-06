# cosmosia (Cosmos Infrastructure Automation)

Open solution to build a reliable infrastructure for cosmos/tendermint based chains ( see [background](https://github.com/cosmos/chain-registry/issues/214) ):

Cosmosia has been used in production for Notional for more than one year.

![web-admin.png](./docs/web-admin.png)


### Features
- Simple: using Docker Swarm which is simple. 
- Maintainable: Large code is in Bash make it easy to maintain.
- Easy: easy for everyday operations with Web-Admin.
- Scalable: works fine with cluster of less than 100 bare-metal servers. Quick-scale with several mouse clicks. Also with subnodes, chain data could grow forever.
- Fast: high performance with bare-metals, LVM for NVME and PebbleDB backend.
- Flexible: public endpoints with rate-limiting and internal endpoints to match your needs. Support multiple protocols: CometBFT RPC, CometBFT Websocket, LCD/API, Eth-JsonRpc, Eth-JsonRpc Websocket.
- Reliable: HA 99.9%, geo-location.
- Shareable: re-use the configuration and snapshots from others Cosmosia clusters.
- Opensource 100%.

### Docs
See [Docs](https://notional-labs.github.io/cosmosia/#/)


### Note
Please contact Notional to get a licence.