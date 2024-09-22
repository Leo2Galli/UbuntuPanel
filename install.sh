#!/bin/bash
echo "=========================================================="
echo "  Pannello di Gestione Hosting - Installazione"
echo "  Versione: 1.0.1"
echo "  Autore: Leo (https://github.com/Leo2Galli)"
echo "  Data: 2024"
echo "  Descrizione: Script di installazione per configurare"
echo "  il pannello di gestione hosting con Docker e supporto"
echo "  multi-lingua."
echo "=========================================================="

if [ -d "UbuntuPanel" ]; then
    read -p "Il pannello è già presente. Vuoi eliminarlo? (s/n): " remove_choice
    if [ "$remove_choice" == "s" ]; then
        echo "Eliminazione del pannello..."
        rm -rf UbuntuPanel
        echo "Pannello eliminato. Procedendo con una nuova installazione..."
    else
        echo "Procedendo con l'installazione esistente..."
        cd UbuntuPanel
        git pull
        cd ..
    fi
else
    echo "Clonazione del repository..."
    git clone https://github.com/Leo2Galli/UbuntuPanel
fi

install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installazione di $1..."
        sudo apt install -y "$1"
    else
        echo "$1 già installato."
    fi
}

echo "Controllo delle dipendenze..."
install_package python3-pip
install_package python3-venv
install_package docker.io
install_package npm
install_package git

echo "Creazione di un ambiente virtuale..."
python3 -m venv UbuntuPanel/venv
source UbuntuPanel/venv/bin/activate

# Controllo dell'esistenza di requirements.txt
if [ -f "UbuntuPanel/requirements.txt" ]; then
    echo "Installazione delle dipendenze Python..."
    pip install -r UbuntuPanel/requirements.txt
else
    echo "File requirements.txt non trovato. Assicurati che esista."
fi

cd UbuntuPanel
if [ -f "package.json" ]; then
    if [ ! -d "node_modules" ]; then
        echo "Installazione delle dipendenze Node.js..."
        npm install
    fi
else
    echo "File package.json non trovato. Assicurati che esista."
fi

read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " port_choice
port=${port_choice:-5000}

read -p "Vuoi configurare UFW per l'accesso esterno? (s/n): " ufw_choice
if [ "$ufw_choice" == "s" ]; then
    echo "Apertura della porta $port..."
    sudo ufw allow $port
fi

echo "Installazione completata!"
echo "Avviare il pannello con il comando:"
echo "cd UbuntuPanel && source venv/bin/activate && python app.py"
