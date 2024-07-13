#!/bin/bash

# declare timestamp
STAMP=`date +"%s-%A-%d-%B-%Y-@-%Hh%Mm%Ss"`

# declare api key
API_KEY=$1

# check arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <API_KEY>"
    exit 1
fi

# declare total
SUM=0

# declare chains array
CHAINS=$(cat <<-END
agoric
archway
axelar
canto
celestia
chihuahua
composable-testnet
composable
coreum
cosmoshub-testnet2
cosmoshub-testnet
cosmoshub
crescent
dydx-testnet
dydx
eve-testnet
evmos
furya
gravitybridge
injective-testnet
injective
juno
kava
kujira-testnet
kujira
neutron-testnet
neutron
noble
osmosis-testnet
osmosis
quicksilver-archive-sub
quicksilver-testnet
quicksilver
regen-testnet
regen
saga
sommelier
stargaze-testnet
stargaze
stride
terra2
umee
whitewhale-testnet
whitewhale
END
)

sum_up () {

local VALUE=$1
SUM=$((SUM + VALUE))

}

get_timestamp () {

local CHAIN=$1
local API_KEY=$2
local CURRENT_BLOCK_HEIGHT=$3

PREVIOUS_BLOCK_HEIGHT=$((CURRENT_BLOCK_HEIGHT - 1 ))

FIRST_TIMESTAMP=$(curl -Ls -o- https://r-${CHAIN}--${API_KEY}.gw.notionalapi.net/block?height=${CURRENT_BLOCK_HEIGHT} | jq '.result.block.header.time')
SECOND_TIMESTAMP=$(curl -Ls -o- https://r-${CHAIN}--${API_KEY}.gw.notionalapi.net/block?height=${PREVIOUS_BLOCK_HEIGHT} | jq '.result.block.header.time')

DATE_PART_1=$(echo "$FIRST_TIMESTAMP" | cut -d'.' -f1 | sed 's/"//g')
DATE_PART_2=$(echo "$SECOND_TIMESTAMP" | cut -d'.' -f1 | sed 's/"//g')

EPOCH_1=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$DATE_PART_1" +"%s")
EPOCH_2=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$DATE_PART_2" +"%s")

BLOCK_TIME=$((EPOCH_1 - EPOCH_2))

}

# get block time function
get_block_time () {

local CURRENT_BLOCK_HEIGHT=$1
local CHAIN=$2
local API_KEY=$3
local RANGE=$4
local FIX_RANGE=$4

while [[ ${RANGE} -gt 0 ]]; do
  get_timestamp ${CHAIN} ${API_KEY} ${CURRENT_BLOCK_HEIGHT}
  sum_up ${BLOCK_TIME}
  CURRENT_BLOCK_HEIGHT=$((CURRENT_BLOCK_HEIGHT - 1))
  RANGE=$((RANGE - 1))
done

BLOCK_TIME=$(echo "scale=2; ${SUM} / ${FIX_RANGE}" | bc)

}

# write table header
echo "| Chain_name| Blocks                                                  |" >> ${STAMP}.txt
echo "|-----------|:--------------------------------------------------------|" >> ${STAMP}.txt

# loop print out blocks
for CHAIN in ${CHAINS}; do
  (
  echo "Processing ${CHAIN}"

  BLOCK_HEIGHT=$(curl -Ls -o- https://r-${CHAIN}--${API_KEY}.gw.notionalapi.net/status | jq -r '.result.sync_info.latest_block_height')

  get_block_time ${BLOCK_HEIGHT} ${CHAIN} ${API_KEY} 10

  UNBONDING_TIME=$(curl -Ls -o- https://a-${CHAIN}--${API_KEY}.gw.notionalapi.net/cosmos/staking/v1beta1/params | jq '.params.unbonding_time' | sed 's/"//g' | sed 's/s//g')
  # BLOCK_TIME=$(floor "${BLOCK_TIME}")
  # BLOCKS=$(echo "scale=2; ${BLOCK_HEIGHT} / ${BLOCK_TIME}" | bc)

  BLOCKS=$(echo "scale=2; ${UNBONDING_TIME} / ${BLOCK_TIME} / 100 * 115" | bc)
  echo "| ${CHAIN}      | ${BLOCKS}                   |" >> ${STAMP}.txt
  # echo "${CHAIN} | block time | blocks: ${BLOCK_TIME} | ${BLOCKS}" >> ${STAMP}.txt

  ) &
done

# Define the input file
input_file="${STAMP}.txt"

# Function to count the number of lines in the array
count_array_lines() {
  echo "$CHAINS" | wc -l
}

# Function to count the number of lines in the file
count_file_lines() {
  wc -l < "$input_file"
}

# Function to check if the number of lines in the array equals the number of lines in the file
check_lines() {
  array_lines=$(($(count_array_lines) + 2))
  file_lines=$(count_file_lines)

  if [[ "$array_lines" -eq "$file_lines" ]]; then
    echo "Done"
    sh sort.sh ${STAMP}.txt >> ${STAMP}.txt
    cat ${STAMP}.txt
    return 0
  else
    echo "Calculating..."
    sleep 10
    return 1
  fi
}

# Loop until the number of lines matches
while ! check_lines; do
  :
done
