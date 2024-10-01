<?php
session_start();
include 'config.php';

if (!isset($_SESSION['logged_in'])) {
    header('Location: login.php');
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $new_user = $_POST['username'];
    $new_pass = $_POST['password'];
    file_put_contents('users.txt', "$new_user:$new_pass\n", FILE_APPEND);
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <title>Gestione Utenti</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Gestione Utenti</h1>
    <form method="POST" action="manage_users.php">
        <input type="text" name="username" placeholder="Nuovo Username" required>
        <input type="password" name="password" placeholder="Nuova Password" required>
        <button type="submit">Crea Utente</button>
    </form>
    <h2>Utenti esistenti</h2>
    <ul>
        <?php
        $users = file('users.txt', FILE_IGNORE_NEW_LINES);
        foreach ($users as $user) {
            echo "<li>$user</li>";
        }
        ?>
    </ul>
</body>
</html>
