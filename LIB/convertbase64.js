
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

const bookmarklet_head = "javascript:(function() {  var style = document.createElement('style');  style.textContent = `";
const bookmarklet_foot = "`;  document.head.appendChild(style);})();";

var tamper_chatgpt = `// ==UserScript==
// @name         chatgpt tampermonkey css
// @namespace    https://chatgpt.com/
// @version      {datenow}
// @description  try to take over the world!
// @author       You
// @match        *://*.chatgpt.com/*
// @icon         chatgpt
// @grant        GM_addStyle
// ==/UserScript==

GM_addStyle(`;
tamper_chatgpt += "`\r\n";  // ダブルクォートで囲む

var tamper_copilot = `// ==UserScript==
// @name         copilot tampermonkey css
// @namespace    https://copilot.microsoft.com/
// @version      {datenow}
// @description  try to take over the world!
// @author       You
// @match        *://*.copilot.microsoft.com/*
// @icon         copilot
// @grant        GM_addStyle
// ==/UserScript==

GM_addStyle(`;
tamper_copilot += "`\r\n";  // ダブルクォートで囲む

var tamper_perplex = `// ==UserScript==
// @name         perplex tampermonkey css
// @namespace    https://www.perplexity.ai/
// @version      {datenow}
// @description  try to take over the world!
// @author       You
// @match        *://*.www.perplexity.ai/*
// @icon         perplex
// @grant        GM_addStyle
// ==/UserScript==

GM_addStyle(`;
tamper_perplex += "`\r\n";  // ダブルクォートで囲む

var tamper_lmsys = `// ==UserScript==
// @name         lmsys tampermonkey css
// @namespace    https://lmarena.ai/
// @version      {datenow}
// @description  try to take over the world!
// @author       You
// @match        *://*.lmarena.ai/*
// @icon         copilot
// @grant        GM_addStyle
// ==/UserScript==

GM_addStyle(`;
tamper_lmsys += "`\r\n";  // ダブルクォートで囲む

var tamper_xcom = `// ==UserScript==
// @name         xcom tampermonkey css
// @namespace    https://x.com/
// @version      {datenow}
// @description  try to take over the world!
// @author       You
// @match        *://*.x.com/*
// @icon         copilot
// @grant        GM_addStyle
// ==/UserScript==

GM_addStyle(`;
tamper_xcom += "`\r\n";  // ダブルクォートで囲む

var tamper_gemini = `// ==UserScript==
// @name         gemini tampermonkey css
// @namespace    http://tampermonkey.net/
// @version      {datenow}
// @description  try to take over the world!
// @author       You
// @match        *://*.gemini.google.com/*
// @icon         gemini.google.com
// @grant        GM_addStyle
// ==/UserScript==

GM_addStyle(`;
tamper_gemini += "`\r\n";  // ダブルクォートで囲む

var tamper_claude = `// ==UserScript==
// @name         claude tampermonkey css
// @namespace    http://tampermonkey.net/
// @version      {datenow}
// @description  try to take over the world!
// @author       You
// @match        *://*.claude.ai/*
// @icon         claude.ai
// @grant        GM_addStyle
// ==/UserScript==

GM_addStyle(`;
tamper_claude += "`\r\n";  // ダブルクォートで囲む

var tamper_grok = `// ==UserScript==
// @name         grok tampermonkey css
// @namespace    http://tampermonkey.net/
// @version      {datenow}
// @description  try to take over the world!
// @author       You
// @match        *://*.grok.com/*
// @icon         grok.com
// @grant        GM_addStyle
// ==/UserScript==

GM_addStyle(`;
tamper_grok += "`\r\n";  // ダブルクォートで囲む

var tamper_custom = `// ==UserScript==
// @name         custom tampermonkey css
// @namespace    http://tampermonkey.net/
// @version      {datenow}
// @description  try to take over the world!
// @author       You
// @match        *://*.{input_your_url}*
// @icon         custom
// @grant        GM_addStyle
// ==/UserScript==

GM_addStyle(`;
tamper_custom += "`\r\n";  // ダブルクォートで囲む

var meta = `/* ==UserStyle==
@name           custom_css_{targetSite}_{datenow}
@namespace      example.com
@version        {datenow}
@description    Background image with Base64 JPEG by sokudon.s17.xrea.com/base64.html
@author         Your Name
==/UserStyle== */
`;

