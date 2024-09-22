#!/bin/bash

# Funzione per l'installazione dei pacchetti
install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installazione di $1..."
        sudo apt install -y "$1"
    else
        echo "$1 già installato."
    fi
}

# Funzione per la disinstallazione del pannello
disinstall_panel() {
    echo "Sto rimuovendo il pannello..."
    if [ -d "UbuntuPanel" ]; then
        sudo rm -rf UbuntuPanel
        echo "Pannello rimosso con successo."
    else
        echo "Il pannello non è installato."
    fi
    exit 0
}

# Chiedi se l'utente vuole disinstallare
read -p "Vuoi disinstallare il pannello (s/n)? " disinstall_choice
if [ "$disinstall_choice" == "s" ]; then
    disinstall_panel
fi

# Chiedi se vuoi installare
read -p "Vuoi installare il pannello (s/n)? " install_choice
if [ "$install_choice" == "n" ]; then
    echo "Installazione annullata."
    exit 0
fi

# Inizio dell'installazione
echo "=========================================================="
echo "  Pannello di Gestione Hosting - Installazione"
echo "  Versione: 1.0.2"
echo "  Autore: Leo (https://github.com/Leo2Galli)"
echo "  Data: 2024"
echo "  Descrizione: Script di installazione per configurare"
echo "  il pannello di gestione hosting con Docker e supporto"
echo "  multi-lingua."
echo "=========================================================="

# Funzione per aggiornare il repository GitHub
aggiorna_repository() {
    if [ ! -d "UbuntuPanel" ]; then
        echo "Clonazione del repository..."
        git clone https://github.com/Leo2Galli/UbuntuPanel
    else
        echo "Repository già presente. Aggiornamento..."
        cd UbuntuPanel
        git pull
        cd ..
    fi
}

# Controllo delle dipendenze e aggiornamento dei file
echo "Controllo delle dipendenze..."
install_package python3-pip
install_package python3-venv
install_package docker.io
install_package npm
install_package git

aggiorna_repository

# Creazione di un ambiente virtuale
if [ ! -d "UbuntuPanel/venv" ]; then
    echo "Creazione di un ambiente virtuale..."
    python3 -m venv UbuntuPanel/venv
fi
source UbuntuPanel/venv/bin/activate

# Installazione delle dipendenze Python
echo "Installazione delle dipendenze Python..."
pip install --upgrade pip
pip install -r UbuntuPanel/requirements.txt --break-system-packages

# Installazione delle dipendenze Node.js
cd UbuntuPanel
if [ ! -d "node_modules" ]; then
    echo "Installazione delle dipendenze Node.js..."
    npm install
fi

# Configurazione della porta
read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " port_choice
port=${port_choice:-5000}

# Configurazione UFW (Firewall)
read -p "Vuoi configurare UFW per l'accesso esterno (s/n)? " ufw_choice
if [ "$ufw_choice" == "s" ]; then
    echo "Apertura della porta $port..."
    sudo ufw allow $port
fi

echo "Installazione completata!"
echo "Puoi avviare il pannello con il comando:"
echo "cd UbuntuPanel && source venv/bin/activate && python app.py"

exit 0
