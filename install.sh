#!/bin/bash
echo "=========================================================="
echo "  Pannello di Gestione Hosting - Installazione"
echo "  Versione: 1.0.4"
echo "  Autore: Leo (https://github.com/Leo2Galli)"
echo "  Data: 2024"
echo "  Descrizione: Script di installazione per configurare"
echo "  il pannello di gestione hosting con Docker e supporto"
echo "  multi-lingua."
echo "=========================================================="

# Funzione per installare pacchetti
install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installazione di $1..."
        sudo apt install -y "$1"
    else
        echo "$1 già installato."
    fi
}

# Chiedere se si vuole disinstallare il pannello
read -p "Vuoi disinstallare il pannello? (s/n): " uninstall_choice
if [ "$uninstall_choice" == "s" ]; then
    if [ -d "UbuntuPanel" ]; then
        rm -rf UbuntuPanel
        echo "Pannello disinstallato."
    else
        echo "Il pannello non è installato."
    fi
    exit 0
fi

# Chiedere se si vuole installare il pannello
read -p "Vuoi installare il pannello? (s/n): " install_choice
if [ "$install_choice" != "s" ]; then
    echo "Installazione annullata."
    exit 0
fi

# Scelta della lingua
echo "Scegli la lingua per il pannello:"
echo "1) Italiano"
echo "2) English"
echo "3) Español"
echo "4) Deutsch"
echo "5) 中文"

read -p "Seleziona un numero: " lang_choice
case $lang_choice in
    1) lang="it";;
    2) lang="en";;
    3) lang="es";;
    4) lang="de";;
    5) lang="zh";;
    *) echo "Lingua non valida, impostazione di default: English"; lang="en";;
esac

echo "Lingua impostata a: $lang"

# Controllo delle dipendenze
echo "Controllo delle dipendenze..."
install_package python3-pip
install_package python3-venv
install_package docker.io
install_package npm
install_package git

# Clonazione del repository
if [ ! -d "UbuntuPanel" ]; then
    echo "Clonazione del repository..."
    git clone https://github.com/Leo2Galli/UbuntuPanel
else
    echo "Repository già presente. Aggiornamento..."
    cd UbuntuPanel
    git pull
    cd ..
fi

# Creazione dell'ambiente virtuale
echo "Creazione di un ambiente virtuale..."
python3 -m venv UbuntuPanel/venv
source UbuntuPanel/venv/bin/activate

# Installazione delle dipendenze Python
echo "Installazione delle dipendenze Python..."
pip install --upgrade pip
if ! pip install -r UbuntuPanel/requirements.txt; then
    echo "Errore durante l'installazione delle dipendenze Python. Verifica il file requirements.txt."
    exit 1
fi

cd UbuntuPanel

# Installazione delle dipendenze Node.js
if [ -f "package.json" ]; then
    if [ ! -d "node_modules" ]; then
        echo "Installazione delle dipendenze Node.js..."
        if ! npm install; then
            echo "Errore durante l'installazione delle dipendenze Node.js. Verifica il file package.json."
            exit 1
        fi
    fi
else
    echo "File package.json non trovato. Assicurati che esista."
    exit 1
fi

# Richiesta della porta
read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " port_choice
port=${port_choice:-5000}

# Configurazione di UFW
read -p "Vuoi configurare UFW per l'accesso esterno? (s/n): " ufw_choice
if [ "$ufw_choice" == "s" ]; then
    echo "Apertura della porta $port..."
    sudo ufw allow $port
fi

echo "Installazione completata!"
echo "Avviare il pannello con il comando:"
echo "cd UbuntuPanel && source venv/bin/activate && python app.py"
