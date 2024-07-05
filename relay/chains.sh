export INC_GLOBAL=$(cat <<-EOT
[global]
log_level = 'error'

[mode]

[mode.clients]
enabled = true
refresh = true
misbehaviour = false

[mode.connections]
enabled = true

[mode.channels]
enabled = true

[mode.packets]
enabled = true
clear_interval = 100
clear_on_start = true
tx_confirmation = true

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


# archway-1
export INC_ARCHWAY_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_archway:8000'
grpc_addr = 'http://tasks.lb_archway:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_archway:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "archway"
key_name = "archway"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 600000
max_gas =  10000000
gas_multiplier = 1.2
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 140000000000.0, denom = 'aarch' }
address_type = { derivation = 'cosmos' }
EOT
)

# centauri-1
export INC_CENTAURI_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_composable:8000'
grpc_addr = 'http://tasks.lb_composable:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_composable:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "pica"
key_name = "composable"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 600000
max_gas =  10000000
gas_multiplier = 1.2
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_agoric:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "agoric"
key_name = "agoric"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.03, denom = 'ubld' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 3000000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '336hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
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
# event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "chihuahua"
key_name = "chihuahua"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000000
max_gas = 1000000000
gas_multiplier = 2
max_msg_num = 10
max_tx_size = 1000000
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_cosmoshub:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '2s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "cosmos"
key_name = "cosmoshub"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 250000
max_gas = 100000000
gas_multiplier = 1.1
max_msg_num = 3
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "1000s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_crescent:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "cre"
key_name = "crescent"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 2000000
gas_price = { price = 0.01, denom = 'ucre' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 3000000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.34'
trust_threshold = { numerator = '1', denominator = '3' }
address_type = { derivation = 'cosmos' }
EOT
)

# canto_7700-1
export INC_CANTO_7700_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'https://canto.gravitychain.io:26657'
grpc_addr = 'https://canto.gravitychain.io:9090'
# event_source = { mode = 'push', url = 'wss://canto.gravitychain.io:26657/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "canto"
key_name = "canto"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas =  10000000
gas_price = { price = 1000000000000 , denom = 'acanto' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 3000000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.34'
trust_threshold = { numerator = '1', denominator = '3' }
address_type = { derivation = 'ethermint', proto_type = { pk_type = '/ethermint.crypto.v1.ethsecp256k1.PubKey' } }
EOT
)

# evmos_9001-2
export INC_EVMOS_9001_2=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_evmos:8000'
grpc_addr = 'http://tasks.lb_evmos:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_evmos:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "evmos"
key_name = "evmos"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 180000
max_gas = 2500000
gas_multiplier = 2
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_juno:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '2s' }
rpc_timeout = "10s"
trusted_node = true
account_prefix = "juno"
key_name = "juno"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000
max_gas = 1000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.075, denom = 'ujuno' }
compat_mode = '0.37'
EOT
)

# darchub
export INC_DARCHHB=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = "http://tasks.lb_konstellation:8000"
grpc_addr = "http://tasks.lb_konstellation:8003"
# event_source = { mode = 'push', url = 'ws://tasks.lb_konstellation:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "10s"
trusted_node = true
account_prefix = "darc"
key_name = "darchub"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000
max_gas = 400000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0001, denom = 'udarc' }
compat_mode = '0.34'
EOT
)

# irishub-1
export INC_IRISHUB_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = "http://tasks.lb_irisnet:8000"
grpc_addr = "http://tasks.lb_irisnet:8003"
# event_source = { mode = 'push', url = 'ws://tasks.lb_irisnet:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "10s"
trusted_node = true
account_prefix = "iaa"
key_name = "irisnet"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000
max_gas = 400000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.2, denom = 'uiris' }
compat_mode = '0.37'
EOT
)

# neutron-1
export INC_NEUTRON_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_neutron:8000'
grpc_addr = 'http://tasks.lb_neutron:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_neutron:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "neutron"
key_name = "neutron"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 1000000
gas_multiplier = 2.0
max_msg_num = 10
max_tx_size = 2097152
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '13days'
ccv_consumer_chain = false
#ccv_consumer_chain = true
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0053, denom = 'untrn' }
address_type = { derivation = 'cosmos' }
EOT
)

