### RPC service

There is a [RPC service](../rpc) for each chain. Each RPC service could has one or more instances, and load-balanced with [load-balancer](../load_balancer).

Instance could be down or synching... at runtime. So there is a healthcheck cgi-script to let the load-balancer knowns if 
its healthy to serve.


