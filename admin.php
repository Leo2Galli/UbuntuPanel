<?php
include('config.php');
requireAuth();

$servers = json_decode(file_get_contents('servers.json'), true);
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pannello Amministratore</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="admin-container">
        <h1>Gestione Server</h1>
        <a href="create_server.php">Crea un nuovo server</a>
        <h2>Server Attuali</h2>
        <table>
            <tr>
                <th>Nome Server</th>
                <th>Porta</th>
                <th>Stato</th>
                <th>Azioni</th>
            </tr>
            <?php foreach ($servers as $server): ?>
            <tr>
                <td><?php echo $server['server_name']; ?></td>
                <td><?php echo $server['server_port']; ?></td>
                <td><?php echo $server['status']; ?></td>
                <td>
                    <a href="manage_server.php?server=<?php echo $server['server_name']; ?>">Gestisci</a>
                </td>
            </tr>
            <?php endforeach; ?>
        </table>
    </div>
</body>
</html>
