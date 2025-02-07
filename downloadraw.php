<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $base64Data = $_POST['base64Data'] ?? '';
    $fileName = $_POST['fileName'] ?? 'download.css';  // デフォルトを .css に設定

    if (empty($base64Data)) {
        die('No data provided.');
    }

    // 適切なContent-Typeを設定
    header('Content-Type: text/css');
    header('Content-Disposition: attachment; filename="' . $fileName . '"');
    header('Content-Length: ' . strlen($base64Data));
    
    echo $base64Data;  // Base64データそのまま出力
    exit;
}
