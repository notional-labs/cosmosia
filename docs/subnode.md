# Subnode

When an archive too becomes big (5-10TB), we'll replace the archive node with subnode.

Its a technique to split the data into multiple smaller nodes to make it easier for node operator, and faster query for user.


![Subnode Architecture](https://raw.githubusercontent.com/notional-labs/subnode/main/doc/architecture.png)


To read more about subnode, go the project at https://github.com/notional-labs/subnode


## List of chains with subnode

### 01. osmosis

| Protocol | Endpoint                                                |
|----------|:--------------------------------------------------------|
| RPC      | https://rpc-osmosis-sub.cosmosia.notional.ventures/   |
| API      | https://api-osmosis-sub.cosmosia.notional.ventures/   |
| GRPC     | https://grpc-osmosis-sub.cosmosia.notional.ventures/  |
| Config   | https://raw.githubusercontent.com/notional-labs/cosmosia/main/subnode/osmosis_subnode.yaml  |

### 02. juno

| Protocol | Endpoint                                                |
|----------|:--------------------------------------------------------|
| RPC      | https://rpc-juno-sub.cosmosia.notional.ventures/   |
| API      | https://api-juno-sub.cosmosia.notional.ventures/   |
| GRPC     | https://grpc-juno-sub.cosmosia.notional.ventures/  |
| Config   | https://raw.githubusercontent.com/notional-labs/cosmosia/main/subnode/juno_subnode.yaml  |

### 03. cosmoshub

| Protocol | Endpoint                                                |
|----------|:--------------------------------------------------------|
| RPC      | https://rpc-cosmoshub-sub.cosmosia.notional.ventures/   |
| API      | https://api-cosmoshub-sub.cosmosia.notional.ventures/   |
| GRPC     | https://grpc-cosmoshub-sub.cosmosia.notional.ventures/  |
| Config   | https://raw.githubusercontent.com/notional-labs/cosmosia/main/subnode/cosmoshub_subnode.yaml  |

### 04. evmos

| Protocol | Endpoint                                                |
|----------|:--------------------------------------------------------|
| RPC      | https://rpc-evmos-sub.cosmosia.notional.ventures/   |
| API      | https://api-evmos-sub.cosmosia.notional.ventures/   |
| GRPC     | https://grpc-evmos-sub.cosmosia.notional.ventures/  |
| Config   | https://raw.githubusercontent.com/notional-labs/cosmosia/main/subnode/evmos_subnode.yaml  |









