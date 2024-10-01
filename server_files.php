<?php
include('config.php');
requireAuth();

// Funzionalità di upload, download e modifica dei file

$server_name = $_GET['server'];
$path = "/path/to/$server_name/files";

?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione File</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="admin-container">
        <h1>Gestione File per <?php echo $server_name; ?></h1>
        <!-- Upload, eliminazione e modifica file -->
    </div>
</body>
</html>
