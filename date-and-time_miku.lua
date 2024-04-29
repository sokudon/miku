--orig https://obsproject.com/forum/resources/date-and-time.644/
-- 令和テキトー表示とUTCグローバル時間を出せるよう改造

--出力例
--サマータイム有り＋時差情報 先頭に!をつけるとUTC時間になる
--%Y/%m/%d(%Vw)%X(UTC%z%DST)

--和暦表示　令和から
-- %VR%m月%d日(%Vw)%H時%M分%S秒

--全部出し
--%UTC%n%c%DST%n%x%X%z%n%s%n%ISO%n%ISOZ%n%VR%m月%d日(%Vw)%H時%M分%S秒

--複数のタイムゾーン
--%JST%nUTC+?? %UTC%nUTC協定時間%ISOZ%nISO8601 %ISO%n

--あいますの情報を出す
--%JST%n%i%n%J%is%n%K%it%n%E%ie%n

--誕生日
--%JST%n%in%n%ib%n%ic

--独自拡張2020/04/17現在 
--%EM	お誕生日何日以内のやつ
--%E	デバッグ文字1 サービス終了日
--%J	デバッグ文字2 サービス開始日
--%K	デバッグ文字3 今年の周年日
--$i	ゲームの名前,フリーズ防止
--%is	記念日の時間からの経過時間
--%it	記念日までの時間
--%ie	サービス終了した時間からの経過時間(データがないものは表示なし)
--%ib	アイドル名誕生日
--%ic	アイドル名誕生日までの時間
--%in	アイドル名
--%UTC  worldtime set UTCsetting,	UTC標準時からUI設定の時間を表示,サマータイムは非対応
--%JST  ISO8601表示日本時間
--%ISO  ISO8601表示ローカル時間
--%ISOZ ISO8601表示UTC時間
--%Z	サマーなしタイムゾーン時差情報,元はタイムゾーンストリングだが文字化けで使えないので（）
--%ZZ   timezone,HH:mm  timezoneサマーなしタイムゾーン時差情報  
--%zz   サマータイム有り＋時差情報 HH:mm
--%DST  夏時間かどうか出力する 引数"J"で夏時間
--%s    unixtime,フリーズ防止
--%VR--%Vr--%VH--%Vh--%VS--%Vs--%VT--%Vt 日本の和暦、開始年しかちぇくしてないのでてきとー


--OBSlua標準出力
--画像でまとめてみた　https://imgur.com/a/MYtwxg1

