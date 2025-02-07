
//< !--https://gemini.google.com/app/8dfeab901fa6f9a8 -->
const copyButton = document.getElementById('copyButton');

copyButton.addEventListener('click', () => {
  navigator.clipboard.writeText(result)
    .then(() => {
      alert('コピーしました！');
    })
    .catch(err => {
      console.error('コピーに失敗しました: ', err);
    });
});


const imageInput = document.getElementById('imageInput');

var meta = `/* ==UserStyle==
@name           custom_css
@namespace      example.com
@version        0.1.0
@description    Background image with Base64 JPEG by sokudon.s17.xrea.com/base64.html
@author         Your Name
==/UserStyle== */
`;



const css_head_gemini = `@-moz-document domain("gemini.google.com") {
:where(.theme-host) {
    /* デフォの白背景削除 */
    --gem-sys-color--surface: transparent, !important;
}

body {
    /*上のバナー 明るい色*/
    background-color: rgba(255, 255, 255, 0.562);
}
.main-content {
    /*子を透過する */
    background-color: rgba(255, 255, 255, 0.562);
}
.chat-app {
    /*opacity: 0.3;  全体を透過 */
    /*backdrop-filter: blur(5px); */
    /* 背景をぼかす (adjust the value as needed) */
    background-color: transparent, !important;
    background-size: auto;
    background: url(`;


const css_head_claude = `@-moz-document url-prefix("https://claude.ai/chat") {
.flex-row-reverse {
    /*アイコン */
    background-color: #17f0cf26 !important
}
.bg-bg-200 {
    /*サイドメニュー */
    background-color: #2e50d826 !important
}
.flex_col {
    /*アイコン右上 */
    background-color: #12e11321 !important
}

flex-1 {
    /*アイコン右上 */
    background-color: #c0b71726 !important
}

[data-theme=claude],
[data-theme=claude][data-mode=light] {

    --bg-000: #60dcd5d6;
    --bg-100: #5bf0eede;
    --bg-200: #5b94f0f2;
    --bg-300: #62286042;
    --bg-400: #62286242;
    --bg-500: #62285842;
}
.font-user-message {

    background-color: #e1bf5be8;
}
.font-claude-message {
    background-color: #f0a15be6;
}
.code-block__code {
    opacity: 0.7;
}

.overflow-hidden {
    /*   .tracking-tight   w-full
    opacity: 0.7;*/
    background-size: auto;
    background: url(`;

const foot = ");}}";
var result = "";
const resultDiv = document.getElementById('result');

imageInput.addEventListener('change', (event) => {
  const file = event.target.files[0];

  meta = meta.replace("0.1.0", getCurrentDateTime());
  if (file) {
    const reader = new FileReader();

    reader.onload = (e) => {
      const base64String = e.target.result;
      const imageType = file.type; // "image/png" or "image/jpeg"

      // Base64 文字列を表示
      result = `${base64String}`;
      if (document.getElementById("add_gemini_css").checked) {
        result = meta + css_head_gemini + result + foot;
      }
      if (document.getElementById("add_claude_css").checked) {
        result = meta + css_head_claude + result + foot;
      }

      resultDiv.innerHTML = `<p>Base64 文字列:</p><textarea id="target" rows="5" cols="50">` + result + `</textarea>`;

      // 必要であれば、Base64 文字列をコンソールに出力
      console.log("Base64 文字列:", base64String);

      // イメージを表示する場合
      const img = document.createElement('img');
      img.src = base64String;
      resultDiv.appendChild(img);
    };

    reader.readAsDataURL(file); // Data URL 形式で読み込む
  }
});

var share_url = {
  "bsk": "https://bsky.app/intent/compose?text=TXT",
  "tw": "http://twitter.com/share?text=TXT"
}


