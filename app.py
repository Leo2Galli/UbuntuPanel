from flask import Flask, render_template, request
import subprocess
import os

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/console')
def console():
    return render_template('console.html')

@app.route('/execute-command', methods=['GET'])
def execute_command():
    command = request.args.get('command')
    try:
        output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
        return output.decode()
    except subprocess.CalledProcessError as e:
        return e.output.decode()

if __name__ == '__main__':
    # Ottieni la porta dal file di configurazione o usa la porta di default 5000
    port = int(os.getenv("PANEL_PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
