from flask import Flask, render_template
import os

app = Flask(__name__)

# Carica la porta dalla variabile d'ambiente
port = int(os.getenv("PANEL_PORT", 5000))

@app.route('/')
def home():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)