const css_head_chatgpt = `@-moz-document domain("chatgpt.com") {`;
const css_body_chatgpt = `main {
      /* 背景透過 */
      background: #ffffff7d;
  }

  :root {
      --white: #fff;
      --black: #000;
      --gray-50: #f9f9f9;
      --gray-100: #ececec;
      --gray-200: #e3e3e3;
      --gray-300: #cdcdcd;
      --gray-400: #b4b4b4;
      --gray-500: #9b9b9b;
      --gray-600: #676767;
      --gray-700: #424242;
      --gray-750: #2f2f2f;
      --gray-800: #212121;
      --gray-900: #171717;
      --gray-950: #0d0d0d;
      --red-500: #ef4444;
      --red-700: #b91c1c;
      --brand-purple: #ab68ff;
      --yellow-900: #927201;
      --header-height: 3rem;
      --backgroud-repeat: repeat x;
      /* typo: "backgroud" -> "background" に修正すべき */
      --selected-chat-gradient: linear-gradient(135deg, #b8e5ff0f, #d9d9d9, #d9d9d9 100%);
      --selected-gpt-gradient: linear-gradient(135deg, #7cffde08, #ebebeb 100%);
      --main-surface-secondary: #d0d0cf;
      --surface-primary: #fff;
      --bg-selection: #7ad28d;
      --text-color: #000;
      --text-gray-color: 100, 100, 100;
      --text-dark-color: 22, 22, 22;
      --text-color-selection: #191919;
      --surface-message-gpt: 210, 210, 210;
      --text-primary: var(--gray-950);
      --main-surface-tertiary: var(--gray-100);
  }

  body {
      color: rgb(var(--text-color));
      border-left: solid 3px #000 !important;
      background-image: var(--background);
      background-size: cover;
      /* 画面全体をカバー */
      background-position: center;
      /* top center; HDゑ用　スマフォはcenterでちょい隠れるのもあり*/
      /* 上部を優先表示 */
      background-repeat: no-repeat;
      min-height: 100vh;
  }

  .markdown .bg-gray-800 span,
  .markdown th {
      font-size: 16px;
  }

  .markdown h1,
  .markdown th {
      text-shadow: 0 2px 2px #000;
  }

  ::-moz-selection {
      background: var(--bg-selection);
      color: var(--text-color-selection);
  }

  /* Header */
  div.draggable.no-draggable-children {
      padding: 0 0.75rem;
      height: var(--header-height);
      background-color: rgba(var(--surface-primary), 0.5);
      backdrop-filter: blur(1rem);
  }

  div.draggable.no-draggable-children button.group {
      background-color: transparent !important;
  }

  .bg-token-main-surface-primary {
      background-color: rgba(var(--surface-primary), 0.3);
      backdrop-filter: blur(5px);
  }

  div.flex.flex-col.text-sm.pb-9 {
      background: linear-gradient(135deg, #b9efff1c, #000);
      border-left: solid 0px #10a37f !important;
  }

  #headlessui-portal-root .btn-danger,
  .markdown th,
  div > .hover\:bg-gray-500\/10 {
      background-color: #3f3f3f;
  }

  @media (min-width: 768px) {
      .md\:pb-\[8vh\] {
          position: relative;
          z-index: -5;
      }
  }

  h1 {
      filter: drop-shadow(0px 0px .25rem rgb(var(--surface-primary))) drop-shadow(0px 0px 5rem rgb(var(--surface-primary)));
  }

  .dark .dark\:text-gray-100,
  a {
      color: rgb(var(--text-dark-color));
  }

  button.group {
      background: var(--main-surface-secondary);
  }

  main button,
  main li.group {
      border-color: #1d1e1a !important;
  }

  main button:focus {
      border-color: #fd971f !important;
  }

  .input-container,
  .output-container {
      border: 1px solid #75715e;
      background-color: #272822
  }

  #headlessui-portal-root .grow.justify-center .text-gray-500,
  .user-input {
      color: #fd971f
  }

  #headlessui-portal-root .grow.justify-center svg.text-green-700,
  .assistant-output,
  textarea + button.text-gray-500 {
      color: #a6e22e
  }

  .timestamp {
      color: #75715e
  }

  .send-button {
      background-color: #f92672;
      color: #f8f8f2
  }

  .send-button:hover {
      background-color: #ffb86c
  }

  svg[viewBox="0 0 41 41"] {
      -webkit-filter: invert(100%);
      filter: invert(100%)
  }

  .relative.rounded-sm {
      -webkit-border-radius: 100%;
      -moz-border-radius: 100%;
      border-radius: 100%;
      background-color: #75ac9d !important
  }

  .bg-gray-900.md\:fixed,
  .dark .dark\:bg-gray-900,
  .scrollbar-trigger,
  .scrollbar-trigger a.bg-gray-900 {
      background-color: black
  }

  .markdown .bg-black {
      background-color: #0c0d09
  }

  .markdown .bg-gray-800 {
      background-color: #2c041d
  }

  .markdown ul li::before {
      content: "●";
      color: #fff;
      font-size: .875rem;
      line-height: 1.8rem
  }

  .markdown hr {
      border-color: #a66212
  }

  .markdown th {
      font-weight: 400
  }

  .markdown h1 {
      color: #fff !important;
      font-size: 1.8em !important
  }

  @media only screen and (max-width:768px) {
      .sticky.top-0 {
          background-color: #121310;
          border-color: #a66212
      }

      .sticky.top-0 h1 {
          color: #fff !important
      }

      .sticky.top-0 h1 + button {
          color: #a6e22e !important
      }

      #headlessui-portal-root .bg-gray-600 {
          background-color: rgba(var(--surface-primary), .9) !important
      }

      .dark .dark\:border-white\/20 {
          border-color: #262721
      }
  }

  @media only screen and (min-width:768px) {
      .md\:right-2 {
          right: 1.2rem
      }

      .dark .dark\:md\:bg-vert-dark-gradient {
          background-image: inherit
      }
  }

  @media only screen and (min-width:1200px) {
      .xl\:max-w-3xl {
          max-width: 90%
      }
  }

  @media only screen and (min-width:1400px) {
      .xl\:max-w-3xl {
          max-width: 90%
      }
  }

  @media only screen and (min-width:1500px) {
      .xl\:max-w-3xl {
          max-width: 90%
      }
  }

  @media only screen and (min-width:1800px) {
      .xl\:max-w-3xl {
          max-width: 90%
      }
  }

  .bg-gradient-to-l {
      background-image: linear-gradient(to left, #1e1e1e00 0, rgba(37, 38, 32, 0) 100%)
  }

  @media(min-width:768px) {
      .md\:max-w-3xl {
          max-width: 90%
      }
  }

  @media(min-width:1280px) {
      .gizmo .gizmo\:xl\:max-w-\[48rem\] {
          max-width: 90%
      }
  }

  div[data-testid^="conversation-turn-"]:nth-child(even) {
      font-size: 0.9rem !important;
      box-shadow: 0 0 5px #000000f0;
      border-left: 3px solid;
      border-image: linear-gradient(to right, #51515199 100%, #51515138 10%) 1 100%;
      margin-bottom: 2px;
  }

  /* All chats */
  .mx-auto.flex.flex-1.gap-4.text-base.md\:gap-5.lg\:gap-6.md\:max-w-3xl.lg\:max-w-\[40rem\].xl\:max-w-\[48rem\] {
      /*margin-left: 2rem;*/
  }

  /* USER */
  .w-full.text-token-text-primary:nth-child(even) {
      /*background: var(--selected-chat-gradient) !important;
  border-top: solid rgba(255, 255, 255, .2) 1px !important;
  box-shadow: 25px 0 20px -10px #51515138 inset;*/
  }

  .w-full.text-token-text-primary:nth-child(even) > div .bg-token-message-surface {
      background: rgba(255, 255, 255, 0.75);
      color: black;
      backdrop-filter: blur(2rem);
  }

  div[data-testid^="conversation-turn-"]:nth-child(odd) {
      font-size: 0.9rem !important;
      border-left: 3px solid;
      border-image: linear-gradient(to right, #10a37fa1 100%, #10a37f70 10%, ) 1 100%;
      margin-bottom: 2px
  }

  /* GPT */
  .w-full.text-token-text-primary:nth-child(odd) {
      /*background: var(--selected-gpt-gradient) !important;
  box-shadow: 25px 0 20px -20px #10a37f9e inset;*/
  }

  /* GPT - user icon container */
  .w-full.text-token-text-primary:nth-child(odd) > div > div > div:nth-child(1) {
      padding-top: 0.5rem;
  }

  /* GPT - user icon */
  .w-full.text-token-text-primary:nth-child(odd) > div > div > div:nth-child(1) > div {
      position: sticky;
      /* header height */
      top: calc(var(--header-height) + 1rem);
  }

  /* GPT - chat */
  .w-full.text-token-text-primary:nth-child(odd) > div > div > div:nth-child(2) {
      backdrop-filter: blur(2rem);
      background: rgba(var(--surface-message-gpt), 0.5);
      border-radius: 2rem;
      padding: 0.25rem 1rem;
  }

  /* */
  div.md\:pb-9 {
      padding-bottom: 1rem;
  }

  /* ASK - Bottom input bar */
  div[role="presentation"] > div:nth-child(2) {
      padding-bottom: .5rem;
  }

  .m-auto {
      font-size: 0.9rem !important;
      color: #cfc7c7 !important;
  }

  .text-base {
      font-size: 1.0rem !important;
      color: rgb(var(--text-gray-color)) !important;
      /*         color: #f7eaea !important; */
  }

  .break-words {
      font-size: 1.0rem !important;
      /*         color: #f7eaea !important; */
  }

  .prose pre {
      font-size: 0.775em !important;
      color: #bab3b3;
  }

  /* Delete dialog */
  div.absolute.inset-0 {
      & div.inset-0.fixed.dark\:bg-black\/80 {
          background-color: rgba(0, 0, 0, 0.5);

          div.popover.start-1\/2 {
              background-color: rgba(var(--surface-primary), 0.7);
          }
      }
  }

  /* ChatGPT can make mistakes. */
  .relative.w-full.px-2.py-2.text-center.text-xs.text-token-text-secondary.empty\:hidden.md\:px-\[60px\] {
      display: none;
  }

  .fflex-col.gap-2 {
      background: linear-gradient(to right, #0000001a, #000, #000, transparent);
  }

  .gizmo-shadow-stroke {
      color: #b0b0b0
  }
      :root {
      --background: url(`;

