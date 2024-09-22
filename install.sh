#!/bin/bash

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
        echo "Lingua non valida, defaulting to English"
        lang="en"
        ;;
esac

# Salva la configurazione in un file config.json
echo "{ \"language\": \"$lang\" }" > config.json

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
