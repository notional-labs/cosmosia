cd $HOME
source ~/env.sh

# haproxy -D -f /etc/haproxy/haproxy.cfg -sf $(cat /var/run/haproxy.pid)
haproxy -D -f $CONFIG_FILE -sf $(cat /var/run/haproxy.pid)
