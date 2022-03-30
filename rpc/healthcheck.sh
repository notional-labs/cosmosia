#!/bin/bash

BLOCKCHAIN_TIME=$(curl --silent --max-time 3 "http://localhost/status" |jq -r .result.sync_info.latest_block_time)
THRESHOLD_TIME=120

if [[ ${BLOCKCHAIN_TIME} == "null" ]]; then
  echo Status: 502
  echo Content-type:text/plain
  echo
  echo The node is currently not responding.
  exit 0
fi

if [[ ! -z  "$BLOCKCHAIN_TIME" ]]; then
  BLOCKCHAIN_SECS=`date -d $BLOCKCHAIN_TIME +%s`
  CURRENT_SECS=`date +%s`

  # if within $THRESHOLD_TIME seconds of current time, call it synced and report healthy
  BLOCK_AGE=$((${CURRENT_SECS} - ${BLOCKCHAIN_SECS}))

  if [[ ${BLOCK_AGE} -le ${THRESHOLD_TIME} ]]; then
    echo Status: 200
    echo Content-type:text/plain
    echo
    echo latest_block_time is less than $THRESHOLD_TIME seconds ago, this node is considered healthy.
  else
    echo Status: 503
    echo Content-type:text/plain
    echo
    echo latest_block_time is more than $THRESHOLD_TIME seconds ago, this node is responding but not synced
  fi
else
  echo Status: 502
  echo Content-type:text/plain
  echo
  echo The node is currently not responding.
fi