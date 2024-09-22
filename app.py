from flask import Flask, render_template
import os
import socket

app = Flask(__name__)

@app.route('/')
def home():
    ip_address = socket.gethostbyname(socket.gethostname())
    return render_template('index.html', ip_address=ip_address)

if __name__ == "__main__":
    # Leggi la porta da una variabile d'ambiente
    port = int(os.environ.get('PANEL_PORT', 5000))
    app.run(host='0.0.0.0', port=port)
