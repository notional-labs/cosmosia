import flask
import requests
import json

app = flask.Flask(__name__)


@app.route('/get_validator_status', methods=['GET'])
def get_config():
    consensus_address = flask.request.args.get('consensus_address')
    consensus_address = consensus_address.upper()

    rpc_endpoint = flask.request.args.get('rpc_endpoint')

    print("consensus_address: " + consensus_address)
    print("rpc_endpoint: " + rpc_endpoint)

    rpc_request = requests.get(rpc_endpoint + "/validators?height=")
    rpc_request_json = rpc_request.json()
    validators = rpc_request_json["result"]["validators"]
    print("validators=" + json.dumps(validators))

    return "down", 200


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001)
