#!/bin/bash

# Funzione per disinstallare il pannello
disinstalla_pannello() {
    read -p "Vuoi disinstallare il pannello di gestione? (s/n): " scelta
    if [ "$scelta" == "s" ]; then
        echo "Disinstallazione in corso..."
        rm -rf venv
        echo "Pannello disinstallato con successo."
        exit 0
    fi
}

# Funzione per installare pacchetti
install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installazione di $1..."
        sudo apt install -y "$1"
    else
        echo "$1 è già installato."
    fi
}

# Funzione per aggiornare i file senza toccare le configurazioni
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

crea_venv() {
    echo "Creazione di un ambiente virtuale..."
    python3 -m venv venv
}

installa_dipendenze_python() {
    echo "Installazione delle dipendenze Python..."
    source venv/bin/activate
    pip install -r requirements.txt
}

installa_dipendenze_node() {
    echo "Installazione delle dipendenze Node.js..."
    if [ -f "package.json" ]; then
        npm install
    else
        echo "File package.json non trovato. Saltata l'installazione delle dipendenze Node.js."
    fi
}

# Disinstalla pannello se richiesto
disinstalla_pannello

# Chiedi se installare il pannello
read -p "Vuoi installare il pannello di gestione? (s/n): " scelta
if [ "$scelta" != "s" ]; then
    echo "Installazione annullata."
    exit 0
fi

echo "Controllo delle dipendenze..."
install_package python3-pip
install_package python3-venv
install_package docker.io
install_package npm
install_package git

aggiorna_repository
crea_venv
installa_dipendenze_python
installa_dipendenze_node

# Chiedi porta per eseguire il pannello
read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " port_choice
port=${port_choice:-5000}

# Aggiornamento del file app.py per utilizzare la porta scelta
sed -i "s/5000/$port/g" app.py

# Istruzioni finali
echo "Installazione completata!"
echo "Avviare il pannello con il comando:"
echo "source venv/bin/activate && python app.py"
