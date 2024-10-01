<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header('Location: index.php');
    exit;
}

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
        <h1>Benvenuto, Amministratore</h1>
        <a href="create_server.php">Crea nuovo server</a>
        <h2>Gestione dei server</h2>
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
                    <a href="server.php?name=<?php echo $server['server_name']; ?>">Gestisci</a>
                </td>
            </tr>
            <?php endforeach; ?>
        </table>
    </div>
</body>
</html>
