# Testing an endpoint

Example using osmosis endpoints, for other chains see [the list here](README.md).

### Tendermint RPC

```console
➜  ~ curl https://rpc-osmosis-ia.cosmosia.notional.ventures/status
{
  "jsonrpc": "2.0",
  "id": -1,
  "result": {
    "node_info": {
      "protocol_version": {
        "p2p": "8",
        "block": "11",
        "app": "12"
      },
      "id": "50b9ac4a600ba0942eda7d3164eb4ad919457789",
      "listen_addr": "tcp://0.0.0.0:26656",
      "network": "osmosis-1",
      "version": "0.34.21",
      "channels": "40202122233038606100",
      "moniker": "test",
      "other": {
        "tx_index": "on",
        "rpc_address": "tcp://0.0.0.0:26657"
      }
    },
    "sync_info": {
      "latest_block_hash": "41D32F87F3C5224FFDF7FE44FA2DC13A0E172DDEAAD7BB377BD35B948DBDF3BC",
      "latest_app_hash": "2998DA84A234263F8DE3655F6368AED54039B5511A91DD4DDB2DE56FC72C4E46",
      "latest_block_height": "6784864",
      "latest_block_time": "2022-11-07T10:19:59.887548533Z",
      "earliest_block_hash": "4C9B1EC0E6BE888BC76FAA274CDA4FACE47236A28A59CA3DF3E6E7175DF18A86",
      "earliest_app_hash": "F7DAFD84641C444ED3C967B8AFDBD8DF5141D9A570397CB4A669A81DC55A5A8C",
      "earliest_block_height": "6419998",
      "earliest_block_time": "2022-10-13T05:18:15.29076024Z",
      "catching_up": false
    },
    "validator_info": {
      "address": "F7075EF4D00A1E27D4448C5526CA9C6F656CA5AF",
      "pub_key": {
        "type": "tendermint/PubKeyEd25519",
        "value": "CvgJn0PrQurTCLro+k2IWDy6R3qOl+I/2VFgxoCuclo="
      },
      "voting_power": "0"
    }
  }
}%                                                                                                                                                                                                                                                                               ➜  ~
```

### Tendermint Websocket

```console
➜  ~ wscat -c wss://rpc-osmosis-ia.cosmosia.notional.ventures/websocket
Connected (press CTRL+C to quit)
> {"jsonrpc":"2.0","method":"subscribe","id":0,"params":{"query":"tm.event='NewBlock'"}}
< {
  "jsonrpc": "2.0",
  "id": 0,
  "result": {}
}
< {
  "jsonrpc": "2.0",
  "id": 0,
  "result": {
    "query": "tm.event='NewBlock'",
    "data": {
    ...
```



### API

```
➜  ~ curl -X GET "https://api-osmosis-ia.cosmosia.notional.ventures/cosmos/base/tendermint/v1beta1/syncing" -H "accept: application/json"
{
  "syncing": false
}%                                                                                                                                                                                                                                                                               ➜  ~
```

### gRPC

```console
➜  ~ grpcurl grpc-osmosis-ia.cosmosia.notional.ventures:443 list
cosmos.auth.v1beta1.Query
cosmos.authz.v1beta1.Query
cosmos.bank.v1beta1.Query
cosmos.base.reflection.v1beta1.ReflectionService
cosmos.base.reflection.v2alpha1.ReflectionService
cosmos.base.tendermint.v1beta1.Service
cosmos.distribution.v1beta1.Query
cosmos.evidence.v1beta1.Query
cosmos.gov.v1beta1.Query
cosmos.params.v1beta1.Query
cosmos.slashing.v1beta1.Query
cosmos.staking.v1beta1.Query
cosmos.tx.v1beta1.Service
cosmos.upgrade.v1beta1.Query
cosmwasm.wasm.v1.Query
grpc.reflection.v1alpha.ServerReflection
ibc.applications.interchain_accounts.host.v1.Query
ibc.applications.transfer.v1.Query
ibc.core.channel.v1.Query
ibc.core.client.v1.Query
ibc.core.connection.v1.Query
osmosis.epochs.v1beta1.Query
osmosis.gamm.v1beta1.Query
osmosis.incentives.Query
osmosis.lockup.Query
osmosis.mint.v1beta1.Query
osmosis.poolincentives.v1beta1.Query
osmosis.superfluid.Query
osmosis.tokenfactory.v1beta1.Query
osmosis.twap.v1beta1.Query
osmosis.txfees.v1beta1.Query
testdata.Query
➜  ~
```

### eth-jsonrpc
```console
➜  ~ curl -X POST -H "Content-Type: application/json"  --data '{ "jsonrpc":"2.0", "method":"eth_blockNumber", "params":[], "id":1 }' https://jsonrpc-evmos-ia.cosmosia.notional.ventures
{"jsonrpc":"2.0","id":1,"result":"0xd1246d"}
➜  ~
```

### eth-jsonrpc-ws
```console
➜  ~ wscat -c wss://jsonrpc-evmos-ia.cosmosia.notional.ventures/websocket/
Connected (press CTRL+C to quit)
> {"id": 1, "method": "eth_subscribe", "params": ["newHeads", {}]}
< {"jsonrpc":"2.0","result":"0xb0e7d22eb511c67e3b2818ce1ab6988","id":1}

< {"jsonrpc":"2.0","method":"eth_subscription","params":{"subscription":"0xb0e7d22eb511c67e3b2818ce1ab6988","result":{"parentHash":"0xc2e7f564a1115509f1a440bbe042db02c6bcbf5f5643c000127e466ff38cca6a","sha3Uncles":"0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347","miner":"0x7cb4380c0784fb9a79d66b14eceb9cc9102995bf","stateRoot":"0x26c49db18afe7db1fe3dfdb86bfed3d6c6a1cfb763ce95a0d5f80747721d516e","transactionsRoot":"0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421","receiptsRoot":"0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421","logsBloom":"0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000","difficulty":"0x0","number":"0xd12455","gasLimit":"0x0","gasUsed":"0x0","timestamp":"0x647bed0f","extraData":"0x","mixHash":"0x0000000000000000000000000000000000000000000000000000000000000000","nonce":"0x0000000000000000","baseFeePerGas":"0x3b9aca00","hash":"0x1680680ce17cba5a3a40cef71ca4d77347b88d39ce42f62470d821624a31bc2e"}}}

< {"jsonrpc":"2.0","method":"eth_subscription","params":{"subscription":"0xb0e7d22eb511c67e3b2818ce1ab6988","result":{"parentHash":"0x39620d56b5b2180ecb8ceb9de953ab60dd2050f680ade95d1279bfabb0522a1c","sha3Uncles":"0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347","miner":"0x165190617cc19b2ff1b56e9780d2ad6120f45bce","stateRoot":"0x465b4b405a6bad99be712b42e0dfdd54c8b0daec3e888b0366c326ae439e19d1","transactionsRoot":"0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421","receiptsRoot":"0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421","logsBloom":"0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000","difficulty":"0x0","number":"0xd12456","gasLimit":"0x0","gasUsed":"0x0","timestamp":"0x647bed12","extraData":"0x","mixHash":"0x0000000000000000000000000000000000000000000000000000000000000000","nonce":"0x0000000000000000","baseFeePerGas":"0x3b9aca00","hash":"0x39f3c1fab0670d6bd8c6363b55ccb93225a8f9891e4fbee7bc830de71aebd7b6"}}}

> %                                                                                                                                                                                                                  ➜  ~
```