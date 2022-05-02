# Monitoring tools for Internal

### RPC Health
See https://github.com/notional-labs/cosmosia/issues/18

While the [status page](https://status.notional.ventures/) can be used for service healthy from external view, 
it doesnt not give details in case like 50% tasks down of a service. In that case, the service still looks
healthy externally, but its not.

With this tool, we can see healthy status of every taksk of every rpc service in the cluster.

![internal_rpc_healthy](rpc_monitor.png)


### RPC performance
We can see metrics like requests per second or response time. Using prometheus/grafana, it is flexible and
can be used to monitor anything else.

![grafana](grafana.png)

