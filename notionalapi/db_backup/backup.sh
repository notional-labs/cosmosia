#!/bin/bash
cd $HOME

SQL_FILENAME="napidb_$(date +%Y%m%d_%T |sed 's/://g').sql"
curl -s -XGET http://tasks.napidb_1:4001/db/backup?fmt=sql -o "/data/${SQL_FILENAME}"