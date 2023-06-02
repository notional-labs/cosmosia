cd $HOME
source ~/env.sh
rpc_service_name=$rpc_service_name haproxy -D -f /etc/haproxy/haproxy.cfg -sf $(cat /var/run/haproxy.pid)