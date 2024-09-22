from flask import Flask, render_template, request
import subprocess

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
    app.run(debug=True, host='0.0.0.0')
