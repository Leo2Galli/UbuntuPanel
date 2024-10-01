<?php
include('config.php');

if (isset($_POST['login'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];

    if ($username === ADMIN_USER && password_verify($password, ADMIN_PASS)) {
        $_SESSION['admin'] = true;
        header('Location: admin.php');
    } else {
        $error = "Credenziali errate.";
    }
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pannello di Controllo</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="login-container">
        <h1>Login al Pannello</h1>
        <form method="POST">
            <input type="text" name="username" placeholder="Nome utente" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit" name="login">Accedi</button>
            <?php if (isset($error)) echo "<p class='error'>$error</p>"; ?>
        </form>
    </div>
</body>
</html>