const css_head_copilot = `@-moz-document url-prefix("https://copilot.microsoft.com/") {`;
const css_body_copilot = `
/* body に背景画像を設定 */
body {
    background-size: cover !important;
    background-position: top center !important; /* center でやや上*/
    background-color: transparent !important;

    font-family: Ginto, ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", Segoe UI Symbol, "Noto Color Emoji";
    color: color: #50e7d87a !important;
}

/* main とその子要素の背景を半透明に */
main {
    background-color: rgba(255, 255, 255, 0.1) !important;
    /* 半透明白 */
}

/* 背景グラデーションや単色を半透明に */
.absolute.size-full,
.bg-gradient-chat-light,
.dark\:bg-midnight-850,
.dark\:bg-none {
    background: rgba(255, 255, 255, 0.1) !important;
    /* 半透明白 */
}

/* チャットメッセージの背景を半透明に */
.bg-spot-peach-300\/50,
/* ユーザーメッセージ */
.dark\:bg-midnight-750/* Copilot メッセージ */
{
    background-color: rgba(255, 192, 203, 0.3) !important;
    /* 半透明ピンク */
}

/* 入力エリアのコンテナを半透明に */
.relative.overflow-hidden.backdrop-blur-2xl {
    background-color: rgba(255, 255, 255, 0.2) !important;
    /* 半透明白 */
    backdrop-filter: blur(10px) !important;
    /* ブラー効果を維持 */
}

.relative.overflow-hidden.backdrop-blur-2xl::before,
.relative.overflow-hidden.backdrop-blur-2xl::after {
    background-color: rgba(255, 255, 255, 0.1) !important;
    /* 半透明に */
    opacity: 0.5 !important;
    /* 透過度調整 */
}

/* その他の背景要素を半透明に */
.bg-white\/90,
.dark\:bg-midnight-900\/80,
.bg-white\/70,
.dark\:bg-slate-450\/30,
.bg-transparent,
.shadow-composer-input {
    background-color: rgba(255, 255, 255, 0.2) !important;
    /* 半透明白 */
}

/* ボタンやアイコンの背景を半透明に */
button.bg-white\/70,
button.dark\:bg-slate-450\/30,
button.bg-transparent {
    background-color: rgba(255, 255, 255, 0.2) !important;
}

/* 入力テキストエリアを半透明に */
textarea#userInput {
    background-color: rgba(255, 255, 255, 0.1) !important;
}

/* テキストの視認性を向上 */
.text-foreground-800,
.text-black,
.dark\:text-white,
.font-ligatures-none {
    color: #ffffff !important;
    /* 白に変更 */
    /*text-shadow: 0 0 4px rgba(0, 0, 0, 0.5) !important;*/
    /* 影で視認性確保 */
}

/* 背景画像の透過度調整（視認性向上） */
body::before {
    content: "";
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, .74) !important;
    /* 背景を40%暗く */
    z-index: -1;
}

/*コード内*/
span {}
p {}
code {}

.dark\:bg-background-static-900:is([data-theme=dark] *),
.bg-background-static-850 {
    background-color: rgba(0, 0, 0, 0.4) !important;
}
    body {  
    background: url(`;