# osmosis-1
export INC_OSMOSIS_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_osmosis:8000'
grpc_addr = 'http://tasks.lb_osmosis:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_osmosis:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '2s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "osmo"
key_name = "osmosis"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 600000
max_gas = 25000000
gas_multiplier = 1.2
dynamic_gas_price = { enabled = true, multiplier = 1.2, max = 0.6 }
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "100s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.005, denom = 'uosmo' }
address_type = { derivation = 'cosmos' }
EOT
)

# quicksilver-2
export INC_QUICKSILVER_2=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = "http://tasks.lb_quicksilver:8000"
grpc_addr = "http://tasks.lb_quicksilver:8003"
# event_source = { mode = 'push', url = 'ws://tasks.lb_quicksilver:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '2s' }
rpc_timeout = "10s"
trusted_node = true
account_prefix = "quick"
key_name = "quicksilver"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 600000
max_gas = 150000000
gas_multiplier = 1.35
max_msg_num = 3
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trusting_period = '14days'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0001, denom = 'uqck' }
compat_mode = '0.34'
EOT
)


# ssc-1
export INC_SSC_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_saga:8000'
grpc_addr = 'http://tasks.lb_saga:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_saga:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '2s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "saga"
key_name = "saga"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 1000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.015, denom = 'usaga' }
address_type = { derivation = 'cosmos' }
EOT
)

# secret-4
export INC_SECRET_4=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'https://secret-4.api.trivium.network:26657'
grpc_addr = 'https://secretnetwork-grpc.lavenderfive.com:443'
# event_source = { mode = 'push', url = 'wss://secret-4.api.trivium.network:26657/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "20s"
trusted_node = true
account_prefix = "secret"
key_name = "secret"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.05, denom = 'uscrt' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.34'
EOT
)

# sommelier-3
export INC_SOMMELIER_3=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_sommelier:8000'
grpc_addr = 'http://tasks.lb_sommelier:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_sommelier:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '2s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "somm"
key_name = "sommelier"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 1000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '18days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.34'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 1, denom = 'usomm' }
address_type = { derivation = 'cosmos' }
EOT
)

# stargaze-1
export INC_STARGAZE_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_stargaze:8000'
grpc_addr = 'http://tasks.lb_stargaze:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_stargaze:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '2s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "stars"
key_name = "stargaze"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 500000
max_gas = 1000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1000000
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_stride:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "stride"
key_name = "stride"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 400000
max_gas = 40000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1000000
max_grpc_decoding_size = 33554432
clock_drift = "15s"
max_block_time = "10s"
trusting_period = '224hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0005, denom = 'ustrd' }
address_type = { derivation = 'cosmos' }
EOT
)

# umee-1
export INC_UMEE_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_umee:8000'
grpc_addr = 'http://tasks.lb_umee:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_umee:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "umee"
key_name = "umee"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas =  10000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 2097152
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '216hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_coreum:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "core"
key_name = "coreum"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.2
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0625, denom = 'ucore' }
address_type = { derivation = 'cosmos' }
EOT
)

# axelar-dojo-1
export INC_AXELAR_DOJO_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_axelar:8000'
grpc_addr = 'http://tasks.lb_axelar:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_axelar:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "15s"
trusted_node = true
account_prefix = "axelar"
key_name = "axelar"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 150000
max_gas = 4000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "50s"
max_block_time = "10s"
trusting_period = '112hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.34'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.007, denom = 'uaxl' }
address_type = { derivation = 'cosmos' }
EOT
)

# gravity-bridge-3
export INC_GRAVITY_BRIDGE_3=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_gravitybridge:8000'
grpc_addr = 'http://tasks.lb_gravitybridge:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_gravitybridge:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "20s"
trusted_node = true
account_prefix = "gravity"
key_name = "gravitybridge"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_kava:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "20s"
trusted_node = true
account_prefix = "kava"
key_name = "kava"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 2000000
max_gas = 4000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.01, denom = 'ukava' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.37'
EOT
)

