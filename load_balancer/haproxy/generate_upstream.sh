# usage: ./generate_upstream.sh chain_name scale
# eg., ./generate_upstream.sh cosmoshub 2

chain_name="$1"
scale=$2
echo "chain_name=$chain_name, scale=$scale"
if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./generate_upstream.sh cosmoshub 2"
  exit
fi

if [[ -z $scale ]]; then
  echo "No scale. usage eg., ./generate_upstream.sh cosmoshub 2"
  exit
fi

CONFIG_FILE="$HOME/haproxy.cfg"
TMP_CONFIG_FILE="$HOME/haproxy.cfg.tmp"

default_node="127.0.0.1"

# figure out IPs of services
#new_ips=$(dig +short "tasks.$rpc_service_name" |sort)

new_ips=""
node_num=1
while [[ node_num -le scale ]]; do
  rpc_node="tasks.rpc_${chain_name}_${node_num}"
  ip=$(dig +short "$rpc_node")
#  echo "ip of $rpc_node is $ip"

  if [[ ! -z $new_ips ]]; then
    new_ips="${new_ips}"$'\n'
  fi
  new_ips="${new_ips}${ip}"

  ((node_num++));
done

#echo "$new_ips"

rpc_str=""
api_str=""
grpc_str=""
jsonrpc_str=""
ws_jsonrpc_str=""
if [[ -z "$new_ips" ]]; then
    rpc_str="    server  s1 $default_node:26657 check port 80 inter 10s weight 1"
    api_str="    server  s1 $default_node:1317 check port 80 inter 10s weight 1"
    grpc_str="    server  s1 $default_node:9090 check port 80 inter 10s weight 1"
    jsonrpc_str="    server  s1 $default_node:8545 check port 80 inter 10s weight 1"
    ws_jsonrpc_str="    server  s1 $default_node:8546 check port 80 inter 10s weight 1"
else
  while read -r ip_addr || [[ -n $ip_addr ]]; do
      if [[ ! -z $rpc_str ]]; then
        rpc_str="${rpc_str}"$'\n'
        api_str="${api_str}"$'\n'
        grpc_str="${grpc_str}"$'\n'
        jsonrpc_str="${rpc_str}"$'\n'
        ws_jsonrpc_str="${ws_jsonrpc_str}"$'\n'
      fi
      rpc_str="$rpc_str    server  s1 $ip_addr:26657 check port 80 inter 10s weight 1"
      api_str="$api_str    server  s1 $ip_addr:1317 check port 80 inter 10s weight 1"
      grpc_str="$grpc_str    server  s1 $ip_addr:9090 proto h2 check port 80 inter 10s weight 1"
      jsonrpc_str="$jsonrpc_str    server  s1 $ip_addr:8545 check port 80 inter 10s weight 1"
      ws_jsonrpc_str="$ws_jsonrpc_str    server  s1 $ip_addr:8546 check port 80 inter 10s weight 1"
  done < <(echo "$new_ips")
fi



JSONRPC_CONFIG=""
if [[ $chain_name == evmos* ]]; then
  JSONRPC_CONFIG=$( cat <<EOT
# to be append to haproxy.cfg for needed chains
frontend  fe_eth
    bind :8004
    mode                 http
    log                  global
    option               httplog
    option               dontlognull
    option forwardfor    except 127.0.0.0/8

    default_backend   be_eth


frontend  fe_ethws
    bind :8005
    mode                 http
    log                  global
    option               httplog
    option               dontlognull
    option forwardfor    except 127.0.0.0/8

    default_backend   be_ethws


backend be_eth
    mode        http
    balance     roundrobin
    option httpchk
    http-check connect proto h1
    http-check send meth GET  uri /healthcheck
$jsonrpc_str


backend be_ethws
    mode        http
    balance     roundrobin
    option httpchk
    http-check connect proto h1
    http-check send meth GET  uri /healthcheck
$ws_jsonrpc_str
EOT
  )
fi

cat <<EOT > $TMP_CONFIG_FILE
# This file is generated dynamically, dont edit.
global
    maxconn     20000
    log         127.0.0.1 local0
    user        haproxy
    chroot      /usr/share/haproxy
    pidfile     /run/haproxy.pid
    daemon


defaults
    timeout connect 5s
    timeout client 1m
    timeout server 1m
    timeout queue  60s


resolvers ns
    nameserver ns1 127.0.0.11:53
    accepted_payload_size 512
    parse-resolv-conf

    hold valid    10s
    hold other    30s
    hold refused  30s
    hold nx       30s
    hold timeout  30s
    hold obsolete 30s

    resolve_retries 3
    timeout retry 1s
    timeout resolve 1s


frontend stats
    mode http
    bind *:2019
    http-request use-service prometheus-exporter if { path /metrics }
    stats enable
    stats uri /stats
    stats refresh 10s


frontend  fe_rpc
    bind :8000
    mode                 http
    log                  global
    option               httplog
    option               dontlognull
    option forwardfor    except 127.0.0.0/8

    default_backend   be_rpc


frontend  fe_api
    bind :8001
    mode                 http
    log                  global
    option               httplog
    option               dontlognull
    option forwardfor    except 127.0.0.0/8

    default_backend   be_api


frontend  fe_grpc
    bind :8003 proto h2
    mode                 http
    log                  global

    default_backend   be_grpc


backend be_rpc
    mode        http
    balance     roundrobin
    option httpchk
    http-check connect proto h1
    http-check send meth GET  uri /healthcheck
$rpc_str

backend be_api
    mode        http
    balance     roundrobin
    option httpchk
    http-check connect proto h1
    http-check send meth GET  uri /healthcheck
$api_str


backend be_grpc
    mode        http
    balance     roundrobin
    option httpchk
    http-check connect proto h1
    http-check send meth GET  uri /healthcheck
    $grpc_str


$JSONRPC_CONFIG
EOT
