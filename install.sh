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

install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installazione di $1..."
        sudo apt install -y "$1"
    else
        echo "$1 già installato."
    fi
}

# Chiedi se disinstallare il pannello esistente
if [ -d "UbuntuPanel" ]; then
    read -p "Il pannello è già installato. Vuoi disinstallarlo? (s/n): " uninstall_choice
    if [ "$uninstall_choice" == "s" ]; then
        echo "Disinstallazione in corso..."
        rm -rf UbuntuPanel
        echo "Disinstallazione completata."
        exit 0
    fi
fi

# Controlla e installa le dipendenze
echo "Controllo delle dipendenze..."
install_package python3-pip
install_package python3-venv
install_package docker.io
install_package npm
install_package git

# Clona o aggiorna il repository
if [ ! -d "UbuntuPanel" ]; then
    echo "Clonazione del repository..."
    git clone https://github.com/Leo2Galli/UbuntuPanel
else
    echo "Repository già presente. Aggiornamento..."
    cd UbuntuPanel
    git pull
    cd ..
fi

# Creazione di un ambiente virtuale
echo "Creazione di un ambiente virtuale..."
python3 -m venv UbuntuPanel/venv
source UbuntuPanel/venv/bin/activate

# Installazione delle dipendenze Python
echo "Installazione delle dipendenze Python..."
pip install -r UbuntuPanel/requirements.txt

# Installazione delle dipendenze Node.js
cd UbuntuPanel
if [ ! -f "package.json" ]; then
    echo "File package.json non trovato. Saltata l'installazione delle dipendenze Node.js."
else
    echo "Installazione delle dipendenze Node.js..."
    npm install
fi

# Chiedi all'utente di inserire la porta
read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " port_choice
port=${port_choice:-5000}

# Configura UFW
echo "Configurazione di UFW..."
sudo ufw enable
if sudo ufw status | grep -q "$port"; then
    echo "La porta $port è già aperta."
else
    echo "Apertura della porta $port..."
    sudo ufw allow $port
fi

# Modifica il file app.py per usare la porta specificata
sed -i "s/port = int(os.getenv(\"PANEL_PORT\", 5000))/port = $port/g" UbuntuPanel/app.py

# Messaggio di completamento
echo "Installazione completata!"
echo "Avviare il pannello con il comando:"
echo "cd UbuntuPanel && source venv/bin/activate && python app.py"
