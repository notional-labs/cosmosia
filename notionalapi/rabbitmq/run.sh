pacman -Syu --noconfirm
pacman -S --noconfirm rabbitmq screen python python-pip


# config rabbitmq
cat <<EOT >> /etc/rabbitmq/rabbitmq.conf
loopback_users = none
cluster_name = napi-counter
EOT

rabbitmq-plugins enable rabbitmq_management

# start rabbitmq-server
screen -S rabbitmq -dm rabbitmq-server

sleep 60

# rabbitmqadmin
curl -Ls "http://localhost:15672/cli/rabbitmqadmin" > /usr/local/bin/rabbitmqadmin
chmod 777 /usr/local/bin/rabbitmqadmin

# creating queue
rabbitmqadmin declare queue name=q1 durable=false


# loop forever for debugging only
while true; do sleep 5; done