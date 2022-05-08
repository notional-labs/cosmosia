# Json responses follow JSend spec (https://github.com/omniti-labs/jsend)


import flask
import os.path

app = flask.Flask(__name__)

config_file = "./ip_whitelist.cnf"


def get_default_config():
    return {
        'status': "success",
        'data': "0.0.0.0"
    }


@app.route('/', methods=['GET'])
def default():
    return flask.send_from_directory('static', 'index.html')


@app.route('/get_config', methods=['GET'])
def get_config():
    if not os.path.exists(config_file):
        return get_default_config()

    return {
        'status': "success",
        'data': "1.1.1.1.1/24 2.2.2.2"
    }


@app.route('/set_config', methods=['POST'])
def set_config():
    content = flask.request.get_json()

    return content


if __name__ == '__main__':
    app.run()
