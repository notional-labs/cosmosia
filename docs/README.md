# Docs

Flow: Proxy (Nginx) => Load Balancer (Caddy) => Rpc nodes

Everything run on Docker Swarm.
Proxy and Load Balancer can be one software but in our design we use as 2 separated softwares as
- nginx doesnt support active healthcheck with the free opensource version. Caddy does support active healthcheck
- The system provides services for multiple chains (35 at the time of writing). Each chain can scale up/down, so 
  load-balancer needs auto-discovery and that requires reload config => a bit heavy for proxy, load-balancers help to handle this.
- The system is being used by multiple purpose: for public, private, partners... So having separated proxy is more flexible


There is a load-balance service for each chain.
There are 2 proxy service:
- Public proxy: for public and has rate-limiting
- Private proxy: for high traffic RPC, has ip-whitelist. And Api to update this list.


### Links
- [How to add a new chain](new_chain.md)
- [Prepare a Docker Swarm node](prepare.md)
- [Snapshot Service](snapshot.md)



