pacman -Syu --noconfirm
pacman -S --noconfirm rabbitmq screen


# config rabbitmq
cat <<EOT >> /etc/rabbitmq/rabbitmq.conf
loopback_users = none
EOT


# start rabbitmq-server
screen -S rabbitmq -dm rabbitmq-server