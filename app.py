from flask import Flask, request, jsonify
import docker
import json

app = Flask(__name__)
client = docker.from_env()

# Carica la configurazione della lingua e della porta
with open('config.json') as config_file:
    config = json.load(config_file)
    selected_language = config.get("language", "en")
    panel_port = config.get("port", 5000)

# Carica le traduzioni
with open('translations.json') as trans_file:
    translations = json.load(trans_file)

@app.route('/')
def index():
    containers = client.containers.list(all=True)
    container_list = [{'id': c.id, 'name': c.name, 'status': c.status} for c in containers]
    return jsonify({
        'containers': container_list,
        'translations': translations[selected_language]
    })

@app.route('/start/<container_id>', methods=['POST'])
def start_container(container_id):
    try:
        container = client.containers.get(container_id)
        container.start()
        return jsonify({"message": "Container avviato con successo"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/stop/<container_id>', methods=['POST'])
def stop_container(container_id):
    try:
        container = client.containers.get(container_id)
        container.stop()
        return jsonify({"message": "Container fermato con successo"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/create', methods=['POST'])
def create_container():
    try:
        data = request.json
        image = data.get('image')
        name = data.get('name')
        ports = data.get('ports', {})
        client.containers.run(image, name=name, ports=ports, detach=True)
        return jsonify({"message": "Container creato con successo"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=panel_port)
