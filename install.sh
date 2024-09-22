#!/bin/bash
echo "=========================================================="
echo "  Pannello di Gestione Hosting - Installazione"
echo "=========================================================="

# Funzione per disinstallare il pannello
uninstall_panel() {
    echo "Disinstallazione del pannello in corso..."
    if [ -d "UbuntuPanel" ]; then
        rm -rf UbuntuPanel
        echo "Pannello disinstallato."
    else
        echo "Pannello non trovato."
    fi
    if [ -d "venv" ]; then
        rm -rf venv
        echo "Ambiente virtuale rimosso."
    fi
}

# Funzione per installare un pacchetto
install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installazione di $1..."
        sudo apt install -y "$1"
    else
        echo "$1 già installato."
    fi
}

# Chiedi se si desidera disinstallare
read -p "Vuoi disinstallare il pannello? (s/n): " uninstall_choice
if [[ "$uninstall_choice" == "s" || "$uninstall_choice" == "S" ]]; then
    uninstall_panel
    exit 0
fi

# Rimuovi le cartelle esistenti prima di installare
if [ -d "UbuntuPanel" ] || [ -d "venv" ]; then
    echo "Cartelle esistenti trovate. Rimuovere le cartelle 'UbuntuPanel' e 'venv'."
    uninstall_panel
fi

echo "Controllo delle dipendenze..."
install_package python3-pip
install_package python3-venv
install_package docker.io
install_package npm
install_package git
install_package ufw

# Clona il repository se non esiste
if [ ! -d "UbuntuPanel" ]; then
    echo "Clonazione del repository..."
    git clone https://github.com/Leo2Galli/UbuntuPanel
else
    echo "Repository già presente. Aggiornamento..."
    cd UbuntuPanel
    git pull
    cd ..
fi

echo "Creazione di un ambiente virtuale..."
python3 -m venv UbuntuPanel/venv
source UbuntuPanel/venv/bin/activate

echo "Installazione delle dipendenze Python..."
if [ -f "UbuntuPanel/requirements.txt" ]; then
    pip install -r UbuntuPanel/requirements.txt
else
    echo "File requirements.txt non trovato."
fi

cd UbuntuPanel
if [ -f "package.json" ]; then
    echo "Installazione delle dipendenze Node.js..."
    npm install
else
    echo "File package.json non trovato. Saltata l'installazione delle dipendenze Node.js."
fi

read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " port_choice
port=${port_choice:-5000}

# Salva la porta in un file di configurazione
echo "PANEL_PORT=$port" > .env

# Modifica app.py per utilizzare la porta selezionata
sed -i "s/port = 5000/port = $port/g" app.py

# Configurazione UFW
if sudo ufw status | grep -q "$port"; then
    echo "La porta $port è già attivata. Disattivandola e riattivandola..."
    sudo ufw deny $port
    sleep 1
    sudo ufw allow $port
else
    echo "Apertura della porta $port nel firewall..."
    sudo ufw allow $port
fi

echo "Installazione completata!"
echo "Avviare il pannello con il comando:"
echo "cd UbuntuPanel && source venv/bin/activate && python app.py"
