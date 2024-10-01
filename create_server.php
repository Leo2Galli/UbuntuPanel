<?php
if (isset($_POST['create'])) {
    $server_name = $_POST['server_name'];
    $server_port = $_POST['server_port'];
    $game_version = $_POST['game_version'];

    $servers = json_decode(file_get_contents('servers.json'), true);
    $servers[] = [
        'server_name' => $server_name,
        'server_port' => $server_port,
        'game_version' => $game_version,
        'status' => 'stopped'
    ];
    file_put_contents('servers.json', json_encode($servers, JSON_PRETTY_PRINT));

    header('Location: admin.php');
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crea Server</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="create-server-container">
        <h1>Crea Nuovo Server</h1>
        <form method="POST">
            <input type="text" name="server_name" placeholder="Nome del server" required>
            <input type="number" name="server_port" placeholder="Porta del server" required>
            <input type="text" name="game_version" placeholder="Versione del gioco" required>
            <button type="submit" name="create">Crea Server</button>
        </form>
    </div>
</body>
</html>
