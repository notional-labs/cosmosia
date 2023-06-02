cd $HOME
source ~/env.sh

# generate config file, fix https://github.com/notional-labs/cosmosia/issues/363
rpc_service_name="$rpc_service_name" envsubst < $HOME/haproxy.cfg > /etc/haproxy/haproxy.cfg

haproxy -D -f /etc/haproxy/haproxy.cfg -sf $(cat /var/run/haproxy.pid)