--http://noriko3.blog42.fc2.com/blog-entry-128.html?sp
--%% the character `%´ %の文字だけをだしたいとき 
--%a ロケールの省略形の曜日名 (Sun..Sat) 
--%A ロケールの完全表記の曜日名、可変長 (Sunday..Saturday) 
--%b ロケールの省略形の月名 (Jan..Dec) 
--%B ロケールの完全表記の月名、可変長 (January..December) 
--%c ロケールの日付と時刻 (Sat Nov 4 12:02:33 EST
--%d 月内通算日数 (01..31) 
--%D 日付 (mm/dd/yy) 
--%H hour, using a 24-hour clock (23) [00-23] 時間 
--%h %b と同じ 
--%I hour, using a 12-hour clock (11) [01-12] 時間ampm %pとセット 
--%j 年内通算日数 (001..366) 
--%k 時 (0..23) 
--%l 時 (1..12) 
--%M minute (48) [00-59] 分 
--%m month (09) [01-12] 月 
--%n 改行 
--%p AM あるいは PM のロケール 
--%r 時刻、12 時間 (hh:mm:ss [AP]M) 
--%S second (10) [00-61] 秒 
--%s 1970-01-01 0:00:00 UTC からの秒数 (標準外の拡張) 
--%T 時刻、24 時間 (hh:mm:ss) 
--%t 水平タブ 
--%U 日曜日を週の最初の日とした年内通算週 (00..53) 
--%V 週番号 
--%w weekday (3) [0-6 = Sunday-Saturday] 曜日の番号 
--%w 週のうちの曜日 (0..6) (0 が日曜日) 
--%W 月曜日を週の最初の日とした年内通算週 (00..53) 
--%x date (e.g., 09/16/98) 年月日 
--%X time (e.g., 23:48:10) 時分秒 
--%X ロケールによる時刻の表現 (%H:%M:%S) 
--%x ロケールの日付表現 (mm/dd/yy) 
--%Y full year (1998) 年 
--%y two-digit year (98) [00-99] ２桁の年 
--%y 年の最後の 2 つの数字 (00..99) 
--%Y 年 (1970...) 
--%Z タイムゾーン (例 EDT)、あるいはタイムゾーンが決定できないならば無し 
--%z timezone,osdateのサマータイム有り 

--クラッシュ使用不可か別の文字処理に使う
--%E　デバッグ文字1
--%J　デバッグ文字2
--%K　デバッグ文字3
--%L
--%N
--%O
--%P
--%Q
--%f
--%i あいますの時間
--%k 
--%l
--%o
--%q
--%s　　unixtimeに使用
--%v

--%%A:%A%n%%B:%B%n%%C:%C%n%%D:%D%n%%E:%E%n%%F:%F%n%%G:%G%n
--%%H:%H%n%%I:%I%n%%J:%J%n%%K:%K%n%%L:%L%n%%M:%M%n%%N:%N%n
--%%O:%O%n%%P:%P%n%%Q:%Q%n%%R:%R%n%%S:%S%n%%T:%T%n%%U:%U%n
--%%V:%V%n%%W:%W%n%%X:%X%n%%Y:%Y%n%%Z:%Z%n%%n:%n
--
--%%a:%a%n%%b:%b%n%%c:%c%n%%d:%d%n%%e:%e%n%%f:%f%n%%g:%g%n
--%%h:%h%n%%i:%i%n%%j:%j%n%%k:%k%n%%l:%l%n%%m:%m 
--%%o:%o%n%%p:%p%n%%q:%q%n%%r:%r%n%%s:%s%n%%t:%t%n%%u:%u
--%%v:%v%n%%w:%w%n%%x:%x%n%%y:%y%n%%z:%z

--hour	15 os.date("*t").hash　os.dateがもつ構造体
--min	21 
--wday	1
--day	28
--month	6
--year	2009
--sec	48
--yday	179




obs           = obslua
source_name   = ""

last_text     = ""
format_string = ""
activated     = false
utc           = 0
ima           = 0
imass         = 0
useidol		  = 1
mln        	  = 1
cgn           = 1
smn        	  = 1
scn           = 1
dsn           = 1
daylim 		  =7
daystring     =""
debugtxt1	  = ""
debugtxt2	  = ""
debugtxt3	  = ""
daychange     = ""


imashead ={"ゲーム名","稼働","機種","終わり"}
imas ={{"初音ミク -Project DIVA-","2009-07-02T00:00:00+09:00","PSP","","",""},{"初音ミク Project DIVA Arcade","2010-06-23T00:00:00+09:00","AC","","",""},{"初音ミク -Project DIVA- ドリーミーシアター","2010-06-24T00:00:00+09:00","PS3","","",""},{"初音ミク -Project DIVA- 2nd","2010-07-29T00:00:00+09:00","PSP","","",""},{"初音ミク -Project DIVA- ドリーミーシアター2nd","2011-08-04T00:00:00+09:00","PS3","","",""},{"初音ミク -Project DIVA- extend","2011-11-10T00:00:00+09:00","PSP","","",""},{"初音ミク Project mirai","2012-03-08T00:00:00+09:00","3DS","","",""},{"初音ミク -Project DIVA- f","2012-08-30T00:00:00+09:00","VITA","","",""},{"初音ミク -Project DIVA- ドリーミーシアターextend","2012-09-13T00:00:00+09:00","PS3","","",""},{"初音ミク ライブステージ プロデューサー","2012-11-08T00:00:00+09:00","android","2015-01-27T00:00:00+09:00","",""},{"初音ミク ライブステージ プロデューサー","2012-12-06T00:00:00+09:00","ios","2015-01-27T00:00:00+09:00","",""},{"初音ミク -Project DIVA- F","2013-03-07T00:00:00+09:00","VITA","","",""},{"Megpoid the Music #","2013-03-28T00:00:00+09:00","PSP","","",""},{"初音ミク Project DIVA Arcade Future Tone","2013-11-21T00:00:00+09:00","AC","","",""},{"初音ミク Project mirai 2","2013-11-28T00:00:00+09:00","3DS","","",""},{"初音ミク -Project DIVA- F 2nd","2014-03-27T00:00:00+09:00","VITA","","",""},{"初音ミクぐらふぃコレクション なぞの音楽すい星","2014-10-28T00:00:00+09:00","android,ios","2020-06-30T14:00:00+09:00","",""},{"初音ミク Project mirai でらっくす","2015-05-28T00:00:00+09:00","3DS","","",""},{"\tIA/VT -COLORFUL-","2015-07-30T00:00:00+09:00","VITA","","",""},{"初音ミク -Project DIVA- X","2016-03-24T00:00:00+09:00","VITA","","",""},{"初音ミク Project DIVA Future Tone Prelude／Future Sound／Colorful Tone","2016-06-23T00:00:00+09:00","PS4","","",""},{"初音ミク -Project DIVA- X HD","2016-08-25T00:00:00+09:00","PS4","","",""},{"初音ミク VRフューチャーライブ　1st Stage","2016-10-13T00:00:00+09:00","PS4","","",""},{"初音ミク VRフューチャーライブ　2nd Stage","2016-11-10T00:00:00+09:00","PS4","","",""},{"初音ミク VRフューチャーライブ　3rd Stage","2016-12-15T00:00:00+09:00","PS4","","",""},{"初音ミク Project DIVA Future Tone DX","2017-11-22T00:00:00+09:00","PS4","","",""},{"初音ミク -Project DIVA MEGA39's","2020-02-13T00:00:00+09:00","switch","","",""},{"初音ミク -TAP WONDER-","2020-06-25T00:00:00+09:00","android,ios","2024-01-25T15:00:00+09:00","",""},{"プロジェクトセカイ カラフルステージ！ feat. 初音ミク","2020-09-30T00:00:00+09:00","android,ios","","",""},{"初音ミク みんなで大富豪","2021-06-24T00:00:00+09:00","android,ios","","",""},{"Project SEKAI COLORFUL STAGE! feat. Hatsune Miku ","2021-09-30T00:00:00+09:00","android,ios","","",""},{"世界計畫繽紛舞台！ feat.初音未來","2021-12-08T00:00:00+09:00","android,ios","","",""},{"프로젝트 세카이 컬러풀 스테이지！ feat. 하츠네 미쿠","2022-05-20T00:00:00+09:00","android,ios","","",""},{"初音ミク Project DIVA MEGA39's+","2022-05-27T00:00:00+09:00","steam","","",""},{"Fit Boxing feat. 初音ミク -ミクといっしょにエクササイズ-","2024-03-07T00:00:00+09:00","switch","","",""}}
imasb='{"proseka":[["2020-01-08T00:00:00+09:00","日野森志歩",""],["2020-01-27T00:00:00+09:00","朝比奈まふゆ",""],["2020-01-30T00:00:00+09:00","巡音ルカ",""],["2020-02-10T00:00:00+09:00","宵崎奏",""],["2020-02-17T00:00:00+09:00","KAITO",""],["2020-03-02T00:00:00+09:00","小豆沢こはね",""],["2020-03-19T00:00:00+09:00","桃井愛莉",""],["2020-04-14T00:00:00+09:00","花里みのり",""],["2020-04-30T00:00:00+09:00","東雲絵名",""],["2020-05-09T00:00:00+09:00","天馬咲希",""],["2020-05-17T00:00:00+09:00","天馬司",""],["2020-05-25T00:00:00+09:00","青柳冬弥",""],["2020-06-24T00:00:00+09:00","神代類",""],["2020-07-20T00:00:00+09:00","草薙寧々",""],["2020-07-26T00:00:00+09:00","白石杏",""],["2020-08-11T00:00:00+09:00","星乃一歌",""],["2020-08-27T00:00:00+09:00","暁山瑞希",""],["2020-08-31T00:00:00+09:00","初音ミク",""],["2020-09-09T00:00:00+09:00","鳳えむ",""],["2020-10-05T00:00:00+09:00","桐谷遥",""],["2020-10-27T00:00:00+09:00","望月穂波",""],["2020-11-05T00:00:00+09:00","MEIKO",""],["2020-11-12T00:00:00+09:00","東雲彰人",""],["2020-12-06T00:00:00+09:00","日野森雫",""],["2020-12-27T00:00:00+09:00","鏡音レン",""],["2020-12-27T00:00:00+09:00","鏡音リン",""]],"vocalo":[["2004-01-15T00:00:00+09:00","LEON",""],["2004-01-15T00:00:00+09:00","LOLA",""],["2004-07-01T00:00:00+09:00","MIRIAM",""],["2004-11-05T00:00:00+09:00","MEIKO",""],["2006-02-17T00:00:00+09:00","KAITO",""],["2007-06-29T00:00:00+09:00","SweetAnn",""],["2007-08-31T00:00:00+09:00","初音ミク",""],["2007-09-04T00:00:00+09:00","はちゅねミク",""],["2007-10-17T00:00:00+09:00","雑音ミク",""],["2007-10-20T00:00:00+09:00","ざちゅねミク",""],["2007-10-27T00:00:00+09:00","初音ミクオ",""],["2007-10-30T00:00:00+09:00","終音ニク",""],["2007-11-01T00:00:00+09:00","亞北ネル",""],["2007-11-04T00:00:00+09:00","つくねミク",""],["2007-11-08T00:00:00+09:00","かぐぁみねリン",""],["2007-11-14T00:00:00+09:00","あちたねりゅ",""],["2007-11-16T00:00:00+09:00","和音ミク",""],["2007-11-21T00:00:00+09:00","弱音ハク",""],["2007-11-22T00:00:00+09:00","亞北ネロ",""],["2007-11-30T00:00:00+09:00","鈴音フク",""],["2007-12-02T00:00:00+09:00","鈴音リン",""],["2007-12-14T00:00:00+09:00","隣音サイ",""],["2007-12-16T00:00:00+09:00","MEITO",""],["2007-12-22T00:00:00+09:00","耗夜メテ",""],["2007-12-23T00:00:00+09:00","ミクカル様",""],["2007-12-24T00:00:00+09:00","闇音アク",""],["2007-12-26T00:00:00+09:00","ブラック★ロックシューター",""],["2007-12-27T00:00:00+09:00","阿久女イク",""],["2007-12-27T00:00:00+09:00","鏡音リン",""],["2007-12-27T00:00:00+09:00","鏡音レン",""],["2007-12-28T00:00:00+09:00","鏡音ロン",""],["2008-01-14T00:00:00+09:00","PRIMA",""],["2008-01-18T00:00:00+09:00","鋼音ミク",""],["2008-01-19T00:00:00+09:00","華音ミル",""],["2008-01-21T00:00:00+09:00","迷子",""],["2008-02-02T00:00:00+09:00","ギロカクたん",""],["2008-02-06T00:00:00+09:00","子守音レム",""],["2008-02-12T00:00:00+09:00","AKAITO",""],["2008-02-15T00:00:00+09:00","乙音ペケ",""],["2008-02-15T00:00:00+09:00","呪音キク",""],["2008-02-17T00:00:00+09:00","焼音ニク",""],["2008-03-14T00:00:00+09:00","帯人",""],["2008-03-16T00:00:00+09:00","KIKAITO",""],["2008-03-24T00:00:00+09:00","外れミク",""],["2008-03-24T00:00:00+09:00","初音三久",""],["2008-03-28T00:00:00+09:00","鏡音リント",""],["2008-04-01T00:00:00+09:00","重音テト",""],["2008-04-05T00:00:00+09:00","亞乃音ムリ",""],["2008-04-09T00:00:00+09:00","ニガイト",""],["2008-04-10T00:00:00+09:00","機械人（キカイト）",""],["2008-04-11T00:00:00+09:00","咲音メイコ",""],["2008-05-23T00:00:00+09:00","本音デル",""],["2008-06-21T00:00:00+09:00","太目ニク",""],["2008-07-18T00:00:00+09:00","鏡音リンact2",""],["2008-07-18T00:00:00+09:00","鏡音レンact2",""],["2008-07-20T00:00:00+09:00","風見音セン",""],["2008-07-20T00:00:00+09:00","風見音レツ",""],["2008-07-31T00:00:00+09:00","がくっぽいど",""],["2008-07-31T00:00:00+09:00","神威がくぽ",""],["2008-08-08T00:00:00+09:00","しゃきねめ～こ",""],["2008-11-17T00:00:00+09:00","欲音ルコ",""],["2009-01-08T00:00:00+09:00","たこルカ",""],["2009-01-09T00:00:00+09:00","ルカントさん",""],["2009-01-30T00:00:00+09:00","巡音ルカ",""],["2009-03-15T00:00:00+09:00","骸音シーエ",""],["2009-06-26T00:00:00+09:00","VOCALOID2 Megpoid",""],["2009-07-15T00:00:00+09:00","SONIKA",""],["2009-08-06T00:00:00+09:00","鏡音レンカ",""],["2009-10-06T00:00:00+09:00","CV-4Cβ",""],["2009-10-12T00:00:00+09:00","波音リツ",""],["2009-10-24T00:00:00+09:00","雪女ミク",""],["2009-12-04T00:00:00+09:00","miki（SF-A2 開発コードmiki）",""],["2009-12-04T00:00:00+09:00","SF-A2 開発コード miki",""],["2009-12-04T00:00:00+09:00","歌愛ユキ",""],["2009-12-04T00:00:00+09:00","氷山キヨテル",""],["2009-12-17T00:00:00+09:00","リンの幼虫",""],["2009-12-22T00:00:00+09:00","BIG-AL",""],["2010-02-02T00:00:00+09:00","シテヤンヨ",""],["2010-04-30T00:00:00+09:00","初音ミクAppend",""],["2010-06-19T00:00:00+09:00","健音テイ",""],["2010-07-13T00:00:00+09:00","TONIO",""],["2010-07-29T00:00:00+09:00","ハニーリリー",""],["2010-08-25T00:00:00+09:00","Lily",""],["2010-09-01T00:00:00+09:00","VY1",""],["2010-10-05T00:00:00+09:00","VY1iV",""],["2010-10-08T00:00:00+09:00","リュウト",""],["2010-10-08T00:00:00+09:00","怨音リナ",""],["2010-10-22T00:00:00+09:00","猫村いろは",""],["2010-11-06T00:00:00+09:00","まるくなるミク",""],["2010-12-08T00:00:00+09:00","歌手音ピコ",""],["2010-12-27T00:00:00+09:00","鏡音リンAppend",""],["2010-12-27T00:00:00+09:00","鏡音レンAppend",""],["2011-02-14T00:00:00+09:00","刹音セレ",""],["2011-03-08T00:00:00+09:00","しゅしゅミク",""],["2011-04-25T00:00:00+09:00","VY2",""],["2011-05-01T00:00:00+09:00","おどおどハク",""],["2011-05-01T00:00:00+09:00","つんつんネル",""],["2011-07-24T00:00:00+09:00","植木ロイド",""],["2011-08-30T00:00:00+09:00","SeeU",""],["2011-09-01T00:00:00+09:00","VY2iV",""],["2011-09-06T00:00:00+09:00","あきこロイドちゃん",""],["2011-09-17T00:00:00+09:00","ミクダヨー",""],["2011-10-12T00:00:00+09:00","とてとてテト",""],["2011-10-21T00:00:00+09:00","Mew",""],["2011-10-21T00:00:00+09:00","VOCALOID3 Megpoid（Power、Adult、Sweet、Whisper）",""],["2011-10-21T00:00:00+09:00","VY1V3",""],["2011-12-06T00:00:00+09:00","下火セツ",""],["2011-12-16T00:00:00+09:00","兎眠りおん",""],["2011-12-21T00:00:00+09:00","OLIVER",""],["2011-12-22T00:00:00+09:00","CUL",""],["2011-12-22T00:00:00+09:00","結月ゆかり（結月縁）",""],["2011-12-23T00:00:00+09:00","Bruno",""],["2011-12-23T00:00:00+09:00","Clara",""],["2012-01-27T00:00:00+09:00","イア",""],["2012-02-12T00:00:00+09:00","鏡音ノリン",""],["2012-03-16T00:00:00+09:00","VOCALOID3 Megpoid（ Native）",""],["2012-04-06T00:00:00+09:00","蒼姫ラピス",""],["2012-04-19T00:00:00+09:00","VOCALOID3 Lily",""],["2012-05-06T00:00:00+09:00","MAYU",""],["2012-06-03T00:00:00+09:00","まるくなるネル",""],["2012-07-12T00:00:00+09:00","洛天依",""],["2012-07-13T00:00:00+09:00","VOCALOID3 がくっぽいど",""],["2012-08-05T00:00:00+09:00","galaco",""],["2012-08-29T00:00:00+09:00","ミクナノー",""],["2012-10-19T00:00:00+09:00","VY2V3",""],["2012-11-26T00:00:00+09:00","iVラピス",""],["2012-12-22T00:00:00+09:00","Avanna",""],["2013-02-15T00:00:00+09:00","KAITO V3",""],["2013-02-28T00:00:00+09:00","VOCALOID3 Megpoid（English）",""],["2013-04-05T00:00:00+09:00","SHION/UTAU",""],["2013-06-21T00:00:00+09:00","KYO",""],["2013-06-21T00:00:00+09:00","WIL",""],["2013-06-21T00:00:00+09:00","YUU",""],["2013-07-11T00:00:00+09:00","言和",""],["2013-08-31T00:00:00+09:00","初音ミクV3（English）",""],["2013-09-10T00:00:00+09:00","YOHIOloid",""],["2013-09-26T00:00:00+09:00","CeVIO Creative Studio",""],["2013-09-26T00:00:00+09:00","初音ミクV3 バンドル（Original、Sweet、Dark、Soft、Solid、English）",""],["2013-09-26T00:00:00+09:00","初音ミクV3（Original、Sweet、Dark、Soft、Solid）",""],["2013-09-26T00:00:00+09:00","CeVIO Creative Studio　すずきつづみ",""],["2013-12-18T00:00:00+09:00","MAIKA",""],["2013-12-24T00:00:00+09:00","メルリ",""],["2014-01-16T00:00:00+09:00","Megpoid Talk",""],["2014-01-31T00:00:00+09:00","マクネナナ",""],["2014-02-04T00:00:00+09:00","MEIKO V3",""],["2014-02-14T00:00:00+09:00","kokone（心響）",""],["2014-03-03T00:00:00+09:00","杏音",""],["2014-03-03T00:00:00+09:00","鳥音",""],["2014-03-26T00:00:00+09:00","iVメルリ",""],["2014-05-09T00:00:00+09:00","flower",""],["2014-06-05T00:00:00+09:00","東北ずん子",""],["2014-06-27T00:00:00+09:00","IA ROCKS -ARIA ON THE PLANETES-",""],["2014-08-01T00:00:00+09:00","galaco NEO",""],["2014-09-09T00:00:00+09:00","Rana",""],["2014-09-17T00:00:00+09:00","VOCALOID3 ガチャッポイド",""],["2014-10-16T00:00:00+09:00","Chika",""],["2014-11-20T00:00:00+09:00","CeVIO さとうささらソングボイス",""],["2014-12-10T00:00:00+09:00","Hide",""],["2014-12-18T00:00:00+09:00","VY1V4",""],["2015-02-04T00:00:00+09:00","CYBER DIVA",""],["2015-02-10T00:00:00+09:00","心華",""],["2015-03-18T00:00:00+09:00","V4結月ゆかり コンプリート",""],["2015-03-18T00:00:00+09:00","V4結月ゆかり 穏",""],["2015-03-18T00:00:00+09:00","V4結月ゆかり 純",""],["2015-03-18T00:00:00+09:00","V4結月ゆかり 凛",""],["2015-03-19T00:00:00+09:00","巡音ルカV4X",""],["2015-04-30T00:00:00+09:00","がくっぽいどV4",""],["2015-06-18T00:00:00+09:00","開発コードmikiV4",""],["2015-06-18T00:00:00+09:00","猫村いろはV4",""],["2015-06-24T00:00:00+09:00","アルスロイド",""],["2015-07-12T00:00:00+09:00","V4 Flower",""],["2015-07-17T00:00:00+09:00","楽正綾",""],["2015-07-27T00:00:00+09:00","Sachiko",""],["2015-09-20T00:00:00+09:00","アルスロイド(製品版）",""],["2015-10-07T00:00:00+09:00","Ruby",""],["2015-10-29T00:00:00+09:00","歌愛ユキV4",""],["2015-10-29T00:00:00+09:00","氷山キヨテルV4",""],["2015-11-05T00:00:00+09:00","メグッポイドV4",""],["2015-11-21T00:00:00+09:00","DAINA",""],["2015-11-21T00:00:00+09:00","DEX",""],["2015-12-01T00:00:00+09:00","Rana V4",""],["2015-12-21T00:00:00+09:00","VOCALOID SDK for Unity",""],["2015-12-24T00:00:00+09:00","鏡音レンV4X",""],["2016-01-14T00:00:00+09:00","unity-chan!",""],["2016-01-28T00:00:00+09:00","Fukase",""],["2016-02-20T00:00:00+09:00","星塵",""],["2016-07-30T00:00:00+09:00","音街ウナ（sugar、spicy）",""],["2016-08-31T00:00:00+09:00","初音ミク V4 ENGLISH",""],["2016-08-31T00:00:00+09:00","初音ミク V4X バンドル",""],["2016-08-31T00:00:00+09:00","初音ミク V4X（ORIGINAL、SWEET、DARK、SOFT、SOLID）",""],["2016-10-26T00:00:00+09:00","東北ずん子 V4 ナチュラル",""],["2016-10-31T00:00:00+09:00","Cyber Songman",""],["2016-12-15T00:00:00+09:00","マクネナナ プチ",""],["2016-12-15T00:00:00+09:00","マクネナナV4 English",""],["2016-12-15T00:00:00+09:00","マクネナナV4 ナチュラル",""],["2017-02-14T00:00:00+09:00","UNI",""],["2017-02-16T00:00:00+09:00","兎眠りおんV4",""],["2017-02-16T00:00:00+09:00","夢眠ネム",""],["2017-05-10T00:00:00+09:00","楽正龍牙",""],["2017-05-22T00:00:00+09:00","UTAUずんだもん",""],["2017-06-01T00:00:00+09:00","UTAU沖縄あわも",""],["2017-06-11T00:00:00+09:00","正岡小豆",""],["2017-07-12T00:00:00+09:00","AZUKI",""],["2017-07-12T00:00:00+09:00","MATCHA",""],["2017-08-30T00:00:00+09:00","LUMi",""],["2017-08-31T00:00:00+09:00","初音ミク V4 CHINESE",""],["2017-09-13T00:00:00+09:00","小林抹茶",""],["2017-09-22T00:00:00+09:00","心華V4",""],["2018-04-26T00:00:00+09:00","紲星あかり",""],["2018-05-21T00:00:00+09:00","洛天依(日本語版)",""],["2018-05-24T00:00:00+09:00","ミライ小町",""],["2018-07-12T00:00:00+09:00","VOCALOID5/PREMIUM",""],["2018-07-26T00:00:00+09:00","桜乃そら ナチュラル/クール",""],["2018-08-02T00:00:00+09:00","徵羽摩柯/墨清弦",""],["2021-06-18T00:00:00+09:00","SynthesizerV AI 弦巻マキ",""],["2021-07-07T00:00:00+09:00","音楽的同位体 可不",""],["2021-08-01T00:00:00+09:00","VOICEVOXずんだもん",""],["2021-08-05T00:00:00+09:00","CeVIO AI さとうささらソングボイス",""],["2021-08-05T00:00:00+09:00","CeVIO AI さとうささらトークボイス",""],["2022-04-29T00:00:00+09:00","音楽的同位体 星界",""],["2022-08-01T00:00:00+09:00","NEUTRINOずんだもん",""],["2022-09-05T00:00:00+09:00","VoiSona さとうささら 日本語ソングボイスライブラリ",""],["2022-10-13T00:00:00+09:00","AI Megpoid",""],["2022-10-13T00:00:00+09:00","HARUKA",""],["2022-10-13T00:00:00+09:00","AKITO",""],["2022-10-13T00:00:00+09:00","ALLEN",""],["2022-10-13T00:00:00+09:00","SARAH",""],["2022-10-25T00:00:00+09:00","音楽的同位体 裏命(RIME)        ",""],["2022-11-29T00:00:00+09:00","Seiren Voice ずんだもん",""],["2022-12-21T00:00:00+09:00","夢ノ結唱 BanG Dream! AI Singing Synthesizer POPY\t",""],["2022-12-21T00:00:00+09:00","夢ノ結唱 BanG Dream! AI Singing",""],["2022-12-21T00:00:00+09:00"," Synthesizer ROSE\tSynthesizer V AI 夢ノ結唱 ROSE",""],["2023-01-25T00:00:00+09:00","音楽的同位体 狐子（COKO）",""],["2023-02-26T00:00:00+09:00","#kzn",""],["2023-03-07T00:00:00+09:00","Po-uta",""],["2023-04-21T00:00:00+09:00","VoiSona",""],["2023-05-09T00:00:00+09:00","符色  ",""],["2023-07-13T00:00:00+09:00","MYK-IV",""],["2023-09-01T00:00:00+09:00","VoiSona Talk さとうささら日本語トークボイスライブラリ",""],["2023-12-14T00:00:00+09:00","AiSuu",""],["2023-12-20T00:00:00+09:00","SynthesizerV AI Megpoid",""],["2023-12-21T00:00:00+09:00","Synthesizer V AI 夢ノ結唱 POPY",""],["2023-12-24T00:00:00+09:00","ASAHI",""],["2023-12-24T00:00:00+09:00","SAKURA",""],["2023-12-24T00:00:00+09:00","SHION/VOCALOID",""],["2024-01-25T00:00:00+09:00","音楽的同位体 狐子 TALK EXTENSION collaboration with VOICEPEAK",""],["2024-04-26T00:00:00+09:00","CeVIO AI ユニちゃん",""],["--","RUNE",""],["--","VIBE",""],["--","ヒビキ・ルイ",""],["--","リング・スズネ",""],["2006-05-25T00:00:00+09:00","AquesTalk1",""],["2010-01-27T00:00:00+09:00","AquesTalk2",""],["2017-10-10T00:00:00+09:00","AquesTalk10",""],["2022-08-13T00:00:00+09:00","AquesTalkPlayer",""]],"kinen":[["2020-06-07T00:00:00+09:00","ミクオの日",""],["2020-03-09T00:00:00+09:00","ミクの日",""],["2020-09-03T00:00:00+09:00","GUMIの日",""],["2020-09-03T00:00:00+09:00","亞北ネルの日",""],["2020-08-09T00:00:00+09:00","ハクさんの日",""],["2020-12-05T00:00:00+09:00","ずんだもん誕生日",""],["2020-01-22T00:00:00+09:00","さとうささら誕生日",""],["2020-11-01T00:00:00+09:00","沖縄あわも誕生日",""],["2020-02-23T00:00:00+09:00","すずきつづみ誕生日",""]]}'
imassel={"proseka","vocalo","kinen"}
imasname={"プロセカ","ボカロ","記念"}

-- Function to set the time text

--http://lua-users.org/wiki/TimeZone
function get_timezone()
  local now = os.time()
  return os.difftime(now, os.time(os.date("!*t", now))) --サマーなしタイムゾーン時差情報 現在時間
end

function get_tzoffset(timezone)
  local h, m = math.modf(timezone / 3600)
  return string.format("%+.4d", 100 * h + 60 * m)
end

function get_tzoffset_sepa(timezone)
  local h, m = math.modf(timezone / 3600)
  return string.format("%+03d:%02d",  h ,math.abs(60 * m))
end

function get_timezone_offset(ts)  --サマー有りタイムゾーン時差情報 当時の時間
	local utcdate   = os.date("!*t", ts)
	local localdate = os.date("*t", ts)
	localdate.isdst = false -- this is the trick
	return os.difftime(os.time(localdate), os.time(utcdate))
end

function get_timezone_the_day()
  local hh = tonumber(string.format("%d",(tonumber(os.date("%z"))/100)))
  local mm= ((tonumber(os.date("%z"))-100*hh)/60)*3600
  local hhmm = hh*3600 +mm
  return hhmm  --サマー有りタイムゾーン時差情報 現在時間
end

function lefttime(dt) 
	if(dt=="Invalid date")then
	return dt
	end
	local t=parse_json_date_utc(dt) -os.time() 
	return  t
end

function elasped(dt) 
	return  -(lefttime(dt))
end

function DateUTC(y,M,D,h,m,s,ms)  --DATEUTCもどきMM月だけjsとおなじ-1月なので（）
local dt = string.format("%04d",tonumber(y)).."-".. string.format("%02d",tonumber(M)+1).."-".. string.format("%02d",tonumber(D))
	  dt = dt.."T".. string.format("%02d",tonumber(h))..":".. string.format("%02d",tonumber(m))
	  dt=  dt..":".. string.format("%02d",tonumber(s))..".".. string.format("%03d",tonumber(ms)).."Z"
	  
	  --debugtxt1 =dt
	  --debugtxt2 =parse_json_date_utc(dt)
	  --debugtxt3 =os.date("!%x %X %a ",parse_json_date_utc(dt))
	  
	return parse_json_date_utc(dt)
end

function JST(dt)
return os.date('!%Y/%m/%dT%X(JST)%a',parse_json_date_utc(dt)+3600*9)
end

function JSTday()
return os.date('!%d',os.time()+3600*9)
end


function parse_json_date_utc(json_date) --ISO8601datetimeparse パーサー完成版？
    local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d+.]+)([Z%+%-])(%d?%d?):?(%d?%d?)"

    if(json_date:match("U$")) then --try parse UTC FIX
    local normal = "(%d+)[%-%/](%d+)[%-%/](%d+) +(%d+)%:(%d+)U$"--ローカル時間MD+HM
        if(json_date:match(normal))then
        local year, month, day, hour, minute,
        seconds = json_date:match(normal)
        json_date = year.."-"..month.."-"..day.."T"..hour..":"..minute..":00".. get_tzoffset(utc*3600)
     end
     end
     
     
    if(json_date:match(pattern)==nil)then
   
    local unix = "^(%d+)$"
    local normalp = "(%d+)[%-%/](%d+)[%-%/](%d+)$"--ローカル時間MD
    local normalq = "(%d+)[%-%/](%d+)[%-%/](%d+) +(%d+)$"--ローカル時間MD+h
    local normal = "(%d+)[%-%/](%d+)[%-%/](%d+) +(%d+)%:(%d+)$"--ローカル時間MD+HM
    local normalr = "(%d+)[%-%/](%d+)[%-%/](%d+) +(%d+)%:(%d+)%:([%d%.]+)"--ローカル時間MDhms

        if(json_date:match(normal))then
        local year, month, day, hour, minute,
        seconds = json_date:match(normal)
    	 return  os.time{year = year, month = month, day = day, hour =  hour, min = minute, sec = 0}
    	end
    	if(json_date:match(normalp))then
        local year, month, day, hour, minute,
        seconds = json_date:match(normalp)
    	 return  os.time{year = year, month = month, day = day, hour =  0, min =0, sec = 0}
    	end
    	 if(json_date:match(normalq))then
        local year, month, day, hour, minute,
        seconds = json_date:match(normalq)
    	 return  os.time{year = year, month = month, day = day, hour =  hour, min = 0, sec = 0}
    	end
    	 if(json_date:match(normalr))then
        local year, month, day, hour, minute,
        seconds = json_date:match(normalr)
    	 return  os.time{year = year, month = month, day = day, hour =  hour, min = minute, sec = seconds}
    	end
    	if(json_date:match(unix)) then
	     return json_date
    	end
    
     return "Invalid date"
    end
    
    local year, month, day, hour, minute, 
        seconds, offsetsign, offsethour, offsetmin =json_date:match(pattern)
    
    local timestamp = os.time{year = year, month = month, 
        day = day, hour = 4, min = minute, sec = seconds}
    local offset = 0
    if offsetsign ~= 'Z' then
      offset = tonumber(offsethour) * 3600 + tonumber(offsetmin)*60
      if offsetsign == "-" then offset = offset * -1 end
    end
    
    
    --local temp = os.date("*t",timestamp)
    --if(temp.isdst) then  --パースした時刻がサマーがしらべる
    --offset = offset -3600  --0.5サマータイムもあるので（）、オーストラリアだと使えないかも
    --end
    --return timestamp + get_timezone() -offset
    
    --return timestamp + get_timezone_the_day() -offset
    
    return timestamp + get_timezone_offset(timestamp) -offset  + (hour-4)*3600
    --hourは越境時タイムマシンが発生するので最後に足す、幻の2時(2020-03-08T02:00:00) -05:00
    --https://ja.wikipedia.org/wiki/%E5%A4%8F%E6%99%82%E9%96%93　ブラジルが0時豪州3時なので4時までずらす
end


function isDST(J)
	local localdate = os.date("*t")
	local st=""
	if(localdate.isdst) then
		st="DST"
		if(J=="J")then
		st="夏時間"
		end
	end
	return st
end

function isempty(s)
  return s == nil or s == ''
end

function JPday(date,t)
  
  local dt = os.date("*t",t)
  if (get_timezone_the_day() == 9*3600) then --動作は日本時間のときだけ
  	date= string.gsub(date, "%%VR","令和"..(dt.year-2018).."年")
  	date= string.gsub(date, "%%Vr","R"..(dt.year-2018))  --%Vr/%Y/%m/%d(%Vw)%X
  	date= string.gsub(date, "%%VH","平成"..(dt.year-1988).."年")
  	date= string.gsub(date, "%%Vh","H"..(dt.year-1988))
  	date= string.gsub(date, "%%VS","昭和"..(dt.year-1925).."年")
  	date= string.gsub(date, "%%Vs","S"..(dt.year-1925))
  	date= string.gsub(date, "%%VT","大正"..(dt.year-1911).."年")
  	date= string.gsub(date, "%%Vt","T"..(dt.year-1911))
  end
  
  --DateUTC(2020,2,31,20,48,0,0)
  local jp_day={"日","月","火","水","木","金","土"} --%w用
  date= string.gsub(date, "%%EM",daystring)  ----フリーズ文字代替
  date= string.gsub(date, "%%E",debugtxt1)  ----フリーズ文字代替
  date= string.gsub(date, "%%J",debugtxt2)  ----フリーズ文字代替
  date= string.gsub(date, "%%K",debugtxt3)  ----フリーズ文字代替
  date= string.gsub(date, "%%s",os.time())  ----フリーズ文字代替
  date= string.gsub(date, "%%DST",isDST("J"))
  date= string.gsub(date, "%%Vw",jp_day[tonumber(os.date("%w",t))+1])
  date= string.gsub(date, "%%VW",jp_day[tonumber(os.date("%w",t))+1].."曜日") 
  date= string.gsub(date, "%%ZZ", get_tzoffset_sepa(get_timezone())) --timezone タイムゾーン時差情報標準時、サマータイムなし 
  date= string.gsub(date, "%%Z",  get_tzoffset(get_timezone())) --timezone タイムゾーン時差情報標準時、サマータイムなし 
  date= string.gsub(date, "%%zz", get_tzoffset_sepa(get_timezone_the_day())) --timezone タイムゾーン時差情報夏時間こみ

  date= string.gsub(date, "%%V%w","和暦はJST限")  ----令和しょりなし
  
 return date
end

function get_ep(tu)

   local total = tu*10

	--local tenths   = math.floor(total % 10)
	local seconds  = math.floor((total / 10) % 60)
	local minutes  = math.floor((total / 600) % 60)
	local hours    = math.floor((total / 36000) % 24)
	local idays     = math.floor(total / 864000)
	local days     = math.floor(idays%365)
	local years    = math.floor(total/(864000*365))

	--local hours_infinite  = math.floor(total / 36000)
	--local seconds_infinite  = math.floor(total / 10)
	--local minutes_infinite  = math.floor(total / 600)
   local ep = years.."年"..days.."日".. hours.."時".. minutes.."分"..seconds .."秒"
   
   return ep
end

function parse_jp_era(date)
  local datestring=""
  
  date= string.gsub(date, "%%[LNOPQfkloqv]","")	--フリーズ文字 %%[EJKLNOPQfikloqsv]
  
  local t = os.time()
  
  --if(os.date("!%H%M",t)=="1500")then --0時のとき切り替え
  if(daychange ~= JSTday())then
  findday()
  end
  
  if (string.find(date,"%%i")) then
  
   local inum = (ima)%(#imas+1)    --imas[1] AC,dre 18 ,miri 22
   if(inum==0)then
   inum =1
   end
   local tu = elasped(imas[inum][2])
   local imasname =imas[inum][1] .."("..imas[inum][3]..")"
   local gm = "開始から" 
  
	local dateu='!%m%d'       --(%a)%X(UTC+09:00)'
	local nst =os.date(dateu,os.time()+9*3600)
	local tt = parse_json_date_utc(imas[inum][2])+9*3600
	local ist =os.date(dateu,tt)
	local nenme =""
	if(nst==ist)then
	local years    = math.floor(tu*10/(864000*365))
	nenme = ","..years.."周年"
	end
   local ep=get_ep(tu)
  	date =string.gsub(date, "%%is",gm..ep ..nenme)
  
  local theyear=string.format("%04d",tonumber(os.date("!%Y",os.time()+9*3600)))
  local dt = theyear .. "-".. string.format("%02d",tonumber(os.date('!%m',tt))).."-".. string.format("%02d",tonumber(os.date('!%d',tt))).."T"..string.format("%02d",tonumber(os.date('!%H',tt))) ..":00:00+09:00"
 
    debugtxt3=dt
 
  local gm = "周年" 
  local aniv=lefttime(dt)
  if(aniv<0) then
  aniv =-aniv
  gm = gm.."から"
  else
  gm = gm.."まで"
  end
  local ep= string.gsub(get_ep(aniv),"0年","")
  	date =string.gsub(date, "%%it",gm..ep)
  	
  local idn=imasb[imassel[imass]][useidol][2]
  local dt=imasb[imassel[imass]][useidol][1]
  if(dt=="" or dt == nil or dt =="--")then
  	date =string.gsub(date, "%%in",idn)
  	date =string.gsub(date, "%%ib","誕生日は不明です")
  	date =string.gsub(date, "%%ic","")
  else
  dt=string.gsub(dt,"2020",theyear)
  local aniv=lefttime(dt)
  local gm = "誕生日" 
  if(aniv<0) then
  aniv =-aniv
  gm = gm.."から"
  else
  gm = gm.."まで"
  end
  local ep= string.gsub(get_ep(aniv),"0年","")
  	date =string.gsub(date, "%%in",idn)
  	date =string.gsub(date, "%%ib",JST(dt))
  	date =string.gsub(date, "%%ic",gm..ep)
  end
  	
  	local imm=imas[inum][4]
  	debugtxt2=JST(imas[inum][2])  --開始日
  	debugtxt1=""
  	
  	--debugtxt1=imasb["sc"][1][2]
  	--debugtxt2=imasb["ml"][1][2]
    --debugtxt3=imasb["cg"][1][2]
  	
  	if(isempty(imm)==false) then
  	debugtxt1= JST(imm) --差終わり日
    tu= elasped(imas[inum][4])
  	
   local ep=get_ep(tu)
  	date =string.gsub(date, "%%ie","サ終から"..ep )
  	end
  	
  	date =string.gsub(date, "%%ie","")
  	date =string.gsub(date, "%%i",imasname)
  end
  
  
  if (string.find(date,"%%UTC")) then
  local tu = os.time()  + (tonumber(utc)*3600)
  
  local u= get_tzoffset_sepa(utc*3600)
    local dateu='!%Y/%m/%d(%a)%X(UTC'..u..')' --%z系はOS依存のため使用不可
   
    --local jp_day={"日","月","火","水","木","金","土",} --dt.wday用
    --local dt = os.date("!*t",tu) --%Vwを使いたいとき utcの時間で曜日を取得する必要がある
	--dateu= string.gsub(dateu, "%%Vw",jp_day[dt.wday])
	
	--%w用
    --local getd = os.date("!%w",tu) --%Vwを使いたいとき utcの時間で曜日を取得する必要がある
	--dateu= string.gsub(dateu, "%%Vw",jp_day[tonumber(getd)+1])
	
  	dateu=JPday(dateu,tu)
  	datestring = os.date(dateu,tu)
  	date =string.gsub(date, "%%UTC",datestring)
  end
  if (string.find(date,"%%JST")) then
  local dateu='!%Y/%m/%dT%X(GMT+9:00,JST,日本時間) %a' --%z系はOS依存のため使用不可
  
  	datestring = os.date(dateu, t+9*3600)
  	date =string.gsub(date, "%%JST",datestring)
  end
  if (string.find(date,"%%ISOZ")) then
  local dateu='!%Y/%m/%dT%XZ %a'    --%z系はOS依存のため使用不可
  

  	datestring = os.date(dateu, t)
  	date =string.gsub(date, "%%ISO%w",datestring)
  end
  if (string.find(date,"%%ISO")) then
    local dateu='%Y/%m/%dT%X%zz %a' 
    
  	--dateu=JPday(dateu,t)
  	
  	datestring = os.date(dateu, t)
  	date =string.gsub(date, "%%ISO",datestring)
  end
  
  date=JPday(date,t)

  return os.date(date)
end

function set_time_text()
	local text = parse_jp_era(format_string)  --os.date(format_string)
		  --text = tostring(get_timezone()/3600) 
		  --text = tostring(get_timezone()%60)
		  --text = os.time()  					--2020-02-18 21:27:05 utc0  ostime+13,off+9でJST
		  --text = os.time()+ get_timezone()  	--2020-02-19 10:48:47 utc0
		  --text = os.time(os.date("!*t", now)) --2020-02-18 08:27:59 utc0 
		  --text = os.time{year = 2020, month = 2, day = 25, hour = 21}        --2020-02-25 08:00:00 utc0
		  --text = os.time{year = 2020, month = 2, day = 25, hour = 21} -3600*9  --2020-02-24 22:00:00 utc0
		  --text = os.time{year = 2020, month = 2, day = 25, hour = 21}+ get_timezone() --2020-02-25 21:00:00 utc0
		  --text = os.time{year = 2020, month = 2, day = 25, hour = 21}+ get_timezone()-3600*9  --2020-02-25 12:00:00 utc0
		 
		
	if text ~= last_text then
		local source = obs.obs_get_source_by_name(source_name)
		if source ~= nil then
			local settings = obs.obs_data_create()
			obs.obs_data_set_string(settings, "text", text)
			obs.obs_source_update(source, settings)
			obs.obs_data_release(settings)
			obs.obs_source_release(source)
		end
	end
	
	last_text = text
end

function timer_callback()
	set_time_text()
end

function activate(activating)
	if activated == activating then
		return
	end

	activated = activating

	if activating then
		set_time_text()
		obs.timer_add(timer_callback, 1000)
	else
		obs.timer_remove(timer_callback)
	end
end

-- Called when a source is activated/deactivated
function activate_signal(cd, activating)
	local source = obs.calldata_source(cd, "source")
	if source ~= nil then
		local name = obs.obs_source_get_name(source)
		if (name == source_name) then
			activate(activating)
		end
	end
end

function source_activated(cd)
	activate_signal(cd, true)
end

function source_deactivated(cd)
	activate_signal(cd, false)
end

function reset(pressed)
	if not pressed then
		return
	end

	activate(false)
	local source = obs.obs_get_source_by_name(source_name)
	if source ~= nil then
		local active = obs.obs_source_active(source)
		obs.obs_source_release(source)
		activate(active)
	end
end

----------------------------------------------------------

-- A function named script_properties defines the properties that the user
-- can change for the entire script module itself
function script_properties()
	local props = obs.obs_properties_create()

	local p = obs.obs_properties_add_list(props, "source", "Text Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
	local sources = obs.obs_enum_sources()
	if sources ~= nil then
		for _, source in ipairs(sources) do
			source_id = obs.obs_source_get_id(source)
			if source_id == "text_gdiplus" or source_id == "text_ft2_source" then
				local name = obs.obs_source_get_name(source)
				obs.obs_property_list_add_string(p, name, name)
			end
		end
	end
	obs.source_list_release(sources)

	obs.obs_properties_add_text(props, "format_string", "Format String", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_float(props, "UTC", "WorldTime UTC-14～+14(%UTC)", -14, 14, 1)
	obs.obs_properties_add_int(props, "IMAS", "げむDB", 1, #imas, 1)
	obs.obs_properties_add_text(props, "im", "ぼかろげむめい", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_int(props, "IMSERIES", "ぼかろDB選択", 1, 3, 1)
	obs.obs_properties_add_text(props, "cg", "1.ぷろせか", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_text(props, "ml", "2.ぼかろ", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_text(props, "sm", "3.記念", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_int(props, "DAYLIM", "誕生日何日以内全部", 0, 7, 1)
	return props
end

-- A function named script_description returns the description shown to
-- the user
function script_description()
	return "Sets a text source to act as a date/time text when the source is active.\n\nMade by Ragowit"
end

function findidol(sel,s)
local st=imasb[sel]
local stlen=tonumber(#st)

if(sel=="proseka")then
for i=1,stlen do
if((imasb["proseka"][i][2]..imasb["proseka"][i][3]):match(s))then
return i
end
end
end

if(sel=="vocalo")then
for i=1,stlen do
if((imasb["vocalo"][i][2]..imasb["vocalo"][i][3]):match(s))then
return i
end
end
end

if(sel=="kinen")then
for i=1,stlen do
if((imasb["kinen"][i][2]..imasb["kinen"][i][3]):match(s))then
return i
end
end
end



	return 1
end

function MMDD(dt)
return os.date("!%m/%d",parse_json_date_utc(dt)+9*3600)
end

function findday()
daystring =""
local birthst={}
local daycalc=tonumber(daylim)
local stlen=tonumber(#imas)

local theyear=os.date("!%Y",os.time()+9*3600)
local theyearn=theyear*1+1

debugtxt1=string.gsub(imas[15][2], "^(%d+)",theyear)

for i=1,stlen do
local birth=imas[i][2]
if(birth:match("([Z%+])(%d?%d?):?(%d?%d?)$")) then
local tmp=string.gsub(imas[i][2], "^(%d+)",theyear)
local tmp2=string.gsub(imas[i][2], "^(%d+)",theyearn)
local t=lefttime(tmp)
local tt=lefttime(tmp2)
local name=imas[i][1] .."("..imas[i][3]..")"
local namen=imas[i][1] ..imas[i][2]
t=math.ceil(t/3600/24);
tt=math.ceil(tt/3600/24);
if((t>=0 and t<=daycalc) or (tt>=0 and tt<=daycalc))then
tmp =MMDD(birth).." あと".. math.abs(t).."日 "
if(t<0)then
tmp =MMDD(birth).." あと".. math.abs(tt).."日 "
end
tmp = tmp .. name.."\r\n"
birthst[namen]=tmp
end
end
end

stlen=tonumber(#imasb["proseka"])
for i=1,stlen do
local birth=imasb["proseka"][i][1]
local idol=imasb["proseka"][i][2]
if(birth:match("([Z%+])(%d?%d?):?(%d?%d?)$")) then
local tmp=string.gsub(birth, "^(%d+)",theyear)
local tmp2=string.gsub(birth, "^(%d+)",theyearn)
local t=lefttime(tmp)
local tt=lefttime(tmp2)
t=math.ceil(t/3600/24);
tt=math.ceil(tt/3600/24);
if((t>=0 and t<=daycalc) or (tt>=0 and tt<=daycalc))then
tmp =MMDD(birth).." あと".. math.abs(t).."日 "
if(t<0)then
tmp =MMDD(birth).." あと".. math.abs(tt).."日 "
end
tmp = tmp .. idol.."\r\n"
birthst[idol]=tmp
end
end
end

stlen=tonumber(#imasb["vocalo"])
for i=1,stlen do
local birth=imasb["vocalo"][i][1]
local idol=imasb["vocalo"][i][2]
if(birth:match("([Z%+])(%d?%d?):?(%d?%d?)$")) then
local tmp=string.gsub(birth, "^(%d+)",theyear)
local tmp2=string.gsub(birth, "^(%d+)",theyearn)
local t=lefttime(tmp)
local tt=lefttime(tmp2)
t=math.ceil(t/3600/24);
tt=math.ceil(tt/3600/24);
if((t>=0 and t<=daycalc) or (tt>=0 and tt<=daycalc))then
tmp =MMDD(birth).." あと".. math.abs(t).."日 "
if(t<0)then
tmp =MMDD(birth).." あと".. math.abs(tt).."日 "
end
tmp = tmp .. idol.."\r\n"
birthst[idol]=tmp
end
end
end

stlen=tonumber(#imasb["kinen"])
for i=1,stlen do
local birth=imasb["kinen"][i][1]
local idol=imasb["kinen"][i][2]
if(birth:match("([Z%+])(%d?%d?):?(%d?%d?)$")) then
local tmp=string.gsub(birth, "^(%d+)",theyear)
local tmp2=string.gsub(birth, "^(%d+)",theyearn)
local t=lefttime(tmp)
local tt=lefttime(tmp2)
t=math.ceil(t/3600/24);
tt=math.ceil(tt/3600/24);
if((t>=0 and t<=daycalc) or (tt>=0 and tt<=daycalc))then
tmp =MMDD(birth).." あと".. math.abs(t).."日 "
if(t<0)then
tmp =MMDD(birth).." あと".. math.abs(tt).."日 "
end
tmp = tmp .. idol.."\r\n"
birthst[idol]=tmp
end
end
end


local tkeys = {}
-- populate the table that holds the keys
for k in pairs(birthst) do
table.insert(tkeys, birthst[k])
end
-- sort the keys
table.sort(tkeys)

for i=1,#tkeys do
   daystring=daystring .. tkeys[i]
end

daychange =  JSTday()
	return 1
end

function table.to_qs(arg)
	local qs = {}
	for key, value in pairs(arg) do
		table.insert(qs, key .. "=" .. tostring(value):urlencode())
	end
	return "?" .. table.concat(qs, "&")
end

function cut_string(s,max)
if(#s>=max)then
s = s:sub(1,max)
end

return s
end

-- A function named script_update will be called when settings are changed
function script_update(settings)
	activate(false)

	source_name = obs.obs_data_get_string(settings, "source")
	format_string = cut_string(obs.obs_data_get_string(settings, "format_string"),100)
	utc           = obs.obs_data_get_double(settings, "UTC")
	ima           = obs.obs_data_get_int(settings, "IMAS")
	obs.obs_data_set_string(settings, "im",imas[ima][1]..imas[ima][3])
	imass           = obs.obs_data_get_int(settings, "IMSERIES")
	daylim           = obs.obs_data_get_int(settings, "DAYLIM")
	cgn =findidol("proseka",cut_string(obs.obs_data_get_string(settings, "cg"),20))
	mln =findidol("vocalo",cut_string(obs.obs_data_get_string(settings, "ml"),20))
	smn =findidol("kinen",cut_string(obs.obs_data_get_string(settings, "sm"),20))
	local inum={cgn,mln,smn,scn,dsn}
	useidol=inum[imass]
	findday()
	
	reset(true)
end

-- A function named script_defaults will be called to set the default settings
function script_defaults(settings)
	obs.obs_data_set_default_string(settings, "format_string", "%Y/%m/%d(%Jw)%X(UTC%z)") --"%Y-%m-%d %X")
	obs.obs_data_set_default_double(settings, "UTC", 9)
	obs.obs_data_set_default_int(settings, "IMAS", 18)
	obs.obs_data_set_default_string(settings, "im",imas[1][1]..imas[1][3])
	obs.obs_data_set_default_int(settings, "IMSERIES", 1)
	obs.obs_data_set_default_string(settings, "ml","初音ミク")
	obs.obs_data_set_default_string(settings, "cg","初音ミク")
	obs.obs_data_set_default_string(settings, "sm","ミクの日")
	obs.obs_data_set_default_int(settings, "DAYLIM", 2)
end

-- a function named script_load will be called on startup
function script_load(settings)
	-- Connect activation/deactivation signal callbacks
	--
	-- NOTE: These particular script callbacks do not necessarily have to
	-- be disconnected, as callbacks will automatically destroy themselves
	-- if the script is unloaded.  So there's no real need to manually
	-- disconnect callbacks that are intended to last until the script is
	-- unloaded.
	local sh = obs.obs_get_signal_handler()
	obs.signal_handler_connect(sh, "source_activate", source_activated)
	obs.signal_handler_connect(sh, "source_deactivate", source_deactivated)
end



--JSONparser


local json = { _version = "0.1.2" }

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

local encode

local escape_char_map = {
  [ "\\" ] = "\\",
  [ "\"" ] = "\"",
  [ "\b" ] = "b",
  [ "\f" ] = "f",
  [ "\n" ] = "n",
  [ "\r" ] = "r",
  [ "\t" ] = "t",
}

local escape_char_map_inv = { [ "/" ] = "/" }
for k, v in pairs(escape_char_map) do
  escape_char_map_inv[v] = k
end


local function escape_char(c)
  return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
end


local function encode_nil(val)
  return "null"
end


local function encode_table(val, stack)
  local res = {}
  stack = stack or {}

  -- Circular reference?
  if stack[val] then error("circular reference") end

  stack[val] = true

  if rawget(val, 1) ~= nil or next(val) == nil then
    -- Treat as array -- check keys are valid and it is not sparse
    local n = 0
    for k in pairs(val) do
      if type(k) ~= "number" then
        error("invalid table: mixed or invalid key types")
      end
      n = n + 1
    end
    if n ~= #val then
      error("invalid table: sparse array")
    end
    -- Encode
    for i, v in ipairs(val) do
      table.insert(res, encode(v, stack))
    end
    stack[val] = nil
    return "[" .. table.concat(res, ",") .. "]"

  else
    -- Treat as an object
    for k, v in pairs(val) do
      if type(k) ~= "string" then
        error("invalid table: mixed or invalid key types")
      end
      table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
    end
    stack[val] = nil
    return "{" .. table.concat(res, ",") .. "}"
  end
end


local function encode_string(val)
  return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
end


local function encode_number(val)
  -- Check for NaN, -inf and inf
  if val ~= val or val <= -math.huge or val >= math.huge then
    error("unexpected number value '" .. tostring(val) .. "'")
  end
  return string.format("%.14g", val)
end


local type_func_map = {
  [ "nil"     ] = encode_nil,
  [ "table"   ] = encode_table,
  [ "string"  ] = encode_string,
  [ "number"  ] = encode_number,
  [ "boolean" ] = tostring,
}


encode = function(val, stack)
  local t = type(val)
  local f = type_func_map[t]
  if f then
    return f(val, stack)
  end
  error("unexpected type '" .. t .. "'")
end


function json.encode(val)
  return ( encode(val) )
end


-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------

local parse

local function create_set(...)
  local res = {}
  for i = 1, select("#", ...) do
    res[ select(i, ...) ] = true
  end
  return res
end

local space_chars   = create_set(" ", "\t", "\r", "\n")
local delim_chars   = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
local escape_chars  = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals      = create_set("true", "false", "null")

local literal_map = {
  [ "true"  ] = true,
  [ "false" ] = false,
  [ "null"  ] = nil,
}


local function next_char(str, idx, set, negate)
  for i = idx, #str do
    if set[str:sub(i, i)] ~= negate then
      return i
    end
  end
  return #str + 1
end


local function decode_error(str, idx, msg)
  local line_count = 1
  local col_count = 1
  for i = 1, idx - 1 do
    col_count = col_count + 1
    if str:sub(i, i) == "\n" then
      line_count = line_count + 1
      col_count = 1
    end
  end
  error( string.format("%s at line %d col %d", msg, line_count, col_count) )
end


local function codepoint_to_utf8(n)
  -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
  local f = math.floor
  if n <= 0x7f then
    return string.char(n)
  elseif n <= 0x7ff then
    return string.char(f(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
  elseif n <= 0x10ffff then
    return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
                       f(n % 4096 / 64) + 128, n % 64 + 128)
  end
  error( string.format("invalid unicode codepoint '%x'", n) )
end


local function parse_unicode_escape(s)
  local n1 = tonumber( s:sub(1, 4),  16 )
  local n2 = tonumber( s:sub(7, 10), 16 )
   -- Surrogate pair?
  if n2 then
    return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
  else
    return codepoint_to_utf8(n1)
  end
end


local function parse_string(str, i)
  local res = ""
  local j = i + 1
  local k = j

  while j <= #str do
    local x = str:byte(j)

    if x < 32 then
      decode_error(str, j, "control character in string")

    elseif x == 92 then -- `\`: Escape
      res = res .. str:sub(k, j - 1)
      j = j + 1
      local c = str:sub(j, j)
      if c == "u" then
        local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                 or str:match("^%x%x%x%x", j + 1)
                 or decode_error(str, j - 1, "invalid unicode escape in string")
        res = res .. parse_unicode_escape(hex)
        j = j + #hex
      else
        if not escape_chars[c] then
          decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
        end
        res = res .. escape_char_map_inv[c]
      end
      k = j + 1

    elseif x == 34 then -- `"`: End of string
      res = res .. str:sub(k, j - 1)
      return res, j + 1
    end

    j = j + 1
  end

  decode_error(str, i, "expected closing quote for string")
