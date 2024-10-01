<?php
session_start();

define('ADMIN_USER', 'admin');
define('ADMIN_PASS', password_hash('password', PASSWORD_DEFAULT));

// Verifica l'autenticazione dell'amministratore
function isAdmin() {
    return isset($_SESSION['admin']) && $_SESSION['admin'] === true;
}

// Verifica se l'utente è loggato
function isAuthenticated() {
    return isAdmin();
}

function requireAuth() {
    if (!isAuthenticated()) {
        header('Location: login.php');
        exit;
    }
}
?>
