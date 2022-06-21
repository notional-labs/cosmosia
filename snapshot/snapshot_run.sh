# usage: ./snapshost_run.sh chain_name [db_backend]
# eg., ./snapshost_run.sh cosmoshub goleveldb
# db_backend: goleveldb rocksdb, default is goleveldb

chain_name="$1"
db_backend="$2"

if [[ -z $chain_name ]]
then
  echo "No chain_name. usage eg., ./snapshost_run.sh cosmoshub"
  exit
fi

[[ -z $db_backend ]] && db_backend="goleveldb"

cd $HOME
pacman -Sy --noconfirm go git base-devel wget jq dnsutils inetutils python python-pip cronie nginx spawn-fcgi fcgiwrap cpulimit

echo "#################################################################################################################"
echo "nginx..."

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/57-add-rocksdb-snapshot-service/snapshot/snapshot.nginx.conf" > /etc/nginx/nginx.conf
# mkdir -p /snapshot
/usr/sbin/nginx

sleep 5

# use start_chain.sh to start chain with local peers
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/57-add-rocksdb-snapshot-service/rpc/start_chain.sh" > $HOME/start_chain.sh
curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/57-add-rocksdb-snapshot-service/snapshot/snapshot_download.sh" > $HOME/snapshot_download.sh



if [[ $db_backend == "rocksdb" ]]; then
  echo "#################################################################################################################"
  echo "install rocksdb"

  pacman -Sy --noconfirm cmake python snappy zlib bzip2 lz4 zstd

  # ===============================================
  # install gflags
  cd $HOME
  git clone https://github.com/gflags/gflags.git
  cd gflags
  mkdir build
  cd build
  cmake -DBUILD_SHARED_LIBS=1 -DGFLAGS_INSTALL_SHARED_LIBS=1 ..
  make install


  # ===============================================
  # installing rocksdb from source
  cd $HOME
  git clone --single-branch --branch $rocksdb_version https://github.com/facebook/rocksdb
  cd rocksdb
  make -j4 install-shared
  ldconfig

  # ===============
  cp --preserve=links /usr/local/lib/libgflags* /usr/lib/
  cp --preserve=links /usr/local/lib/librocksdb.so* /usr/lib/
  cp -r /usr/local/include/rocksdb /usr/include/rocksdb

  # ===========
  export CGO_CFLAGS="-I/usr/local/include"
  export CGO_LDFLAGS="-L/usr/local/lib -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4 -lzstd"
fi


########################################################################################################################
# TODO: fix cosmos-pruner with rocksdb
echo "install cosmos-pruner"
git clone https://github.com/binaryholdings/cosmprund
cd cosmprund
make install


########################################################################################################################
# download snapshot
cd $HOME
source $HOME/snapshot_download.sh

########################################################################################################################
# supervised
pip install supervisor
mkdir -p /etc/supervisor/conf.d
echo_supervisord_conf > /etc/supervisor/supervisord.conf
echo "[include]
files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf


cat <<EOT > /etc/supervisor/conf.d/chain.conf
[program:chain]
command=/bin/bash /root/start_chain.sh $chain_name $db_backend
autostart=false
autorestart=false
stopasgroup=true
killasgroup=true
stderr_logfile=/var/log/chain.err.log
stdout_logfile=/var/log/chain.out.log
EOT

supervisord

########################################################################################################################
# cron

curl -Ls "https://raw.githubusercontent.com/notional-labs/cosmosia/57-add-rocksdb-snapshot-service/snapshot/snapshot_cronjob.sh" > $HOME/snapshot_cronjob.sh

if [[ -z $snapshot_time ]]; then
  echo "No time setting to take snapshot, please set snapshot_time in chain_registry.ini"
  exit
fi

snapshot_time_hour=${snapshot_time%%:*}
snapshot_time_minute=${snapshot_time##*:}
echo "$snapshot_time_minute $snapshot_time_hour * * * root /usr/bin/flock -n /var/run/lock/snapshot_cronjob.lock /bin/bash $HOME/snapshot_cronjob.sh" > /etc/cron.d/cron_snapshot

# start crond
# TODO: fix rocksdb
[[ $db_backend == "goleveldb" ]] && crond

# loop forever for debugging only
while true; do sleep 5; done