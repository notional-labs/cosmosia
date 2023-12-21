# relaying

### Design
- First version is as simple as possible
- There are multiple relayer-hubs.
- Each relayer-hub has:
    - a config file named `<relayerhub_name>_config.toml`. For example: [test_config.toml](test_config.toml)
    - a `mnemonic` which used for all chains in this hub. The `mnemonic` is stored within Docker Swarm config. Named `cosmosia.relay.<relayerhub_name>.mnemonic.txt`, for example `cosmosia.relay.test.mnemonic.txt`.
- Uptime monitor page: https://status-relayer.notional.ventures/status/ibc

### Relayer Hubs

**composable hub**

| chain         | channel     |
|:--------------|:------------|
| agoric        | channel-13  |
| canto         | channel-12  |
| chihuahua     | channel-0   |
| cosmoshub     | channel-4   |
| crescent      | channel-11  |
| evmos         | channel-7   |
| juno          | channel-8   |
| neutron       | channel-18  |
| osmosis       | channel-3   |
| quicksilver   | channel-9   |
| secret        | channel-14  |
| stargaze      | channel-6   |
| stride        | channel-5   |
| umee          | channel-20  |


**coreum hub**

| chain         | channel     | counterparty | status  |
|:--------------|:------------|:-------------|:--------|
| axelar        | channel-6   | channel-120  |         |
| bandchain     | channel-15  | channel-158  | expired |
| cosmoshub     | channel-9   | channel-660  |         |
| dydx          | channel-16  | channel-12   | expired |
| evmos         | channel-8   |              |         |
| gravitybridge | channel-7   |              |         |
| kava          | channel-11  | channel-141  |         |
| kava          | channel-18  | channel-142  |         |
| kujira        | channel-14  | channel-121  | expired |
| noble         | channel-13  |              |         |
| osmosis       | channel-2   |              |         |
| secret        | channel-12  | channel-92   | expired |


**furya hub**

| chain         | channel     | counterparty | status  |
|:--------------|:------------|:-------------|:--------|
| cosmoshub     | channel-5   | channel-747  | expired |
| juno          | channel-2   | channel-417  | expired |
| kujira        | channel-0   | channel-119  | expired |
| nobble        | channel-4   | channel-42   | expired |
| osmosis       | channel-3   | channel-8690 | expired |
| terra2        | channel-1   | channel-271  | expired |


**kava hub**

| chain         | channel     |
|:--------------|:------------|
| celestia      | channel-140 |
| cosmoshub     | channel-0   |
| dydx          | channel-137 |
| osmosis       | channel-1   |
| neutron       | channel-136 |
| noble         | channel-139 |
| terra2        | channel-129 |


**osmosis hub**

| chain                 | channel     |
|:----------------------|:------------|
|                       | channel-294 |
| akash                 | channel-1   |
| axelar                | channel-208 |
| bitcanna              | channel-51  |
| chihuahua             | channel-113 |
| comdex                | channel-87  |
| cosmoshub             | channel-0   |
| cryptoorgchain        | channel-5   |
| gravitybridge         | channel-144 |
| konstellation-testnet | channel-171 |
| omniflixhub           | channel-199 |
| irishub               | channel-6   |
| juno                  | channel-169 |
| juno                  | channel-42  |
| kava                  | channel-143 |
| kichain               | channel-77  |
| mars                  | channel-557 |
| quasar                | channel-688 |
| quicksilver           | channel-522 |
| regen                 | channel-8   |
| sentinel              | channel-2   |
| sifchain              | channel-47  |
| stargaze              | channel-75  |
| stride                | channel-326 |
| terra                 | channel-72  |
| umee                  | channel-184 |


**sei hub**

| chain         | channel     |
|:--------------|:------------|
| axelar        | channel-2   |
| cosmoshub     | channel-1   |
| osmosis       | channel-0   |
| terra2        | channel-3   |


**whitewhale hub**

| chain         | channel     |
|:--------------|:------------|
| axelar        | channel-49  |
| axelar        | channel-53  |
| chihuahua     | channel-10  |
| kava          | channel-48  |
| neutron       | channel-27  |
| umee          | channel-22  |
