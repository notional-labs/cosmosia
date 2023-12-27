import os
import subprocess
import time
import shlex
from prometheus_client import Gauge, start_http_server


def get_subfolders_in_path(path):
    # /root/.hermes/keys
    subfolders = [f.name for f in os.scandir(path) if f.is_dir()]
    return subfolders

def extract_result(str):
    res = None
    # SUCCESS balance for key `migaloo`: 82731397 uwhale
    if str.startswith("SUCCESS"):
        subs = str.split(": ", 1)
        res = subs[1]

    return res

def run_cmd(cmd):
    """
    # $HOME/.hermes/bin/hermes keys balance --chain migaloo-1
    SUCCESS balance for key `migaloo`: 82731397 uwhale
    """

    args = shlex.split(cmd)
    result = subprocess.run([args], stdout=subprocess.PIPE)
    txtout = result.stdout.decode('utf-8')
    print(txtout)
    return txtout


def metrics_server():
    chain_ids = get_subfolders_in_path('/root/.hermes/keys')
    print(f'chain_ids={chain_ids}')


    # Start up the server to expose the metrics.
    start_http_server(8000)

    # wallet_balance{account="migaloo1t53wkmgjp5vksed2hw4e3625kq0jyas06w9shm",chain="migaloo-1",denom="uwhale",service_name="unknown_service",otel_scope_name="hermes",otel_scope_version=""} 22086720
    g_wallet_balance = Gauge('wallet_balance', 'TYPE wallet_balance gauge', ["chain", "denom"])
    # g_wallet_balance1 = Gauge('wallet_balance1', 'TYPE wallet_balance gauge', ["label1", "label2"])

    while True:
        for chain_id in chain_ids:
            print(f'processing {chain_id}')

            txtout = run_cmd(f'/root/.hermes/bin/hermes keys balance --chain {chain_id}')
            balance = extract_result(txtout)
            subs = balance.split(" ", 1)
            v = int(subs[0])
            denom = subs[1]

            g_wallet_balance.labels(chain=chain_id, denom=denom).set(v)

        time.sleep(60)


if __name__ == '__main__':
    metrics_server()
    # chain_id = 'noble-1'
    # args = shlex.split(f'/root/.hermes/bin/hermes keys balance --chain {chain_id}')
    # print(args)

