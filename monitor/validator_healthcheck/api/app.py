import flask
import requests
import json

app = flask.Flask(__name__)


@app.route('/get_validator_status', methods=['GET'])
def get_validator_status():
    consensus_address = flask.request.args.get('consensus_address')
    consensus_address = consensus_address.upper()

    rpc_endpoint = flask.request.args.get('rpc_endpoint')

    print("consensus_address: " + consensus_address)
    print("rpc_endpoint: " + rpc_endpoint)

    rpc_request = requests.get(rpc_endpoint + "/block?height=")
    rpc_request_json = rpc_request.json()
    signatures = rpc_request_json["result"]["block"]["last_commit"]["signatures"]
    print("validators=" + json.dumps(signatures))

    try:
        match = next(itr for itr in signatures if itr['validator_address'] == consensus_address)
        print("match=" + json.dumps(match))

        return "up", 200
    except StopIteration:
        print("Not found validator_address in last block")

    return "down", 500


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001)