# noble-1
export INC_NOBLE_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_noble:8000'
grpc_addr = 'http://tasks.lb_noble:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_noble:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "20s"
trusted_node = true
account_prefix = "noble"
key_name = "noble"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.01, denom = 'uusdc' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.34'
EOT
)

# kaiyo-1
export INC_KAIYO_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_kujira:8000'
grpc_addr = 'http://tasks.lb_kujira:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_kujira:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "20s"
trusted_node = true
account_prefix = "kujira"
key_name = "kujira"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '10days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0034, denom = 'ukuji' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.37'
EOT
)

# laozi-mainnet
export INC_LAOZI_MAINNET=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://rpc.laozi1.bandchain.org:80'
grpc_addr = 'http://grpc-band-01.stakeflow.io:2502/'
# event_source = { mode = 'push', url = 'ws://rpc.laozi1.bandchain.org:80/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "20s"
trusted_node = true
account_prefix = "band"
key_name = "bandchain"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_dydx:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '2s' }
rpc_timeout = "20s"
trusted_node = true
account_prefix = "dydx"
key_name = "dydx"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_furya:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "10s"
trusted_node = true
account_prefix = "furya"
key_name = "furya"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 180000
max_gas = 2500000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
trusting_period = '14days'
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
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
# event_source = { mode = 'push', url = 'ws://tasks.lb_terra2:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "10s"
trusted_node = true
account_prefix = "terra"
key_name = "terra2"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000
max_gas = 400000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.015, denom = 'uluna' }
address_type = { derivation = 'cosmos' }
EOT
)

# injective-1
export INC_INJECTIVE_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_injective:8000'
grpc_addr = 'http://tasks.lb_injective:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_injective:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "inj"
key_name = "injective"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 300000
max_gas = 10000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 160000000.0, denom = 'inj' }
address_type = { derivation = 'cosmos' }
# address_type = { derivation = 'ethermint', proto_type = { pk_type = '/injective.crypto.v1beta1.ethsecp256k1.PubKey' } }
EOT
)

# celestia
export INC_CELESTIA=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_celestia:8000'
grpc_addr = 'http://tasks.lb_celestia:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_celestia:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "20s"
trusted_node = true
account_prefix = "celestia"
key_name = "celestia"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 1000000
max_gas = 4000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
trusting_period = '14days'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.002, denom = 'utia' }
address_type = { derivation = 'cosmos' }
compat_mode = '0.34'
EOT
)

# akashnet-2
export INC_AKASHNET_2=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_akash:8000'
grpc_addr = 'http://tasks.lb_akash:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_akash:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '20s'
account_prefix = 'akash'
key_name = 'akash'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.0025, denom = 'uakt' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
clock_drift = '40s'
max_block_time = '10s'
trusting_period = '14days'
memo_prefix = 'relayed by Notional.Ventures'
trust_threshold = { numerator = '1', denominator = '3' }
EOT
)

# bitcanna-1
export INC_BITCANNA_1=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_bitcanna:8000'
grpc_addr = 'http://tasks.lb_bitcanna:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_bitcanna:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '20s'
account_prefix = 'bcna'
key_name = 'bcna'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.001, denom = 'ubcna' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
clock_drift = '40s'
max_block_time = '10s'
trusting_period = '32hours'
memo_prefix = 'relayed by Notional.Ventures'
trust_threshold = { numerator = '1', denominator = '3' }
EOT
)

# columbus-5
export INC_COLUMBUS_5=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_terra:8000'
grpc_addr = 'http://tasks.lb_terra:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_terra:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '15s'
account_prefix = 'terra'
key_name = 'terra'
store_prefix = 'ibc'
max_tx_size = 1000000
default_gas = 100000000
max_gas = 1000000000
max_msg_num = 10
gas_price = { price = 28.325, denom = 'uluna' }
gas_multiplier = 1.1
clock_drift ='34s'
trusting_period = '14days'
trust_threshold = { numerator = '1', denominator = '3' }
memo_prefix = 'relayed by Notional.Ventures'
EOT
)

