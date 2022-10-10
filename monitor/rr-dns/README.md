# round-robin DNS

https://github.com/notional-labs/cosmosia/issues/29

- set several IP addresses (servers) for a single domain name on Cloudflare DNS
- monitor these IPs (servers)
- Update DNS record using Cloudflare API if state of servers changed (up -> down, down -> up)