end


local function parse_number(str, i)
  local x = next_char(str, i, delim_chars)
  local s = str:sub(i, x - 1)
  local n = tonumber(s)
  if not n then
    decode_error(str, i, "invalid number '" .. s .. "'")
  end
  return n, x
end


local function parse_literal(str, i)
  local x = next_char(str, i, delim_chars)
  local word = str:sub(i, x - 1)
  if not literals[word] then
    decode_error(str, i, "invalid literal '" .. word .. "'")
  end
  return literal_map[word], x
end


local function parse_array(str, i)
  local res = {}
  local n = 1
  i = i + 1
  while 1 do
    local x
    i = next_char(str, i, space_chars, true)
    -- Empty / end of array?
    if str:sub(i, i) == "]" then
      i = i + 1
      break
    end
    -- Read token
    x, i = parse(str, i)
    res[n] = x
    n = n + 1
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "]" then break end
    if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
  end
  return res, i
end


local function parse_object(str, i)
  local res = {}
  i = i + 1
  while 1 do
    local key, val
    i = next_char(str, i, space_chars, true)
    -- Empty / end of object?
    if str:sub(i, i) == "}" then
      i = i + 1
      break
    end
    -- Read key
    if str:sub(i, i) ~= '"' then
      decode_error(str, i, "expected string for key")
    end
    key, i = parse(str, i)
    -- Read ':' delimiter
    i = next_char(str, i, space_chars, true)
    if str:sub(i, i) ~= ":" then
      decode_error(str, i, "expected ':' after key")
    end
    i = next_char(str, i + 1, space_chars, true)
    -- Read value
    val, i = parse(str, i)
    -- Set
    res[key] = val
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "}" then break end
    if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
  end
  return res, i