# crypto-org-chain-mainnet-1
export INC_CRYPTO_ORG_CHAIN_MAINNET_1=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_cryptoorgchain:8000'
grpc_addr = 'http://tasks.lb_cryptoorgchain:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_cryptoorgchain:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '20s'
account_prefix = 'cro'
key_name = 'cro'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.025, denom = 'basecro' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
clock_drift = '40s'
max_block_time = '10s'
trusting_period = '448hours'
memo_prefix = 'relayed by Notional.Ventures'
trust_threshold = { numerator = '1', denominator = '3' }
EOT
)

# kichain-2
export INC_KICHAIN_2=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_kichain:8000'
grpc_addr = 'http://tasks.lb_kichain:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_kichain:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '20s'
account_prefix = 'ki'
key_name = 'ki'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.025, denom = 'uxki' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
clock_drift = '40s'
max_block_time = '10s'
trusting_period = '14days'
memo_prefix = 'relayed by Notional.Ventures'
trust_threshold = { numerator = '1', denominator = '3' }
EOT
)

# mars-1
export INC_MARS_1=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_mars:8000'
grpc_addr = 'http://tasks.lb_mars:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_mars:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '20s'
account_prefix = 'mars'
key_name = 'mars'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.0025, denom = 'umars' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
clock_drift = '40s'
max_block_time = '10s'
trusting_period = '14days'
memo_prefix = 'relayed by Notional.Ventures'
trust_threshold = { numerator = '1', denominator = '3' }
EOT
)

# omniflixhub-1
export INC_OMNIFLIXHUB_1=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_omniflixhub:8000'
grpc_addr = 'http://tasks.lb_omniflixhub:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_omniflixhub:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '20s'
account_prefix = 'omniflix'
key_name = 'omniflix'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.001, denom = 'uflix' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
clock_drift = '40s'
max_block_time = '10s'
trusting_period = '14days'
memo_prefix = 'relayed by Notional.Ventures'
trust_threshold = { numerator = '1', denominator = '3' }
EOT
)

# pirin-1
export INC_PIRIN_1=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_nolus:8000'
grpc_addr = 'http://tasks.lb_nolus:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_nolus:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '20s'
account_prefix = 'nolus'
key_name = 'nolus'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.0025, denom = 'unls' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
clock_drift = '40s'
max_block_time = '10s'
trusting_period = '14days'
memo_prefix = 'relayed by Notional.Ventures'
trust_threshold = { numerator = '1', denominator = '3' }
EOT
)

# quasar-1
export INC_QUASAR_1=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_quasar:8000'
grpc_addr = 'http://tasks.lb_quasar:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_quasar:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '20s'
account_prefix = 'quasar'
key_name = 'quasar'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.1, denom = 'uqsr' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
clock_drift = '40s'
max_block_time = '10s'
trusting_period = '14days'
memo_prefix = 'relayed by Notional.Ventures'
trust_threshold = { numerator = '1', denominator = '3' }
EOT
)

# regen-1
export INC_REGEN_1=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_regen:8000'
grpc_addr = 'http://tasks.lb_regen:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_regen:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '2s' }
rpc_timeout = '60s'
account_prefix = 'regen'
key_name = 'regen'
store_prefix = 'ibc'
default_gas = 300000
max_gas = 2000000
gas_price = { price = 0.015, denom = 'uregen' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 100000
clock_drift ='50s'
trusting_period = '14days'
trust_threshold = { numerator = '1', denominator = '3' }
memo_prefix = 'relayed by Notional.Ventures'
compat_mode = '0.34'
EOT
)

