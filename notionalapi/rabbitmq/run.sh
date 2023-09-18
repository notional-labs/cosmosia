pacman -Syu --noconfirm
pacman -S --noconfirm rabbitmq screen


# config rabbitmq
cat <<EOT >> /etc/rabbitmq/rabbitmq.conf
loopback_users = none
EOT

rabbitmq-plugins enable rabbitmq_management

# start rabbitmq-server
screen -S rabbitmq -dm rabbitmq-server



# loop forever for debugging only
while true; do sleep 5; done