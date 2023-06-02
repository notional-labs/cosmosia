cd $HOME
source ~/env.sh

# generate config file, fix https://github.com/notional-labs/cosmosia/issues/363
cat <<EOT >> /etc/haproxy/haproxy.cfg
$(<$HOME/haproxy.cfg)
EOT

haproxy -D -f /etc/haproxy/haproxy.cfg -sf $(cat /var/run/haproxy.pid)