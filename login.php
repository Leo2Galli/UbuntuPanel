<?php
session_start();
include 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user = $_POST['username'];
    $pass = $_POST['password'];
    $captcha = $_POST['captcha'];
    
    if ($_SESSION['captcha'] == $captcha && check_login($user, $pass)) {
        $_SESSION['logged_in'] = true;
        header('Location: admin.php');
        exit;
    } else {
        $error = "Login fallito o CAPTCHA errato!";
    }
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <title>Login Amministratore</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="login-box">
        <h2>Login</h2>
        <form method="POST" action="login.php">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <img src="captcha.php" alt="CAPTCHA">
            <input type="text" name="captcha" placeholder="Inserisci CAPTCHA" required>
            <button type="submit">Login</button>
        </form>
        <?php if (isset($error)) echo "<p>$error</p>"; ?>
    </div>
</body>
</html>