const css_head_lmsys = `@-moz-document url-prefix("https://lmarena.ai/") {`;
const css_body_lmsys = `
:root {

    --bg: #fff0;
    --col: #1f293700;
    --bg-dark: #0b0f1900;
    --col-dark: #f3f4f600;

    /* テキストボックス*/
    --border-color-primary: #ced2d505;

    --neutral-50: #f9fafb;
    --neutral-100: #f3f4f6;
    --neutral-200: #e5e7eb;
    --neutral-300: #d1d5db;
    
    /* text not selected*/
    --neutral-400: #00000078;
    
    --neutral-500: #6b7280;
    --neutral-600: #4b5563;
    --neutral-700: #374151;
    --neutral-800: #1f2937;
    --neutral-900: #111827;
    --neutral-950: #0b0f19;

    --background-fill-primary: #27df9966;
    --background-fill-secondary: #2e62d261;
}


element.style {
    --chatbot-body-text-size: 20px;
}
body {

    color: #00000000;
    background-color: #00000000;
}

.md,
.svelte-8tpqd2,
.chatbot,
.prose,
.message,
.message-row,
.bubble-wrap {

    background-color: #00000000;
}
.svelte-sa48pu,
.svelte-vt1mxs {

    background: #0000001a;
}

.wrap,
.default,
.contain,
.full {

    background: #eeebeb1a;
}


.svelte-au1olv,
.svelte-1sk0pyu,
.svelte-12cmxck {
    background: #0000;
}
.tabs {

    background: #0000;
}

.svelte-vt1mxs,
.gap {

    background: #67d48b00;
}

.svelte-sa48pu,
.stretch {


    background: #67d4c700;
}
.svelte-1oa6fve {

    background: #c3d467ab;
}

.main {
    background: #bb785f6e;
}

.gradio-container {
    background: url(`;

