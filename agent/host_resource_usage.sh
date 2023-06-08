#!/bin/bash

cpu_usage=$(grep 'cpu ' /proc/stat |awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')

ram_total=$(free -g |grep Mem |awk '{print $2}')
ram_usage=$(free |grep Mem |awk '{print $3/$2 * 100.0}')

disk_size=$(df --output=size -h / |sed 1d |sed 's/ //g')
disk_usage=$(df --output=pcent / |sed 1d |sed 's/ //g')


echo "Status: 200"
echo "Content-type:application/json"
echo ""
echo "{"
echo "    \"cpu_usage\":\"${cpu_usage}%\","
echo "    \"ram_total\":\"${ram_total}G\","
echo "    \"ram_usage\":\"${ram_usage}%\","
echo "    \"disk_size\":\"${disk_size}\","
echo "    \"disk_usage\":\"${disk_usage}\""
echo "}"