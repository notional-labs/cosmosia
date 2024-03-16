export INC_GLOBAL=$(cat <<-EOT
[global]
log_level = 'error'

[mode]

[mode.clients]
enabled = true
refresh = true
misbehaviour = false

[mode.connections]
enabled = false

[mode.channels]
enabled = false

[mode.packets]
enabled = true
clear_interval = 0
clear_on_start = true
tx_confirmation = false

[rest]
enabled = false
host = '127.0.0.1'
port = 3000

[telemetry]
enabled = true
host = '0.0.0.0'
port = 3001
EOT
)

# centauri-1
export INC_CENTAURI_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_composable:8000'
grpc_addr = 'http://tasks.lb_composable:8003'
event_source = { mode = 'push', url = 'ws://tasks.lb_composable:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "centauri"
key_name = "composable"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas =  10000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 1, denom = 'ppica' }
address_type = { derivation = 'cosmos' }
EOT
)

# agoric-3
export INC_AGORIC_3=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_agoric:8000'
grpc_addr = 'http://tasks.lb_agoric:8003'
event_source = { mode = 'push', url = 'ws://tasks.lb_agoric:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "agoric"
key_name = "agoric"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.03, denom = 'ubld' }
gas_multiplier = 1
max_msg_num = 30
max_tx_size = 3000000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '336hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.34'
trust_threshold = { numerator = '1', denominator = '3' }
address_type = { derivation = 'cosmos' }
EOT
)

# chihuahua-1
export INC_CHIHUAHUA_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_chihuahua:8000'
grpc_addr = 'http://tasks.lb_chihuahua:8003'
event_source = { mode = 'push', url = 'ws://tasks.lb_chihuahua:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "chihuahua"
key_name = "chihuahua"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000000
max_gas = 1000000000
gas_multiplier = 2
max_msg_num = 30
max_tx_size = 1000000
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.1, denom = 'uhuahua' }
address_type = { derivation = 'cosmos' }
EOT
)

# cosmoshub-4
export INC_COSMOSHUB_4=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_cosmoshub:8000'
grpc_addr = 'http://tasks.lb_cosmoshub:8003'
rpc_timeout = "30s"
trusted_node = false
account_prefix = "cosmos"
key_name = "cosmoshub"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 180000
max_gas = 2500000
gas_multiplier = 2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "1000s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.34'
event_source = { mode = 'push', url = 'ws://tasks.lb_cosmoshub:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.01, denom = 'uatom' }
address_type = { derivation = 'cosmos' }
EOT
)

# crescent-1
export INC_CRESCENT_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_crescent:8000'
grpc_addr = 'http://tasks.lb_crescent:8003'
event_source = { mode = 'push', url = 'ws://tasks.lb_crescent:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "cre"
key_name = "crescent"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 2000000
gas_price = { price = 0.01, denom = 'ucre' }
gas_multiplier = 1
max_msg_num = 30
max_tx_size = 3000000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.34'
trust_threshold = { numerator = '1', denominator = '3' }
address_type = { derivation = 'cosmos' }
EOT
)

# canto_7700-1
export INC_CANTO_7700_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'https://rpc.canto.silentvalidator.com'
grpc_addr = 'http://canto-grpc.polkachu.com:15590'
event_source = { mode = 'push', url = 'wss://rpc.canto.silentvalidator.com/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "canto"
key_name = "canto"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas =  10000000
gas_price = { price = 1000000000000 , denom = 'acanto' }
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 3000000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.34'
trust_threshold = { numerator = '1', denominator = '3' }
address_type = { derivation = 'cosmos' }
EOT
)

# evmos_9001-2
export INC_EVMOS_9001_2=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_evmos:8000'
grpc_addr = 'http://tasks.lb_evmos:8003'
rpc_timeout = "30s"
trusted_node = false
account_prefix = "evmos"
key_name = "evmos"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 180000
max_gas = 2500000
gas_multiplier = 2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'ws://tasks.lb_evmos:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0075, denom = 'aevmos' }
address_type = { derivation = 'ethermint', proto_type = { pk_type = '/ethermint.crypto.v1.ethsecp256k1.PubKey' } }
compat_mode = '0.37'
EOT
)

