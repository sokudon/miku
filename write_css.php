<?php
// CSSの内容（JavaScriptから受け取ったと仮定）
$cssContent = $_POST['css_content']; // JavaScriptからPOSTされたCSS

// ディレクトリの存在確認
if (!file_exists('temp')) {
    mkdir('temp', 0777, true);
}

// ファイルパス
$filePath = 'temp/temp.user.css';

// ファイルに書き込み
if (file_put_contents($filePath, $cssContent) !== false) {
    echo "CSSファイルの書き込みに成功しました。";
} else {
    echo "エラー: ファイルの書き込みに失敗しました。";
}
?>