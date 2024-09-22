from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/console')
def console():
    return render_template('console.html')

@app.route('/vps')
def vps():
    return render_template('vps.html')

@app.route('/file_manager')
def file_manager():
    return render_template('file_manager.html')

@app.route('/other_page')
def other_page():
    return render_template('other_page.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
