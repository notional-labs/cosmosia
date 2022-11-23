# SSL

SSL files need to be able to provide ssl/tls for endpoints.


### Generate SSL with certbot

Let's Encrypt certs is a free but max expiration is 3 months. So it requires to renew every few months.

```console
certbot certonly --manual -d notional.ventures -d *.notional.ventures -d *.cosmosia.notional.ventures -d *.internalendpoints.notional.ventures
```

There are 2 files: `fullchain.pem` and `privkey.pem`


### Store SSL files in Docker Swarm configs

Read more about [Docker Swarm configs](https://docs.docker.com/engine/swarm/configs/)

```console
docker config rm fullchain.pem
docker config rm privkey.pem
docker config create fullchain.pem ./fullchain.pem
docker config create privkey.pem ./privkey.pem
```

