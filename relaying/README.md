# relaying

### Design
- First version is as simple as possible
- There are multiple relayer-hubs.
- Each relayer-hub has:
    - a config file named `<relayerhub_name>_config.toml`. For example: [whitewhale_config.toml](whitewhale_config.toml)
    - a `mnemonic` which used for all chains in this hub. The `mnemonic` is stored within Docker Swarm config.
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

| chain         | channel     |
|:--------------|:------------|
| axelar        | channel-6   |
| bandchain     | channel-15  |
| cosmoshub     | channel-9   |
| dydx          | channel-16  |
| evmos         | channel-8   |
| gravitybridge | channel-7   |
| kava          | channel-18  |
| kujira        | channel-14  |
| noble         | channel-13  |
| osmosis       | channel-2   |
| secret        | channel-12  |


**furya hub**

| chain         | channel     |
|:--------------|:------------|
| cosmoshub     | channel-5   |
| kujira        | channel-4   |
| osmosis       | channel-1   |


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
| osmosis       | channel-0   |
| cosmoshub     | channel-1   |
| axelar        | channel-2   |
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
