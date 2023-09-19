pacman -Syu --noconfirm
pacman -S --noconfirm mariadb mariadb-clients screen

# install
mariadb-install-db --datadir=/var/lib/mysql

# start
screen -S mysql -dm /usr/bin/mysqld --user=root --datadir='/var/lib/mysql'


# init
mysql --user=root mysql <<< cat <<EOT
CREATE USER 'root'@'%' IDENTIFIED BY 'invalid';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT PROXY ON ''@'%' TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE DATABASE db_apicount;
USE db_apicount;
CREATE TABLE tbl_apicount (
	id CHAR(32) NOT NULL,
	dt  INT NOT NULL,
	apikey CHAR(32) NOT NULL,
	chain CHAR(27) NOT NULL,
	protocol CHAR(1) NOT NULL,
	method VARCHAR(128) NOT NULL,
	point INT NOT NULL,
	PRIMARY KEY (id),
	INDEX (dt, apikey, chain, protocol)
);
EOT

# shutdown
# kill -SIGTERM $(pidof mysqld)

# loop forever for debugging only
while true; do sleep 5; done