const css_head_perplex = `@-moz-document url-prefix("https://www.perplexity.ai/") {`;
const css_body_perplex = `    
      :root {
          --background-color-50: #00000000;
          --background-color-100: #00000000;
          --background-color-200: #00000000;
          --background-color-300: #00000000;
          --text-color-100: #3d10c4d9;
          --text-color-200: #8510c4d9;
      }
      body {
          color: #7ef9e4c7;
          background-size: cover !important;
          /* Optional: to make text darker */
      }
      
      
      /* 背景画像の透過度調整（視認性向上） */
      body::before {
          content: "";
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(0, 0, 0, .44) !important;
          /* 背景を40%暗く */
          z-index: -1;
      }
      body {
        background: url(`;

const css_head_xcom = `@-moz-document domain("x.com") {`;
const css_body_xcom = `
body {
    background-size: cover !important;
    background-position: center !important;
    background-repeat: no-repeat !important;
    background-attachment: fixed !important;
    background-color: transparent !important;
}
.r-kemksi,
.r-175oi2r,
.r-yfoy6g {
    background-color: rgba(0, 0, 0, 0.7) !important;
    /* コンテンツの背景を半透明に */
}
    body {
    /* https://pbs.twimg.com/media/GkgI9OtXAAI7t97?format=jpg&name=medium  grok 公式ブラックホール*/
    /* https://pbs.twimg.com/media/GkpcJ9CbkAQ0G5_?format=jpg&name=900x900  grok 公式白い方*/
    /* https://pbs.twimg.com/media/GlVJnvZa0AAjO3x?format=jpg&name=900x900 謎こ*/
    background-image: url(`;

