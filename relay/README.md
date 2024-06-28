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

#### create channel 
```
$HOME/.hermes/bin/hermes create channel --order unordered --a-chain narwhal-2 --b-chain theta-testnet-001 --a-port  transfer --b-port transfer --new-client-connection
```

#### update client
```
$HOME/.hermes/bin/hermes update client --host-chain narwhal-2 --client 07-tendermint-15
``` 