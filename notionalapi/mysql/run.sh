pacman -Syu --noconfirm
pacman -S --noconfirm mariadb mariadb-clients screen

# install
mariadb-install-db --datadir=/var/lib/mysql

# start
screen -S mysql -dm /usr/bin/mysqld --user=root --datadir='/var/lib/mysql'


# init
mysql --user=root mysql <<< cat <<EOT
CREATE USER  'root'@'%' IDENTIFIED BY 'invalid';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT PROXY ON ''@'%' TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOT

# shutdown
# kill -SIGTERM $(pidof mysqld)

# loop forever for debugging only
while true; do sleep 5; done