const css_head_gemini = `@-moz-document domain("gemini.google.com") { `;
const css_body_gemini = `
:where(.theme-host) {
    /* デフォルトの白背景削除 */
    --gem-sys-color--surface: transparent !important;
    /* カンマ削除 */
}

body {
    /* 上のバナー 明るい色 */
    background-color: rgba(255, 255, 255, 0.562);
    /* 背景画像を指定（HTML のインライン画像を利用する前提） */
    /* background-image: url('data:image/jpeg;base64,...'); */
    /* 必要に応じて追加 */
    background-size: cover !important;
    background-position: center;
    /* 中央配置 */
    background-repeat: no-repeat;
    /* 繰り返しなし */
}

.main-content {
    /* 子を透過する */
    background-color: rgba(255, 255, 255, 0.562);
}

.chat-app {
    /* opacity: 0.3;  全体を透過（必要に応じてコメント解除） */
    /* backdrop-filter: blur(5px); 背景をぼかす（必要に応じてコメント解除） */
    background-color: transparent !important;
}

body {
    background: url(`;

const css_head_claude = `@-moz-document url-prefix("https://claude.ai/") {`;
const css_body_claude = `
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

    /* サイドメニューに適用する場合 */
    .bg-bg-200 {
        /* background: #2e50d826 url('your-image-url.jpg') no-repeat center !important;
    background-size: cover !important; */
    }

    .z-sidebar {
        /* background: #ffffff6e url('data:image/png;base64,[あなたのBase64文字列]') no-repeat center !important;
        background-size: cover !important;
        */
    }

    /*↓背景絵のアルファ*/
    .overflow-x-hidden {
        background: #ffffff91;
    }

    /* 全体の背景に適用する場合 */
    /* 背景絵 corsがきついのでブックマークレットで読み込みがbase64しかなさげ（）　*/
    .flex.min-h-screen.w-full {
        background-size: cover !important;
        background: url(`;

const css_head_grok = `@-moz-document url-prefix("https://grok.com/") {`;
const css_body_grok = `:root {
    /*情報そーすのオーバーレイ*/
    --background: #d390e9e8;
    --foreground: #d390e9cc;

    --scrollbar-thumb: rgba(0, 0, 0, .3);
    --scrollbar-track: transparent;

    --important: #fcfcfc;

    /*フォーム内容*/
    --input: #00000078;
    --input-hover: #00000021;
    /*ホーバー時*/
}


.font-body {
    font-family: Font Text, ui-sans-serif, system-ui, sans-serif, Apple Color Emoji, Segoe UI Emoji, Segoe UI Symbol, Noto Color Emoji;
}
.text-sm {
    font-size: 13px;
}

form,
.buttom-0,
input,
.text-base {
    --background: #2369c6e0;
}

/*ボーダー*/
:after,
:before {
    box-sizing: border-box;
    border: 0 solid #e5e7eb;
}
/*スクロール*/
* {
    scrollbar-width: thin;
    scrollbar-color: var(--scrollbar-thumb) var(--scrollbar-track);
}

/*grokのろご*/
.text-primary {
    color: #141414e8;
}

/*情報そーす*/
.prose {
    color: #43319ce8;
}

.bg-background {
    --background-color: #00000003;
}

/*メッセージ*/
.message-bubble {

    background-color: #b428d480;
}
/*ぷろんプロ */
.whitespace-pre-wrap {
    color: #000000db;
    background-color: #b428d41a;
}

/*スクリプトソース*/
element.style {
    display: block;
    overflow-x: auto;
    padding: 16px;
    color: #201f20eb;
    background: #0000;
    foreground: #0000;
    border-radius: 0px 0px 12px 12px;
    margin-top: 0px;
    font-size: 0.9em;
    line-height: 1.5em;
}

/*文章の中たぐ*/
p {}
h3 {}
ul {}
li {}
strong {}
span {}
button {}
code {
    color: #000000f5;
    background-color: #b428d400;
}
.duration150 {

    background-color: #b428d40f;
}

.bg-foreground/* 共有ぼたん？ */
{
    background-color: #b428d4cc;
}

/*背景とうか*/
main {

    background: #0003;
}

body {
    background-color: #00000000;
    background-size: cover !important;
    background: 
url(`;