//Twitterボタン
function toshare(sns) {
  var urls = "";
  var urlmaster = url();
  var base_url = share_url[sns];
  var tag = "\r\n#base64　#gemini #claude #stylus #user.css #custom_color";

  if (sns == "tw") {
    base_url = base_url.replace("hoge", urlmaster);
    base_url = base_url.replace("TAG", tag.replace(/[\r\n#]/gm, ""));
  }


  s = "https://ss1.xrea.com/sokudon.s17.xrea.com/base64.html chrome/firefoxのstylusで背景色画像を変更したよ() "
  s = s.replace(/<br>/gm, "\r\n");
  s = s.replace(/<.*?>/gm, "");
  s = s.replace(/\r\n\r\n/gm, "\r\n");
  if (sns == "bsk") {
    urlmaster = "";
    s += tag;
  }
  s = s + "\r\n " + urlmaster;
  s = encodeURIComponent(s);
  s += tag;
  if (urlmaster == "") {
    urls = base_url.replace("TXT", s);
  }
  else {
    urls = base_url.replace("TXT", s);
  }
  window.open(urls, "_blank", "width=600,height=300");
}

function makeplugin() {
  const base64Data = result; // Base64データ
  downloadBase64(base64Data, 'custom.user.css');
}

function makeplugintab() {
  const base64Data = result; // Base64データ
  installStylus(base64Data);
}

function getBrowser() {
  const userAgent = navigator.userAgent;
  if (userAgent.includes('Firefox')) {
    return 'Firefox';
  } else if (userAgent.includes('Chrome') && !userAgent.includes('Edg')) {
    return 'Chrome';
  }
  else if (userAgent.includes('Edg')) {
    return 'Edg';
  } else {
    return 'Other';
  }
}

function installStylus(cssContent) {
  const blob = new Blob([cssContent], { type: 'text/css' });
  const updateUrl = URL.createObjectURL(blob);
  const stylusInstallUrl_chrome =
    `chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/install-usercss.html?updateUrl=${encodeURIComponent(updateUrl)}`;
  const browser = getBrowser();
  console.log('Your browser is:', browser);

  if (browser === 'Firefox') {
    uploadCssAndInstall(cssContent);


  } else if (browser === 'Chrome' || browser === 'Edg') {
    window.open(stylusInstallUrl_chrome, '_blank');
  } else {
    alert('This is not a supported browser.');
  }
}

function uploadCssAndInstall(cssContent) {
  // FormDataオブジェクトの作成
  const formData = new FormData();
  formData.append('css_content', cssContent);

  // PHPファイルにPOSTリクエストを送信
  fetch('write_css.php', {
    method: 'POST',
    body: formData
  })
    .then(response => response.text())
    .then(result => {
      console.log(result);
    })
    .catch(error => {
      console.error('エラー:', error);
    });

  const updateUrl = 'https://ss1.xrea.com/sokudon.s17.xrea.com/temp/temp.user.css';
  const stylusInstallUrl =
    `moz-extension://ac62add4-a6db-4b47-92d1-786e2e8ad477/install-usercss.html?updateUrl=${encodeURIComponent(updateUrl)}`;
  setTimeout(() => {
  }, 500); // 100ミリ秒待機
  document.getElementById("link").innerHTML = '<a href="' + updateUrl + '">firefox用</a>';
}

function downloadBase64(base64Data, fileName) {
  const formData = new FormData();
  formData.append('base64Data', base64Data);
  formData.append('fileName', fileName);

  fetch('downloadraw.php', {
    method: 'POST',
    body: formData
  })
    .then(response => {
      if (response.ok) {
        return response.blob();
      } else {
        throw new Error('Failed to download the file.');
      }
    })
    .then(blob => {
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = fileName;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    })
    .catch(error => {
      console.error('Error:', error);
    });
}


function getCurrentDateTime() {
  const now = new Date();
  return now.getFullYear() +
    String(now.getMonth() + 1).padStart(2, '0') +
    String(now.getDate()).padStart(2, '0') +
    String(now.getHours()).padStart(2, '0') +
    String(now.getMinutes()).padStart(2, '0');
}