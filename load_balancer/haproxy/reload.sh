cd $HOME
source ~/env.sh
rpc_service_name=$rpc_service_name haproxy -D -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)