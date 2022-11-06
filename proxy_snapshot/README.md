# Proxy Snapshot

This service running on every host having snapshot services. It runs nginx to serve the static files on `/mnt/data/snapshots`.
The purpose is to provide direct snapshot link for faster downloading without going through proxy (see https://github.com/notional-labs/cosmosia/issues/201).

