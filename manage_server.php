<?php
include('config.php');
requireAuth();

$server_name = $_GET['server'];
$servers = json_decode(file_get_contents('servers.json'), true);

$server = null;
foreach ($servers as $s) {
    if ($s['server_name'] === $server_name) {
        $server = $s;
        break;
    }
}

if (!$server) {
    die("Server non trovato.");
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestisci Server</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="admin-container">
        <h1>Gestisci Server: <?php echo $server_name; ?></h1>
        <p>Porta: <?php echo $server['server_port']; ?></p>
        <p>Versione del gioco: <?php echo $server['game_version']; ?></p>
        <p>Seed: <?php echo $server['server_seed']; ?></p>
        <p>Stato: <?php echo $server['status']; ?></p>
        <a href="server_files.php?server=<?php echo $server_name; ?>">Gestisci file del server</a>
    </div>
</body>
</html>
