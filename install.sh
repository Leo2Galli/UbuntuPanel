#!/bin/bash

# Funzione per disinstallare il pannello
function uninstall_panel {
    read -p "Sei sicuro di voler disinstallare il pannello? (si/no): " confirm_uninstall
    if [[ "$confirm_uninstall" == "si" ]]; then
        echo "Rimozione del pannello..."
        rm -rf ~/Scrivania/UbuntuPanel
        sudo ufw delete allow 80/tcp
        sudo ufw delete allow 443/tcp
        echo "Disinstallazione completata!"
        exit 0
    else
        echo "Disinstallazione annullata."
    fi
}

# Verifica se esiste già la directory UbuntuPanel
if [ -d "~/Scrivania/UbuntuPanel" ]; then
    read -p "La directory UbuntuPanel esiste già. Vuoi rimuoverla prima di procedere? (si/no): " confirm
    if [[ "$confirm" == "si" ]]; then
        echo "Rimozione della cartella esistente..."
        rm -rf ~/Scrivania/UbuntuPanel
        echo "Cartella rimossa."
    else
        echo "Installazione annullata."
        exit 1
    fi
fi

# Installazione dipendenze
echo "Aggiornamento pacchetti..."
sudo apt update
echo "Installazione di Apache, PHP e UFW..."
sudo apt install -y apache2 php libapache2-mod-php php-mysql ufw git curl

# Abilitazione Apache e configurazione UFW
echo "Configurazione del firewall..."
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload
sudo systemctl enable apache2
sudo systemctl start apache2

# Creazione della directory
echo "Creazione della directory UbuntuPanel..."
mkdir -p ~/Scrivania/UbuntuPanel
cd ~/Scrivania/UbuntuPanel

# Configurazione file
echo "Configurazione pannello..."
read -p "Inserisci il nome utente dell'amministratore: " admin_user
read -s -p "Inserisci la password dell'amministratore: " admin_pass
echo ""

# Creazione file di configurazione
cat <<EOL > config.php
<?php
session_start();
define('ADMIN_USER', '$admin_user');
define('ADMIN_PASS', password_hash('$admin_pass', PASSWORD_DEFAULT'));
?>
EOL

echo "Installazione completata. Vai su localhost per accedere al pannello."
