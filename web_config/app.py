import flask
import docker
import base64
import io

app = flask.Flask(__name__)

client = docker.DockerClient(base_url='unix://var/run/docker.sock')


@app.route('/', methods=['GET'])
def default():
    return 'web_config'


@app.route('/config/<name>', methods=['GET'])
def get_config(name):
    configs = client.configs.list(filters={"name": [name]})
    if len(configs) > 0:
        config = configs[0].attrs
        config_data = config['Spec']['Data']
        base64_bytes = config_data.encode('utf-8')
        base64_decode = base64.decodebytes(base64_bytes)
        return flask.send_file(io.BytesIO(base64_decode), attachment_filename=name)

    return "Config not found", 404


@app.route('/node_ip/<name>', methods=['GET'])
def get_node_ip(name):
    nodes = client.nodes.list(filters={"name": [name]})
    if len(nodes) > 0:
        node = nodes[0].attrs
        node_ip = node['Status']['Addr']
        return node_ip, 200

    return "node not found", 404


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001)