# sentinelhub-2
export INC_SENTINELHUB_2=$(cat <<-EOT
rpc_addr = 'http://tasks.lb_sentinel:8000'
grpc_addr = 'http://tasks.lb_sentinel:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_sentinel:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = '20s'
account_prefix = 'sent'
key_name = 'sentinel'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 300000
max_gas =  10000000
gas_price = { price = 0.1, denom = 'udvpn' }
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
clock_drift = '40s'
max_block_time = '10s'
trusting_period = '14days'
memo_prefix = 'relayed by Notional.Ventures'
trust_threshold = { numerator = '1', denominator = '3' }
EOT
)

# pacific-1
export INC_PACIFIC_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_sei:8000'
grpc_addr = 'http://tasks.lb_sei:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_sei:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "sei"
key_name = "sei"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 100000
max_gas = 4000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "5s"
max_block_time = "30s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.02, denom = 'usei' }
address_type = { derivation = 'cosmos' }
EOT
)

# migaloo-1
export INC_MIGALOO_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_whitewhale:8000'
grpc_addr = 'http://tasks.lb_whitewhale:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_whitewhale:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "migaloo"
key_name = "migaloo"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 1000000
max_gas = 5000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 3000000
max_grpc_decoding_size = 33554432
clock_drift = "500s"
max_block_time = "10s"
trusting_period = '336hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.25, denom = 'uwhale' }
address_type = { derivation = 'cosmos' }
EOT
)


#################
# TESTNETS

# banksy-testnet-5
export INC_BANKSY_TESTNET_5=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_composable-testnet:8000'
grpc_addr = 'http://tasks.lb_composable-testnet:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_composable-testnet:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "pica"
key_name = "composable-testnet"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 600000
max_gas =  10000000
gas_multiplier = 1.2
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "40s"
max_block_time = "10s"
trusting_period = '16hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 1, denom = 'ppica' }
address_type = { derivation = 'cosmos' }
EOT
)

# osmo-test-5
export INC_OSMO_TEST_1=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_osmosis-testnet:8000'
grpc_addr = 'http://tasks.lb_osmosis-testnet:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_osmosis-testnet:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "osmo"
key_name = "osmosis-testnet"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 400000
max_gas = 25000000
gas_multiplier = 1.3
dynamic_gas_price = { enabled = true, multiplier = 1.2, max = 0.6 }
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "100s"
max_block_time = "10s"
trusting_period = '80hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.0025, denom = 'uosmo' }
address_type = { derivation = 'cosmos' }
EOT
)

# cosmoshub-testnet2
export INC_THETA_TESTNET_001=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_cosmoshub-testnet2:8000'
grpc_addr = 'http://tasks.lb_cosmoshub-testnet2:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_cosmoshub-testnet2:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "cosmos"
key_name = "cosmoshub-testnet2"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 200000
max_gas = 2500000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 1800000
max_grpc_decoding_size = 33554432
clock_drift = "1000s"
max_block_time = "10s"
trusting_period = '32hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.005, denom = 'uatom' }
address_type = { derivation = 'cosmos' }
EOT
)


# narwhal-2
export INC_NARWHAL_2=$(cat <<-EOT
type = "CosmosSdk"
rpc_addr = 'http://tasks.lb_whitewhale-testnet:8000'
grpc_addr = 'http://tasks.lb_whitewhale-testnet:8003'
# event_source = { mode = 'push', url = 'ws://tasks.lb_whitewhale-testnet:8000/websocket', batch_delay = '500ms' }
event_source = { mode = 'pull', interval = '1s' }
rpc_timeout = "30s"
trusted_node = true
account_prefix = "migaloo"
key_name = "whitewhale-testnet"
key_store_type = "Test"
store_prefix = "ibc"
default_gas = 1000000
max_gas = 5000000
gas_multiplier = 1.1
max_msg_num = 10
max_tx_size = 3000000
max_grpc_decoding_size = 33554432
clock_drift = "500s"
max_block_time = "10s"
trusting_period = '16hours'
ccv_consumer_chain = false
memo_prefix = "relayed by Notional.Ventures"
sequential_batch_tx = true
compat_mode = '0.37'
trust_threshold = { numerator = '1', denominator = '3' }
gas_price = { price = 0.25, denom = 'uwhale' }
address_type = { derivation = 'cosmos' }
EOT
)