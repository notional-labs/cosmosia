import requests
import time


def scan_clients():
    print("scan_clients...")
    # is_fetching = True
    pagination_key = ""

    while True:
        time.sleep(3)
        # print("pagination_key={}".format(pagination_key))
        url = "https://api-composable-ia.cosmosia.notional.ventures/ibc/core/client/v1/client_states?pagination.limit=100&pagination.key={}".format(
            pagination_key)
        rq = requests.get(url)
        rq_json = rq.json()
        pagination_key = rq_json["pagination"]["next_key"]
        client_states = rq_json["client_states"]
        if len(client_states) <= 0:
            # is_fetching = False
            break

        for cs in client_states:
            try:
                client_id = cs["client_id"]
                x_id = ""

                if client_id.startswith("08-wasm-"):
                    x_id = cs["client_state"]["code_id"]
                elif client_id.startswith("07-tendermint-"):
                    x_id = cs["client_state"]["chain_id"]
                else:
                    x_id = ""

                print("client_id={}, chain_id/code_id={}".format(client_id, x_id))
            except:
                print(cs)


if __name__ == '__main__':
    print("ibc_scan")
    scan_clients()
