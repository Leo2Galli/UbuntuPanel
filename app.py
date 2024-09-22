from flask import Flask, render_template, request, redirect, jsonify
import docker

app = Flask(__name__)
client = docker.from_env()

@app.route('/')
def index():
    containers = client.containers.list(all=True)
    return render_template('index.html', containers=containers)

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
        image = request.json.get('image')
        name = request.json.get('name')
        ports = request.json.get('ports', {})
        client.containers.run(image, name=name, ports=ports, detach=True)
        return jsonify({"message": "Container creato con successo"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
