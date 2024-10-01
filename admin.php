<?php
session_start();
include 'config.php';

if (!isset($_SESSION['logged_in'])) {
    header('Location: login.php');
    exit;
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <title>Dashboard Amministratore</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Benvenuto, Admin</h1>
    <p><a href="create_server.php">Crea un nuovo server</a></p>
    <p><a href="manage_users.php">Gestione utenti</a></p>
    <p><a href="view_files.php">Gestione file</a></p>
    <p><a href="wiki.php">Wiki</a></p>
    <p><a href="logout.php">Logout</a></p>
</body>
</html>
