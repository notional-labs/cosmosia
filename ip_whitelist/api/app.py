# Json responses follow JSend spec (https://github.com/omniti-labs/jsend)
import flask
import os.path
import re
import subprocess

app = flask.Flask(__name__)

config_file = "./ip_whitelist.conf"


def get_default_config():
    return {
        'status': "success",
        'data': "0.0.0.0"
    }


def reload_nginx():
    rc = subprocess.call("nginx reload", shell=True)
    print("rc=" + str(rc))


@app.route('/', methods=['GET'])
def default():
    return flask.send_from_directory('static', 'index.html')


@app.route('/get_config', methods=['GET'])
def get_config():
    if not os.path.exists(config_file):
        return get_default_config()

    with open(config_file, 'r') as file:
        data = file.read().replace('\n', '')

    return {
        'status': "success",
        'data': data
    }


# format: {"data":"2.2.2.2/24 3.3.3.3"}
@app.route('/set_config', methods=['POST'])
def set_config():
    # validate content_length
    if flask.request.content_length > (4 * 1024):
        return {
            "status": "fail",
            "message": "content_length too large, should be less than 4KB"
        }

    json_content = flask.request.get_json()
    if "data" not in json_content:
        return {
            "status": "fail",
            "message": "invalid json, no data key"
        }

    print("json_content.data=" + json_content['data'])

    # validate IP/CIDR
    data = json_content['data']
    cidr_list = data.split()

    if len(cidr_list) <= 0:
        return {
            "status": "fail",
            "message": "invalid data"
        }

    for str_cidr in cidr_list:
        if not bool(re.match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(?:/\d{1,2}|)$", str_cidr)):
            return {
                "status": "fail",
                "message": "Invalid address " + str_cidr
            }

    # validated, write to file
    with open(config_file, 'w') as f:
        f.write(data)

    reload_nginx()

    return {
        'status': "success",
        'data': ""
    }


if __name__ == '__main__':
    app.run()
