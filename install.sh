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

# Funzione per rimuovere il pannello
remove_panel() {
    echo "Rimuovendo il pannello di gestione..."
    sudo docker stop pannello || true
    sudo docker rm pannello || true
    sudo rm -rf /path/to/pannello-directory
    echo "Pannello rimosso con successo."
    exit 0
}

# Controllo se si desidera rimuovere il pannello
if [[ "$1" == "remove" ]]; then
    remove_panel
fi

echo "Benvenuto nel setup del Pannello di Gestione Hosting!"

# Impostazioni predefinite
lang="en"
port=5000

# Salva la configurazione in un file config.json
echo "{ \"language\": \"$lang\", \"port\": $port }" > config.json

# Aggiorna i pacchetti e installa Docker
echo "Aggiornamento dei pacchetti e installazione di Docker, Git, Python e Node.js..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io git python3-pip python3-venv nodejs npm

# Clona la repository
if [ ! -d "UbuntuPanel" ]; then
    echo "Clonazione della repository..."
    git clone https://github.com/Leo2Galli/UbuntuPanel.git
fi

# Naviga nella directory del progetto
cd UbuntuPanel || { echo "Errore nella navigazione nella directory del progetto."; exit 1; }

# Crea un ambiente virtuale per Python
echo "Creazione dell'ambiente virtuale Python..."
python3 -m venv venv
source venv/bin/activate

# Installazione delle dipendenze Python
echo "Installazione delle dipendenze Python..."
pip install --upgrade pip
pip install -r requirements.txt

# Verifica che npm sia installato
if ! command -v npm &> /dev/null; then
    echo "npm non è installato. Assicurati di aver installato Node.js correttamente."
    exit 1
fi

# Installazione delle dipendenze React per il frontend
echo "Installazione delle dipendenze frontend..."
npm install
npm run build

# Avviare il backend
echo "Avvio del backend..."
python app.py &

# Configurazione UFW
echo "Configurazione di UFW per l'accesso esterno..."
sudo ufw allow $port/tcp
sudo ufw enable
echo "UFW configurato. Porta $port aperta."

# Stampa l'indirizzo IP e la porta
IP=$(hostname -I | awk '{print $1}')
echo "Il pannello è accessibile all'indirizzo: http://$IP:$port"