end


local char_func_map = {
  [ '"' ] = parse_string,
  [ "0" ] = parse_number,
  [ "1" ] = parse_number,
  [ "2" ] = parse_number,
  [ "3" ] = parse_number,
  [ "4" ] = parse_number,
  [ "5" ] = parse_number,
  [ "6" ] = parse_number,
  [ "7" ] = parse_number,
  [ "8" ] = parse_number,
  [ "9" ] = parse_number,
  [ "-" ] = parse_number,
  [ "t" ] = parse_literal,
  [ "f" ] = parse_literal,
  [ "n" ] = parse_literal,
  [ "[" ] = parse_array,
  [ "{" ] = parse_object,
}


parse = function(str, idx)
  local chr = str:sub(idx, idx)
  local f = char_func_map[chr]
  if f then
    return f(str, idx)
  end
  decode_error(str, idx, "unexpected character '" .. chr .. "'")
end


function json.decode(str)
  if type(str) ~= "string" then
    error("expected argument of type string, got " .. type(str))
  end
  local res, idx = parse(str, next_char(str, 1, space_chars, true))
  idx = next_char(str, idx, space_chars, true)
  if idx <= #str then
    decode_error(str, idx, "trailing garbage")
  end
  return res
end


--return json
imasb=json.decode(imasb)