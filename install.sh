#!/bin/bash
echo "=========================================================="
echo "  Pannello di Gestione Hosting - Installazione"
echo "  Versione: 1.0.0"
echo "  Autore: Leo (https://github.com/Leo2Galli)"
echo "  Data: 2024"
echo "  Descrizione: Script di installazione per configurare"
echo "  il pannello di gestione hosting con Docker e supporto"
echo "  multi-lingua."
echo "=========================================================="

echo "Benvenuto nel setup del Pannello di Gestione Hosting!"
echo "Scegli la lingua / Choose your language:"
echo "1) Italiano"
echo "2) English"
echo "3) Español"
echo "4) Deutsch"
echo "5) 中文"

read -p "Seleziona un numero / Select a number: " lang_choice

case $lang_choice in
    1)
        lang="it"
        ;;
    2)
        lang="en"
        ;;
    3)
        lang="es"
        ;;
    4)
        lang="de"
        ;;
    5)
        lang="zh"
        ;;
    *)
        echo "Lingua non valida, impostazione di default: English"
        lang="en"
        ;;
esac

# Richiedi la porta su cui eseguire il pannello
read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " port_choice
port=${port_choice:-5000}

# Salva la configurazione in un file config.json
echo "{ \"language\": \"$lang\", \"port\": $port }" > config.json

# Aggiorna i pacchetti e installa Docker
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io -y

# Installazione di Python e dipendenze Flask
sudo apt install python3-pip -y
pip3 install -r requirements.txt

# Installazione delle dipendenze React per il frontend
npm install
npm run build

# Avviare il backend
python3 app.py
