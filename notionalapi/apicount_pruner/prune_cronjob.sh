


echo "----------------------------------------------------------------------------------------"
echo "prune to keep data for last 30 days only"
echo "today: $(date +%Y%m%d)"

unixtime_now=`date +%s`
unixtime_30d_ago=$((${unixtime_now} - 2592000))
threshold=$(date -d @$unixtime_30d_ago +%Y%m%d)

echo "threshold (30 days ago): ${threshold}"

if [[ -z $threshold ]]; then
  echo "invalid threshold, exit"
  exit
fi

if [[ ${threshold} -le 1 ]]; then
  echo "invalid threshold, exit"
  exit
fi

echo "Prunning data before ${threshold}"

/usr/bin/mysql --host=tasks.napi_mysql --user=root --password=invalid --protocol=tcp db_apicount <<< cat <<EOT
DELETE FROM tbl_apicount WHERE dt < ${threshold}
EOT


echo "Done"
