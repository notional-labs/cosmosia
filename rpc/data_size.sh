#!/bin/bash

source $HOME/env.sh
data_size=$(du -hs $node_home |cut -f1)
current_date=$(date)

cat <<EOT
Status: 200
Content-type:application/json

{
  "data_size": "$data_size",
  "date_time": "$current_date"
}
EOT
