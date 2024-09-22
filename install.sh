#!/bin/bash

PANEL_DIR="UbuntuPanel"
REPO_URL="https://github.com/Leo2Galli/UbuntuPanel"

echo "=========================================================="
echo "  Pannello di Gestione Hosting - Installazione/Update"
echo "  Versione: 1.0.2"
echo "  Autore: Leo (https://github.com/Leo2Galli)"
echo "  Data: 2024"
echo "  Descrizione: Script per installare, aggiornare e gestire"
echo "  il pannello di gestione hosting con Docker."
echo "=========================================================="

install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installazione di $1..."
        sudo apt install -y "$1"
    else
        echo "$1 già installato."
    fi
}

update_repository() {
    echo "Aggiornamento del repository..."
    cd $PANEL_DIR || exit 1
    git fetch origin
    git reset --hard origin/main
    echo "Repository aggiornato!"
    cd ..
}

install_requirements() {
    echo "Installazione delle dipendenze Python e Node.js..."

    if [ ! -d "$PANEL_DIR/venv" ]; then
        echo "Creazione dell'ambiente virtuale Python..."
        python3 -m venv "$PANEL_DIR/venv"
    fi

    source "$PANEL_DIR/venv/bin/activate"
    pip install --upgrade pip
    pip install -r "$PANEL_DIR/requirements.txt"

    if [ ! -d "$PANEL_DIR/node_modules" ]; then
        echo "Installazione dei pacchetti Node.js..."
        npm install --prefix $PANEL_DIR
    fi
}

backup_custom_files() {
    echo "Backup dei file personalizzati (nodi e server)..."
    mkdir -p backup

    # Copia dei file di configurazione personalizzati (nodi, server, ecc.)
    cp -r "$PANEL_DIR/nodes" backup/nodes
    cp -r "$PANEL_DIR/servers" backup/servers
    cp "$PANEL_DIR/settings.json" backup/settings.json
}

restore_custom_files() {
    echo "Ripristino dei file personalizzati..."
    cp -r backup/nodes "$PANEL_DIR/"
    cp -r backup/servers "$PANEL_DIR/"
    cp backup/settings.json "$PANEL_DIR/"
}

ask_for_disinstall() {
    read -p "Vuoi disinstallare il pannello? (s/n): " disinstall_choice
    if [[ "$disinstall_choice" == "s" ]]; then
        echo "Disinstallazione del pannello..."
        rm -rf $PANEL_DIR
        sudo ufw deny 5000
        echo "Pannello disinstallato!"
        exit 0
    fi
}

main_installation() {
    if [ -d "$PANEL_DIR" ]; then
        echo "Il pannello è già installato."
        ask_for_disinstall
        read -p "Vuoi aggiornare il pannello? (s/n): " update_choice
        if [[ "$update_choice" == "s" ]]; then
            backup_custom_files
            update_repository
            restore_custom_files
        fi
    else
        echo "Installazione del pannello in corso..."
        git clone $REPO_URL
    fi

    install_requirements

    read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " port_choice
    port=${port_choice:-5000}

    read -p "Vuoi configurare UFW per l'accesso esterno alla porta $port? (s/n): " ufw_choice
    if [[ "$ufw_choice" == "s" ]]; then
        echo "Apertura della porta $port..."
        sudo ufw allow $port
    fi

    echo "Installazione completata!"
    echo "Per avviare il pannello, esegui il seguente comando:"
    echo "cd UbuntuPanel && source venv/bin/activate && python app.py"
}

echo "Controllo delle dipendenze..."
install_package python3-pip
install_package python3-venv
install_package docker.io
install_package npm
install_package git

main_installation
