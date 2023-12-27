import os
import subprocess
import time
import shlex
import json
from prometheus_client import Gauge, start_http_server


def get_account_address(chain_id, keyname):
    result = ""
    dir_path = f'/root/.hermes/keys/{chain_id}/keyring-test/{keyname}.json'
    with open(dir_path) as json_file:
        json_obj = json.load(json_file)
        result = json_obj["account"]

    return result


def get_subfolders_in_path(path):
    subfolders = [f.name for f in os.scandir(path) if f.is_dir()]
    return subfolders


def extract_result(str):
    res = None
    # SUCCESS balance for key `migaloo`: 82731397 uwhale
    if str.startswith("SUCCESS"):
        subs = str.split(": ", 1)
        balance = subs[1].strip()
        balance_subs = balance.split(" ", 1)
        balance_value = int(subs[0])
        balance_denom = subs[1]

        subs = str.split("`", 1)
        keyname = subs[1]
        res = {
            "keyname": keyname,
            "balance": balance_value,
            "denom": balance_denom,
        }

    return res


def run_cmd(cmd):
    """
    # $HOME/.hermes/bin/hermes keys balance --chain migaloo-1
    SUCCESS balance for key `migaloo`: 82731397 uwhale
    """

    args = shlex.split(cmd)
    result = subprocess.run(args, stdout=subprocess.PIPE)
    txtout = result.stdout.decode('utf-8')
    print(txtout)
    return txtout


def metrics_server():
    chain_ids = get_subfolders_in_path('/root/.hermes/keys')
    print(f'chain_ids={chain_ids}')

    start_http_server(8000) # Start up the server to expose the metrics.

    # wallet_balance{account="migaloo1t53wkmgjp5vksed2hw4e3625kq0jyas06w9shm",chain="migaloo-1",denom="uwhale",service_name="unknown_service",otel_scope_name="hermes",otel_scope_version=""} 22086720
    g_wallet_balance = Gauge('wallet_balance', 'TYPE wallet_balance gauge', ["account", "chain", "denom"])

    while True:
        for chain_id in chain_ids:
            print(f'processing {chain_id}')

            txtout = run_cmd(f'/root/.hermes/bin/hermes keys balance --chain {chain_id}')
            balance = extract_result(txtout)
            if balance is not None:
                account = get_account_address(chain_id, balance["keyname"])
                g_wallet_balance.labels(account=account, chain=chain_id, denom=balance["denom"]).set(balance["balance"])

        time.sleep(60)


if __name__ == '__main__':
    metrics_server()

