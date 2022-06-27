import flask

app = flask.Flask(__name__)

@app.route('/', methods=['GET'])
def default():
    return 'web_config'


@app.route('/configs/<name>', methods=['GET'])
def get_config(name):
    return "The config is " + str(name)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001)