const css_head_custom = `@-moz-document domain("{your_url}") {`;
const css_body_custom = `
    body {
    background-image: url(`;

const foot_body = ");\r\n}";
const foot_stylus = "}";
const foot_tamper = "\r\n`);";

var output = 'custom.user.css';

var result = "";
const resultDiv = document.getElementById('result');

// 既存の定数や変数はそのまま使用

const outputTypeSelect = document.getElementById('output_type');
const targetSiteSelect = document.getElementById('target_site');

imageInput.addEventListener('change', (event) => {
  const file = event.target.files[0];
  meta = meta.replace("0.1.0", getCurrentDateTime());
  if (file) {
    const reader = new FileReader();

    reader.onload = (e) => {
      const base64String = e.target.result;
      const imageType = file.type; // "image/png" or "image/jpeg"

      result = `${base64String}`;
      const outputType = outputTypeSelect.value;
      const targetSite = targetSiteSelect.value;

      const today = new Date();
      const formattedDate = today.getFullYear() + '-' +
        String(today.getMonth() + 1).padStart(2, '0') + '-' +
        String(today.getDate()).padStart(2, '0');


      // 出力形式に応じた処理
      if (outputType === "base64_only") {
        result = base64String;
      } else if (outputType === "stylus") {
        meta = meta.replace(/{datenow}/gm, formattedDate);
        meta = meta.replace(/{targetSite}/gm, targetSite);
        if (targetSite === "gemini") {
          result = meta + css_head_gemini + css_body_gemini + result + foot_body + foot_stylus;
        } else if (targetSite === "claude") {
          result = meta + css_head_claude + css_body_claude + result + foot_body + foot_stylus;
        } else if (targetSite === "grok") {
          result = meta + css_head_grok + css_body_grok + result + foot_body + foot_stylus;
        } else if (targetSite === "chatgpt") {
          result = meta + css_head_chatgpt + css_body_chatgpt + result + foot_body + foot_stylus;
        } else if (targetSite === "copilot") {
          result = meta + css_head_copilot + css_body_copilot + result + foot_body + foot_stylus;
        } else if (targetSite === "lmsys") {
          result = meta + css_head_lmsys + css_body_lmsys + result + foot_body + foot_stylus;
        } else if (targetSite === "perplex") {
          result = meta + css_head_perplex + css_body_perplex + result + foot_body + foot_stylus;
        } else if (targetSite === "xcom") {
          result = meta + css_head_xcom + css_body_xcom + result + foot_body + foot_stylus;
        }
        else {
          result = meta + css_head_custom + css_body_custom + result + foot_body + foot_stylus;
        }
        output = targetSite + "_custom.user.css";
      } else if (outputType === "tampermonkey") {
        //tamper_gemini = tamper_gemini.replace(/{targetSite}/gm, targetSite);
        if (targetSite === "gemini") {
          tamper_gemini = tamper_gemini.replace(/{datenow}/gm, formattedDate);
          output = "tamper_gemini.user.js";
          result = tamper_gemini + css_body_gemini + result + foot_body + foot_tamper;
        } else if (targetSite === "claude") {
          tamper_claude = tamper_claude.replace(/{datenow}/gm, formattedDate);
          output = "tamper_claude.user.js";
          result = tamper_claude + css_body_claude + result + foot_body + foot_tamper;
        } else if (targetSite === "grok") {
          tamper_grok = tamper_grok.replace(/{datenow}/gm, formattedDate);
          output = "tamper_grok.user.js";
          result = tamper_grok + css_body_grok + result + foot_body + foot_tamper;
        } else if (targetSite === "chatgpt") {
          tamper_chatgpt = tamper_chatgpt.replace(/{datenow}/gm, formattedDate);
          output = "tamper_chatgpt.user.js";
          result = tamper_chatgpt + css_body_chatgpt + result + foot_body + foot_tamper;
        } else if (targetSite === "copilot") {
          tamper_copilot = tamper_copilot.replace(/{datenow}/gm, formattedDate);
          output = "tamper_copilot.user.js";
          result = tamper_copilot + css_body_copilot + result + foot_body + foot_tamper;
        } else if (targetSite === "lmsys") {
          tamper_lmsys = tamper_lmsys.replace(/{datenow}/gm, formattedDate);
          output = "tamper_lmsys.user.js";
          result = tamper_lmsys + css_body_lmsys + result + foot_body + foot_tamper;
        } else if (targetSite === "perplex") {
          tamper_perplex = tamper_perplex.replace(/{datenow}/gm, formattedDate);
          output = "tamper_perplex.user.js";
          result = tamper_perplex + css_body_perplex + result + foot_body + foot_tamper;
        } else if (targetSite === "xcom") {
          tamper_xcom = tamper_xcom.replace(/{datenow}/gm, formattedDate);
          output = "tamper_xcom.user.js";
          result = tamper_xcom + css_body_xcom + result + foot_body + foot_tamper;
        } else {
          tamper_custom = tamper_custom.replace(/{datenow}/gm, formattedDate);
          output = "custom.user.js";
          result = tamper_custom + css_body_custom + result + foot_body + foot_tamper;
        }
      } else if (outputType === "bookmarklet") {
        if (targetSite === "gemini") {
          output = "bookmarklet_gemini.txt";
          result = bookmarklet_head + css_body_gemini + result + foot_body + bookmarklet_foot;
        } else if (targetSite === "claude") {
          output = "bookmarklet_claude.txt";
          result = bookmarklet_head + css_body_claude + result + foot_body + bookmarklet_foot;
        } else if (targetSite === "grok") {
          output = "bookmarklet_grok.txt";
          result = bookmarklet_head + css_body_grok + result + foot_body + bookmarklet_foot;
        } else if (targetSite === "chatgpt") {
          output = "bookmarklet_chatgpt.txt";
          result = bookmarklet_head + css_body_chatgpt + result + foot_body + bookmarklet_foot;
        } else if (targetSite === "lmsys") {
          output = "bookmarklet_lmsys.txt";
          result = bookmarklet_head + css_body_lmsys + result + foot_body + bookmarklet_foot;
        } else if (targetSite === "perplex") {
          output = "bookmarklet_perplex.txt";
          result = bookmarklet_head + css_body_perplex + result + foot_body + bookmarklet_foot;
        } else if (targetSite === "xcom") {
          output = "bookmarklet_xcom.txt";
          result = bookmarklet_head + css_body_xcom + result + foot_body + bookmarklet_foot;
        } else {
          output = "bookmarklet_custom.txt";
          result = bookmarklet_head + css_body_custom + result + foot_body + bookmarklet_foot;
        }
      }


      resultDiv.innerHTML = `<p>Base64 文字列:</p><textarea id="target" rows="5" cols="50">` + result + `</textarea>`;
      console.log("Base64 文字列:", base64String);

      const img = document.createElement('img');
      img.src = base64String;
      resultDiv.appendChild(img);
    };

    reader.readAsDataURL(file);
  }
});

// 既存の他の関数（copyButtonイベントリスナーなど）はそのまま

var share_url = {
  "bsk": "https://bsky.app/intent/compose?text=TXT",
  "tw": "http://twitter.com/share?text=TXT"
}


//Twitterボタン
function toshare(sns) {
  var urls = "";
  var urlmaster = document.location.href;
  var base_url = share_url[sns];
  var tag = "\r\n#base64　#gemini #claude #grok #stylus #user.css #custom_bg #tampermonkey #user.js";

  s = `chrome/edge/firefoxのstylus/tamperjsで背景色画像を変更したよ() `;
  s = s.replace(/<br>/gm, "\r\n");
  s = s.replace(/<.*?>/gm, "");
  s = s.replace(/\r\n\r\n/gm, "\r\n");

  s = s + tag + "\r\n " + urlmaster;
  s = encodeURIComponent(s);
  urls = base_url.replace("TXT", s);
  window.open(urls, "_blank", "width=600,height=300");
}

function makeplugin() {
  const base64Data = result; // Base64データ
  downloadBase64(base64Data, output);
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