# Json responses follow JSend spec (https://github.com/omniti-labs/jsend)
import flask
import os.path
import re
import subprocess

app = flask.Flask(__name__)
config_file = "/etc/nginx/ip_whitelist.conf"


def remove_prefix(text, prefix):
    return text[text.startswith(prefix) and len(prefix):]


@app.route('/', methods=['GET'])
def default():
    return flask.send_from_directory('static', 'index.html')


@app.route('/get_config', methods=['GET'])
def get_config():
    cidrs = []

    with open(config_file, 'r') as f_config:
        lst_lines = f_config.readlines()

        for str_cidr in lst_lines:
            cidr = str_cidr.strip()
            if cidr.startswith("allow") :
                cidr = cidr.replace('\n', '')
                cidr = cidr.removeprefix("allow")
                cidr = cidr.removesuffix(";")
                cidr = cidr.strip()
                cidrs.append(cidr)

    str_data = " ".join(cidrs)

    return {
        'status': "success",
        'data': str_data
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
        str_cidr = str_cidr.strip()
        if not bool(re.match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(?:/\d{1,2}|)$", str_cidr)):
            return {
                "status": "fail",
                "message": "Invalid address " + str_cidr
            }

    # validated, write to file
    with open(config_file, 'w') as f_config:
        for str_cidr in cidr_list:
            str_cidr = str_cidr.strip()
            f_config.write("allow " + str_cidr + ";\n")

    # run `/usr/sbin/nginx -t` to test configuration
    rc = subprocess.call("/usr/sbin/nginx -t", shell=True)
    print("/usr/sbin/nginx -t => rc=" + str(rc))
    if rc != 0:
        return {
            "status": "fail",
            "message": "Invalid address "
        }

    # everything OK now, reload nginx
    rc = subprocess.call("/usr/sbin/nginx -s reload", shell=True)
    print("/usr/sbin/nginx -s reload => rc=" + str(rc))

    return {
        'status': "success",
        'data': ""
    }


if __name__ == '__main__':
    if not os.path.exists(config_file):
        print("Config file " + config_file + " does not exist. Create a default config file.")
        with open(config_file, 'w') as f:
            f.write("allow 127.0.0.1/32;")

    app.run(host="0.0.0.0", port=5001)
