from flask import Flask, render_template, request
import os

app = Flask(__name__)

# Porta configurabile dall'utente durante l'installazione
port = int(os.getenv("PANEL_PORT", 5000))

# Route per la homepage
@app.route('/')
def home():
    return render_template('index.html')

# Route per la console
@app.route('/console')
def console():
    return render_template('console.html')

# Route per i grafici
@app.route('/graphs')
def graphs():
    return render_template('graphs.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=port, debug=True)
