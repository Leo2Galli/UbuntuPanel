#!/bin/bash

# Funzione per chiedere se disinstallare il pannello
disinstalla_pannello() {
    read -p "Vuoi disinstallare il pannello di gestione? (s/n): " scelta
    if [ "$scelta" == "s" ]; then
        echo "Disinstallazione in corso..."
        rm -rf UbuntuPanel venv
        echo "Pannello disinstallato con successo."
        exit 0
    fi
}

# Funzione per installare un pacchetto se non è già presente
install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installazione di $1..."
        sudo apt install -y "$1"
    else
        echo "$1 è già installato."
    fi
}

# Funzione per aggiornare il repository GitHub
aggiorna_repository() {
    if [ ! -d "UbuntuPanel" ]; then
        echo "Clonazione del repository..."
        git clone https://github.com/Leo2Galli/UbuntuPanel
    else
        echo "Repository già presente. Aggiornamento..."
        cd UbuntuPanel
        git fetch origin
        git reset --hard origin/main
        cd ..
    fi
}

# Funzione per aggiornare solo i file HTML, CSS e JS
aggiorna_html_css_js() {
    echo "Aggiornamento dei file HTML, CSS, JS..."
    cp -r UbuntuPanel/*.html .
    cp -r UbuntuPanel/*.css .
    cp -r UbuntuPanel/*.js .
    echo "Aggiornamento completato."
}

# Funzione per creare e attivare l'ambiente virtuale Python
crea_venv() {
    echo "Creazione di un ambiente virtuale..."
    python3 -m venv venv
    source venv/bin/activate
}

# Funzione per installare le dipendenze Python
installa_dipendenze_python() {
    echo "Installazione delle dipendenze Python..."
    pip install -r UbuntuPanel/requirements.txt
}

# Funzione per installare le dipendenze Node.js
installa_dipendenze_node() {
    echo "Installazione delle dipendenze Node.js..."
    if [ -f "UbuntuPanel/package.json" ]; then
        npm install
    else
        echo "File package.json non trovato. Saltata l'installazione delle dipendenze Node.js."
    fi
}

# Chiedi se disinstallare il pannello
disinstalla_pannello

# Chiedi se installare il pannello
read -p "Vuoi installare il pannello di gestione? (s/n): " scelta
if [ "$scelta" != "s" ]; then
    echo "Installazione annullata."
    exit 0
fi

# Controllo delle dipendenze
echo "Controllo delle dipendenze..."
install_package python3-pip
install_package python3-venv
install_package docker.io
install_package npm
install_package git

# Aggiorna il repository GitHub e i file HTML, CSS, JS
aggiorna_repository
aggiorna_html_css_js

# Crea e attiva l'ambiente virtuale
crea_venv

# Installa le dipendenze Python
installa_dipendenze_python

# Installa le dipendenze Node.js
installa_dipendenze_node

# Configura UFW per l'accesso esterno
read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " port_choice
port=${port_choice:-5000}

read -p "Vuoi configurare UFW per l'accesso esterno? (s/n): " ufw_choice
if [ "$ufw_choice" == "s" ]; then
    echo "Apertura della porta $port..."
    sudo ufw allow $port
fi

# Messaggio di fine installazione
echo "Installazione completata!"
echo "Avvia il pannello con il comando:"
echo "source venv/bin/activate && python app.py"
