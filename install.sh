#!/bin/bash

# Funzione per installare le dipendenze
install_dependencies() {
    echo "Creazione di un ambiente virtuale..."
    python3 -m venv venv
    echo "Installazione delle dipendenze Python..."
    source venv/bin/activate
    pip install flask flask_sqlalchemy flask_login
    deactivate
    echo "Installazione delle dipendenze completata."
}

# Funzione per configurare il pannello
configure_panel() {
    echo "Configurazione del pannello..."
    
    # Richiesta del nome del pannello
    read -p "Inserisci il nome del pannello: " PANEL_NAME
    
    # Richiesta dell'IP e della porta
    read -p "Inserisci la porta su cui eseguire il pannello (default 5000): " PORT
    PORT=${PORT:-5000}
    
    # Creazione del file di configurazione
    echo "PORT = $PORT" > config.py
    echo "PANEL_NAME = '$PANEL_NAME'" >> config.py

    echo "Configurazione completata."
}

# Funzione per avviare il pannello
start_panel() {
    echo "Avvio del pannello..."
    source venv/bin/activate
    python app.py
}

# Funzione per disinstallare il pannello
uninstall_panel() {
    echo "Disinstallazione del pannello..."
    rm -rf UbuntuPanel
    echo "Pannello disinstallato con successo."
}

# Funzione principale
main() {
    # Controlla se il pannello è già installato
    if [ -d "UbuntuPanel" ]; then
        echo "Il pannello è già installato. Vuoi disinstallarlo? (s/n)"
        read DISINSTALL
        if [ "$DISINSTALL" == "s" ]; then
            uninstall_panel
            exit 0
        else
            echo "Continuando con l'installazione."
        fi
    fi
    
    # Crea la cartella principale del pannello
    mkdir UbuntuPanel
    cd UbuntuPanel || exit

    # Scarica il repository da GitHub (sostituisci con il tuo URL)
    echo "Clonazione del repository..."
    git clone <YOUR_GITHUB_REPO_URL> .

    # Installa le dipendenze
    install_dependencies

    # Configura il pannello
    configure_panel

    # Abilita il firewall per la porta
    echo "Attivazione del firewall per la porta $PORT..."
    ufw allow $PORT

    # Avvia il pannello
    start_panel
}

# Avvio dello script
main
