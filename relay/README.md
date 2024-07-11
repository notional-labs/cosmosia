# relay

### Design
- There are multiple relayer-hubs.
- Each relayer-hub has:
    - a config file named `<relayerhub_name>_config.toml`. For example: [test_config.toml](test_config.toml)
    - a `mnemonic` which used for all chains in this hub. The `mnemonic` is stored within Docker Swarm config. Named `cosmosia.relay.<relayerhub_name>.mnemonic.txt`, for example `cosmosia.relay.test.mnemonic.txt`.
- Uptime monitor page: https://status-relayer.notional.ventures/status/ibc


# Notes

### Canto
Refiller addresses:
```
cantod debug addr canto18hlp03s0z6xe7zhw90te6nwmy33rvmw48k8aqr
Address (EIP-55): 0x3dFe17C60f168d9F0AEE2BD79d4DDb2462366dd5
Bech32 Acc: canto18hlp03s0z6xe7zhw90te6nwmy33rvmw48k8aqr
```


### Useful commands

#### query
```
/root/.hermes/bin/hermes query channel end --chain quicksilver-2 --channel channel-177 --port icacontroller-agoric-3.deposit
/root/.hermes/bin/hermes query connection end --chain quicksilver-2 --connection connection-60
/root/.hermes/bin/hermes query client state --chain quicksilver-2 --client 07-tendermint-84
```

#### create channel 
```
$HOME/.hermes/bin/hermes create channel --order unordered --a-chain narwhal-2 --b-chain theta-testnet-001 --a-port  transfer --b-port transfer --new-client-connection
```

#### update client
```
$HOME/.hermes/bin/hermes update client --host-chain narwhal-2 --client 07-tendermint-15
``` 


### Debugging stuck packet

```
http://localhost:26657/status/tx_search?query="send_packet.packet_sequence='175' AND send_packet.packet_src_channel='channel-184' AND send_packet.packet_src_port='transfer' AND send_packet.packet_dst_channel='channel-6' AND send_packet.packet_dst_port='transfer'"
```