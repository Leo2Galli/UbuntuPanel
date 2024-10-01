<?php
session_start();
if (!isset($_SESSION['logged_in'])) {
    header('Location: login.php');
    exit;
}

// Elenco dei file
$files = scandir(getcwd());

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $file = $_POST['file'];
    if (isset($_POST['delete'])) {
        unlink($file);
    } elseif (isset($_POST['upload'])) {
        move_uploaded_file($_FILES['uploaded_file']['tmp_name'], $_FILES['uploaded_file']['name']);
    }
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <title>Gestione File</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Gestione File</h1>
    <h2>File correnti:</h2>
    <ul>
        <?php foreach ($files as $file) {
            if ($file !== "." && $file !== "..") {
                echo "<li>$file - <form method='POST' style='display:inline'><button name='delete' value='$file'>Elimina</button></form></li>";
            }
        } ?>
    </ul>

    <h2>Carica un nuovo file:</h2>
    <form method="POST" enctype="multipart/form-data">
        <input type="file" name="uploaded_file" required>
        <button type="submit" name="upload">Carica</button>
    </form>
</body>
</html>