# juno-1
export INC_JUNO_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = "http://tasks.lb_juno:8000"
grpc_addr = "http://tasks.lb_juno:8003"
event_source = { mode = 'push', url = 'ws://tasks.lb_juno:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "10s"
trusted_node = false
account_prefix = "juno"
key_name = "juno"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000
max_gas = 400000
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.1, denom = 'ujuno' }
compat_mode = '0.37'
EOT
)

# neutron-1
export INC_NEUTRON_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_neutron:8000'
grpc_addr = 'http://tasks.lb_neutron:8003'
event_source = { mode = 'push', url = 'ws://tasks.lb_neutron:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "neutron"
key_name = "neutron"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 1000000
gas_multiplier = 1.2
max_msg_num = 20
max_tx_size = 2097152
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '13days'
ccv_consumer_chain = false
#ccv_consumer_chain = true
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.6, denom = 'untrn' }
address_type = { derivation = 'cosmos' }
EOT
)

# osmosis-1
export INC_OSMOSIS_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_osmosis:8000'
grpc_addr = 'http://tasks.lb_osmosis:8003'
event_source = { mode = 'push', url = 'ws://tasks.lb_osmosis:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "osmo"
key_name = "osmosis"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 20000000
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "100s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0025, denom = 'uosmo' }
address_type = { derivation = 'cosmos' }
EOT
)

# quicksilver-2
export INC_QUICKSILVER_2=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = "http://tasks.lb_quicksilver:8000"
grpc_addr = "http://tasks.lb_quicksilver:8003"
event_source = { mode = 'push', url = 'ws://tasks.lb_quicksilver:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "10s"
trusted_node = false
account_prefix = "quicksilver"
key_name = "juno"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000
max_gas = 2000000
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
trusting_period = '14days'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0004, denom = 'uqck' }
compat_mode = '0.37'
EOT
)

# secret-4
export INC_SECRET_4=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'https://secret-4.api.trivium.network:26657'
grpc_addr = 'https://secretnetwork-grpc.lavenderfive.com:443'
rpc_timeout = "20s"
trusted_node = false
account_prefix = "secret"
key_name = "secret"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'wss://secret-4.api.trivium.network:26657/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.1, denom = 'uscrt' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.34'
EOT
)

# stargaze-1
export INC_STARGAZE_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_stargaze:8000'
grpc_addr = 'http://tasks.lb_stargaze:8003'
event_source = { mode = 'push', url = 'ws://tasks.lb_stargaze:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "stars"
key_name = "stargaze"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 1000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 1000000
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.34'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 1, denom = 'ustars' }
address_type = { derivation = 'cosmos' }
EOT
)

# stride-1
export INC_STRIDE_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_stride:8000'
grpc_addr = 'http://tasks.lb_stride:8003'
event_source = { mode = 'push', url = 'ws://tasks.lb_stride:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "stride"
key_name = "stride"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 400000
max_gas = 40000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 1000000
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.005, denom = 'ustrd' }
address_type = { derivation = 'cosmos' }
EOT
)

# umee-1
export INC_UMEE_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_umee:8000'
grpc_addr = 'http://tasks.lb_umee:8003'
event_source = { mode = 'push', url = 'ws://tasks.lb_umee:8000/websocket', batch_delay = '500ms' }
rpc_timeout = "30s"
trusted_node = false
account_prefix = "umee"
key_name = "umee"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas =  10000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 2097152
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '216hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.1, denom = 'uumee' }
address_type = { derivation = 'cosmos' }
EOT
)

# coreum-mainnet-1
export INC_COREUM_MAINNET_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_coreum:8000'
grpc_addr = 'http://tasks.lb_coreum:8003'
rpc_timeout = "30s"
trusted_node = false
account_prefix = "core"
key_name = "coreum"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.37'
event_source = { mode = 'push', url = 'ws://tasks.lb_coreum:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.03125, denom = 'ucore' }
address_type = { derivation = 'cosmos' }
EOT
)

# axelar-dojo-1
export INC_AXELAR_DOJO_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_axelar:8000'
grpc_addr = 'http://tasks.lb_axelar:8003'
rpc_timeout = "15s"
trusted_node = false
account_prefix = "axelar"
key_name = "axelar"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000
max_gas = 4000000
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "50s"
max_block_time = "10s"
trusting_period = '112hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
compat_mode = '0.34'
event_source = { mode = 'push', url = 'ws://tasks.lb_axelar:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0075, denom = 'uaxl' }
address_type = { derivation = 'cosmos' }
EOT
)

# gravity-bridge-3
export INC_GRAVITY_BRIDGE_3=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_gravitybridge:8000'
grpc_addr = 'http://tasks.lb_gravitybridge:8003'
rpc_timeout = "20s"
trusted_node = false
account_prefix = "gravity"
key_name = "gravitybridge"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'ws://tasks.lb_gravitybridge:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0025, denom = 'ugraviton' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.34'
EOT
)

# kava_2222-10
export INC_KAVA_2222_10=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_kava:8000'
grpc_addr = 'http://tasks.lb_kava:8003'
rpc_timeout = "20s"
trusted_node = false
account_prefix = "kava"
key_name = "kava"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'ws://tasks.lb_kava:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0025, denom = 'ukava' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.34'
EOT
)

# noble-1
export INC_NOBLE_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_noble:8000'
grpc_addr = 'http://tasks.lb_noble:8003'
rpc_timeout = "20s"
trusted_node = false
account_prefix = "noble"
key_name = "noble"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'ws://tasks.lb_noble:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0, denom = 'uusdc' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.34'
EOT
)

# kaiyo-1
export INC_KAIYO_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_kujira:8000'
grpc_addr = 'http://tasks.lb_kujira:8003'
rpc_timeout = "20s"
trusted_node = false
account_prefix = "kujira"
key_name = "noble"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'ws://tasks.lb_kujira:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.01, denom = 'ukuji' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.37'
EOT
)

# laozi-mainnet
export INC_LAOZI_MAINNET=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://rpc.laozi1.bandchain.org:80'
grpc_addr = 'http://grpc-band-01.stakeflow.io:2502/'
rpc_timeout = "20s"
trusted_node = false
account_prefix = "band"
key_name = "bandchain"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'ws://rpc.laozi1.bandchain.org:80/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0025, denom = 'uband' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.34'
EOT
)

# dydx-mainnet-1
export INC_DYDX_MAINNET_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_dydx:8000'
grpc_addr = 'http://tasks.lb_dydx:8003'
rpc_timeout = "20s"
trusted_node = false
account_prefix = "dydx"
key_name = "dydx"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'ws://tasks.lb_dydx:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 12500000000, denom = 'adydx' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.37'
EOT
)

# furya-1
export INC_FURYA_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = "http://tasks.lb_furya:8000"
grpc_addr = "http://tasks.lb_furya:8003"
rpc_timeout = "10s"
trusted_node = false
account_prefix = "furya"
key_name = "furya"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 180000
max_gas = 2500000
gas_multiplier = 2
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'ws://tasks.lb_furya:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.25, denom = 'ufury' }
address_type = { derivation = 'cosmos' }
EOT
)

# phoenix-1
export INC_PHOENIX_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = "http://tasks.lb_terra2:8000"
grpc_addr = "http://tasks.lb_terra2:8003"
rpc_timeout = "10s"
trusted_node = false
account_prefix = "terra"
key_name = "terra2"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000
max_gas = 400000
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 180000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
memo_prefix = ""
sequential_batch_tx = false
event_source = { mode = 'push', url = 'ws://tasks.lb_terra2:8000/websocket', batch_delay = '500ms' }
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.015, denom = 'uluna' }
address_type = { derivation = 'cosmos' }
EOT
)