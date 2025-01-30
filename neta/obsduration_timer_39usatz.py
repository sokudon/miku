#original src https://obsproject.com/forum/resources/date-time.906/
#py -m pip install python-dateutil

# 導入手順　https://photos.app.goo.gl/puPDpiXsFb41YjW77
#work on OBS  python312
#2024/07/21　RFC2822だかの形式パース、スパンがゼロのとき例外処理
#2024/07/20　UTCMATERにM$の標準時リストUTC+??を追加  zoneinfoからの全取得コードを追加（デフォは57行コメントアウト）,開始終了時刻がどちらかが未確定のときエラーを減らした
#2024/06/08　ISO8601以外の通常の時刻を変換できるようにした　例:2024/06/08 03:28
#2024/05/21　zoneinfoのデータが2006年前でしかはいってないようなので除外（）
#2024/05/16 開始の変換でzone影響あり　tzdataからpythondateutil　変更
#2024/05/16 ISO8601でのイベントタイマーに改造

import obspython as obs
import datetime
import math
import time
from dateutil import tz
import re

#書式コード	説明	例 ゾーン影響あり
#%Y	西暦（4桁表記。0埋め）	2021
#%m	月（2桁表記。0埋め）	11
#%d	日（2桁表記。0埋め）	04
#%H	時（24時間制。2桁表記。0埋め）	17
#%M	分（2桁表記。0埋め）	37
#%S	秒（2桁表記。0埋め）	28
#%y	西暦の下2桁（0埋め）	21
#%l	AM／PMを表す文字列	PM
#%x	日付をMM/DD/YY形式にしたもの	11/04/21
#%X	時刻をhh:mm:ss形式にしたもの	17:37:28
#%a	曜日の短縮形	Thu
#%A	曜日	Thursday
#%z	現在のタイムゾーンとUTC（協定世界時）とのオフセット	+0900
#%Z	現在のタイムゾーン	JST

##拡張部分 ゾーン影響なし
#OS %OS　　awareなんでタイムゾーンは欠損　time_formatで出力
#JST %JST　　日本時間time_formatで出力　常にGMT＋９
#UTC %UTC　　UTC MASTER  time_formatで出力
#ZULL %ZULL　UTC協定時間 ISO8601
#ISO %ISO　　zone影響あり ISO8601
#
#イベント名:%E
#開始時刻:%ST　zone影響あり
#終了時刻:%EN　zone影響あり
#イベ期間:%SP
#経過時間:%EL
#残り時間:%LF
#進捗状況:%Q %P%%

interval	= 10  #更新間隔0.1秒
source_name = ""
time_string = "%Y/%m/%d %H:%M:%S %z"
time_format = "%Y/%m/%d %H:%M:%S %Z %a"
iso_format = "%Y-%m-%dT%H:%M:%S%z"
zone		="Asia/Tokyo"

# 全てのタイムゾーンを取得を使いたい場合下のコード
#おそらくzoneinfoのインストールが必要　　python -m pip install tzdata
from zoneinfo import available_timezones
zones = sorted(available_timezones())
#zones	   = ["Asia/Tokyo","Asia/Seoul","Asia/Taipei","America/Los_Angeles"]

#https://learn.microsoft.com/ja-jp/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11
#mstz = ["UTC-11:00	UTC-11	協定世界時 - 11","UTC-10:00	ハワイ標準時	ハワイ","UTC-08:00	太平洋標準時	太平洋標準時 (米国およびカナダ)","UTC-07:00	山地標準時	山地標準時 (米国およびカナダ)","UTC-06:00	中部標準時 (メキシコ)	グアダラハラ、メキシコ シティ、モンテレイ","UTC-06:00	中央アメリカ標準時	中央アメリカ","UTC-05:00	東部標準時	東部標準時 (米国およびカナダ)","UTC-05:00	南アメリカ太平洋標準時	ボゴタ、リマ、キト、リオブランコ","UTC-04:30	ベネズエラ標準時	カラカス","UTC-04:00	大西洋標準時	大西洋標準時 (カナダ)","UTC-04:00	南アメリカ西部標準時	ジョージタウン、ラパス、マナウス、サンフアン","UTC-04:00	パラグアイ標準時	アスンシオン","UTC-03:00	太平洋南アメリカ標準時	サンティアゴ","UTC-03:00	南アメリカ東部標準時	カイエンヌ、フォルタレザ","UTC-03:00	モンテビデオ標準時	モンテビデオ","UTC-03:00	グリーンランド標準時	グリーンランド","UTC-03:00	アルゼンチン標準時	ブエノスアイレス","UTC-03:00	E. 南アメリカ標準時	ブラジリア","UTC-02:00	UTC-02	協定世界時 - 02","UTC-01:00	カーボベルデ標準時	カーボベルデ諸島","UTC	モロッコ標準時	カサブランカ","UTC	グリニッジ標準時	モンロビア、レイキャビク","UTC	UTC	協定世界時","UTC	GMT 標準時	ダブリン、エジンバラ、リスボン、ロンドン","UTC+01:00	中央ヨーロッパ標準時	ベオグラード、ブラチスラバ、ブダペスト、リュブリャナ、プラハ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	ロマンス標準時	ブリュッセル、コペンハーゲン、マドリード、パリ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	中央ヨーロッパ標準時	ベオグラード、ブラチスラバ、ブダペスト、リュブリャナ、プラハ","UTC+01:00	ロマンス標準時	ブリュッセル、コペンハーゲン、マドリード、パリ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	ロマンス標準時	ブリュッセル、コペンハーゲン、マドリード、パリ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	ベオグラード、ブラチスラバ、ブダペスト、リュブリャナ、プラハ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	ナミビア標準時	ウィントフック","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	ベオグラード、ブラチスラバ、ブダペスト、リュブリャナ、プラハ","UTC+01:00	ロマンス標準時	ブリュッセル、コペンハーゲン、マドリード、パリ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	E. ヨーロッパ標準時	E. 欧州","UTC+02:00	エジプト標準時	Cairo","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	GTB 標準時	アテネ、ブカレスト","UTC+02:00	イスラエル標準時	中東","UTC+02:00	ヨルダン標準時	アンマン","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	中東標準時	ベイルート","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	E. ヨーロッパ標準時	E. 欧州","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	GTB 標準時	アテネ、ブカレスト","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	エジプト標準時	Cairo","UTC+02:00	GTB 標準時	アテネ、ブカレスト","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	シリア標準時	ダマスカス","UTC+02:00	Türkiye 標準時	イスタンブール","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:00	ベラルーシ標準時	ミンスク","UTC+03:00	E. アフリカ標準時	ナイロビ","UTC+03:00	アラビック標準時	バグダッド","UTC+03:00	E. アフリカ標準時	ナイロビ","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:00	E. アフリカ標準時	ナイロビ","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:00	ロシア標準時	モスクワ、サンクトペテルブルク、ボルゴグラード (RTZ 2)","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:00	E. アフリカ標準時	ナイロビ","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:30	イラン標準時	テヘラン","UTC+04:00	コーカサス標準時	エレバン","UTC+04:00	アゼルバイジャン標準時	バクー","UTC+04:00	ジョージア標準時	トビリシ","UTC+04:00	モーリシャス標準時	ポートルイス","UTC+04:00	アラビア標準時	アブダビ、マスカット","UTC+04:00	モーリシャス標準時	ポートルイス","UTC+04:00	アラビア標準時	アブダビ、マスカット","UTC+04:30	アフガニスタン標準時	カブール","UTC+05:00	西アジア標準時	アシハバード、タシケント","UTC+05:00	パキスタン標準時	イスラマバード、カラチ","UTC+05:00	西アジア標準時	アシハバード、タシケント","UTC+05:30	インド標準時	チェンナイ、コルカタ、ムンバイ、ニューデリー","UTC+05:30	スリランカ標準時	スリジャヤワルダナプラコッテ","UTC+05:45	ネパール標準時	カトマンズ","UTC+06:00	バングラデシュ標準時	ダッカ","UTC+06:00	中央アジア標準時	アスタナ","UTC+06:30	ミャンマー標準時	ヤンゴン (ラングーン)","UTC+07:00	東南アジア標準時	バンコク、ハノイ、ジャカルタ","UTC+08:00	シンガポール標準時	クアラルンプール、シンガポール","UTC+08:00	中国標準時	北京、重慶、香港特別行政区、ウルムチ","UTC+08:00	シンガポール標準時	クアラルンプール、シンガポール","UTC+08:00	ウランバートル標準時	ウランバートル","UTC+08:00	シンガポール標準時	クアラルンプール、シンガポール","UTC+08:00	台北標準時	台北","UTC+09:00	東京標準時	大阪、札幌、東京","UTC+09:00	韓国標準時	ソウル","UTC+09:00	東京標準時	大阪、札幌、東京","UTC+10:00	オーストラリア東部標準時	キャンベラ、メルボルン、シドニー","UTC+10:00	西太平洋標準時	グアム、ポートモレスビー","UTC+11:00	中央太平洋標準時	ソロモン諸島、ニューカレドニア","UTC+12:00	フィジー標準時	フィジー","UTC+12:00	UTC+12	協定世界時 + 12","UTC+12:00	ニュージーランド標準時	オークランド、ウェリントン","UTC+12:00	UTC+12	協定世界時 + 12","UTC+13:00	サモア標準時	サモア","UTC+13:00	トンガ標準時	ヌクアロファ"]
mstz =["UTC-11:00	UTC-11	Coordinated Universal Time-11","UTC-10:00	Hawaiian Standard Time	Hawaii","UTC-08:00	Pacific Standard Time	Pacific Time (US & Canada)","UTC-07:00	Mountain Standard Time	Mountain Time (US & Canada)","UTC-06:00	Central Standard Time (Mexico)	Guadalajara, Mexico City, Monterrey","UTC-06:00	Central America Standard Time	Central America","UTC-05:00	SA Pacific Standard Time	Bogota, Lima, Quito, Rio Branco","UTC-05:00	Eastern Standard Time	Eastern Time (US & Canada)","UTC-04:30	Venezuela Standard Time	Caracas","UTC-04:00	SA Western Standard Time	Georgetown, La Paz, Manaus, San Juan","UTC-04:00	Paraguay Standard Time	Asuncion","UTC-04:00	Atlantic Standard Time	Atlantic Time (Canada)","UTC-03:00	SA Eastern Standard Time	Cayenne, Fortaleza","UTC-03:00	Pacific SA Standard Time	Santiago","UTC-03:00	Montevideo Standard Time	Montevideo","UTC-03:00	Greenland Standard Time	Greenland","UTC-03:00	E. South America Standard Time	Brasilia","UTC-03:00	Argentina Standard Time	City of Buenos Aires","UTC-02:00	UTC-02	Coordinated Universal Time-02","UTC-01:00	Cape Verde Standard Time	Cabo Verde Is.","UTC	GMT Standard Time	Dublin, Edinburgh, Lisbon, London","UTC	Greenwich Standard Time	Monrovia, Reykjavik","UTC	Morocco Standard Time	Casablanca","UTC	UTC	Coordinated Universal Time","UTC+01:00	Central Europe Standard Time	Belgrade, Bratislava, Budapest, Ljubljana, Prague","UTC+01:00	Central European Standard Time	Sarajevo, Skopje, Warsaw, Zagreb","UTC+01:00	Namibia Standard Time	Windhoek","UTC+01:00	Romance Standard Time	Brussels, Copenhagen, Madrid, Paris","UTC+01:00	W. Central Africa Standard Time	West Central Africa","UTC+01:00	W. Europe Standard Time	Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna","UTC+02:00	E. Europe Standard Time	E. Europe","UTC+02:00	Egypt Standard Time	Cairo","UTC+02:00	FLE Standard Time	Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius","UTC+02:00	GTB Standard Time	Athens, Bucharest","UTC+02:00	Israel Standard Time	Middle East","UTC+02:00	Jordan Standard Time	Amman","UTC+02:00	Middle East Standard Time	Beirut","UTC+02:00	South Africa Standard Time	Harare, Pretoria","UTC+02:00	Syria Standard Time	Damascus","UTC+02:00	Türkiye Standard Time	Istanbul","UTC+03:00	Arab Standard Time	Kuwait, Riyadh","UTC+03:00	Arabic Standard Time	Baghdad","UTC+03:00	Belarus Standard Time	Minsk","UTC+03:00	E. Africa Standard Time	Nairobi","UTC+03:00	Russian Standard Time	Moscow, St. Petersburg, Volgograd (RTZ 2)","UTC+03:30	Iran Standard Time	Tehran","UTC+04:00	Arabian Standard Time	Abu Dhabi, Muscat","UTC+04:00	Azerbaijan Standard Time	Baku","UTC+04:00	Caucasus Standard Time	Yerevan","UTC+04:00	Georgian Standard Time	Tbilisi","UTC+04:00	Mauritius Standard Time	Port Louis","UTC+04:30	Afghanistan Standard Time	Kabul","UTC+05:00	Pakistan Standard Time	Islamabad, Karachi","UTC+05:00	West Asia Standard Time	Ashgabat, Tashkent","UTC+05:30	India Standard Time	Chennai, Kolkata, Mumbai, New Delhi","UTC+05:30	Sri Lanka Standard Time	Sri Jayawardenepura","UTC+05:45	Nepal Standard Time	Kathmandu","UTC+06:00	Bangladesh Standard Time	Dhaka","UTC+06:00	Central Asia Standard Time	Astana","UTC+06:30	Myanmar Standard Time	Yangon (Rangoon)","UTC+07:00	SE Asia Standard Time	Bangkok, Hanoi, Jakarta","UTC+08:00	China Standard Time	Beijing, Chongqing, Hong Kong SAR, Urumqi","UTC+08:00	Singapore Standard Time	Kuala Lumpur, Singapore","UTC+08:00	Taipei Standard Time	Taipei","UTC+08:00	Ulaanbaatar Standard Time	Ulaanbaatar","UTC+09:00	Korea Standard Time	Seoul","UTC+09:00	Tokyo Standard Time	Osaka, Sapporo, Tokyo","UTC+10:00	AUS Eastern Standard Time	Canberra, Melbourne, Sydney","UTC+10:00	West Pacific Standard Time	Guam, Port Moresby","UTC+11:00	Central Pacific Standard Time	Solomon Is., New Caledonia","UTC+12:00	Fiji Standard Time	Fiji","UTC+12:00	New Zealand Standard Time	Auckland, Wellington","UTC+12:00	UTC+12	Coordinated Universal Time+12","UTC+13:00	Samoa Standard Time	Samoa","UTC+13:00	Tonga Standard Time	Nuku'alofa"]



ibe='星雲の窓辺'
st = '2024-04-30T17:00:00+09:00'
en = '2024-05-08T22:00:00+09:00'
obsbar =3
utc =9
JST=""
UTC=""
# Regular expression patterns for the various formats
patterns = [
	r"^\d{4}/\d{2}/\d{2} \d{2}:\d{2}$",		   # YYYY/MM/DD HH:MM
	r"^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$",		   # YYYY/MM/DD HH:MM
	r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$",	  # YYYY-MM-DDTHH:MM:SS
	r"^\d{4}/\d{2}/\d{2}$",						# YYYY/MM/DD
	r"^\d{4}-\d{2}-\d{2}$",						 # YYYY-MM-DD
	r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[\+\-]\d{2}:\d{2})?$",
	r"^(?:(Mon|Tue|Wed|Thu|Fri|Sat|Sun), )?(\d{2}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{4}) (\d{2}):(\d{2})(?::(\d{2}))? ([-+]\d{4}|[A-Z]{1,3})$" ## RFC 2822形式
]


# 月の略称を対応する数値にマッピング
month_mapping = {
	"Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
	"Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12
}

# 使用例
#rfc2822_date = "Tue, 25 Dec 2023 13:45:30 +0900"
#parsed_date = parse_rfc2822(rfc2822_date)
#print(parsed_date)

# RFC 2822の日付文字列をパースする関数
def parse_rfc2822(date_str):
# RFC 2822形式の日付をパースする正規表現
	pattern = re.compile(r'^(?:(Mon|Tue|Wed|Thu|Fri|Sat|Sun), )?(\d{2}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{4}) (\d{2}):(\d{2})(?::(\d{2}))? ([-+]\d{4}|[A-Z]{1,3})$')
	match = pattern.match(date_str)
	if not match:
		raise ValueError("Invalid RFC 2822 date format")

	day, date, month, year, hour, minute, second, offset = match.groups()
	date = int(date)
	month = month_mapping[month]
	year = int(year)
	hour = int(hour)
	minute = int(minute)
	second = int(second) if second else 0
	
	tz_offset=0
	if  offset.startswith(('+', '-')):
		tz_hours = int(offset[1:3])
		tz_minutes = int(offset[3:5])
		tz_offset = tz_hours+tz_minutes/60
		if offset.startswith('-'):
			tz_offset = -tz_offset

	t_delta = datetime.timedelta(hours=tz_offset)
	rfc = datetime.timezone(t_delta, 'RFC') 
	# datetimeオブジェクトを作成
	dt =  datetime.datetime(year, month, date, hour, minute, second, tzinfo=rfc)

	return dt.isoformat()

def dtime(dt):
	if dt<0:
			return "0日0時間0分"
	dt=abs(dt)
	seconds  = math.floor((dt / 10) % 60)
	minutes  = math.floor((dt / 60) % 60)
	hours	= math.floor((dt / 3600) % 24)
	days	 = math.floor(dt / 86400)
	tmp = str(days) +"日" +str(hours)+"時間"+str(minutes) +"分"
	return tmp


def makebar(p):
	global obsbar
	
	base ="="
	q=obsbar
	
	p=p/q
	
	p=math.floor(p)
	s=""
	
	for i in range(p):
		s= s + base
		
	s=s+">"
	
	q=math.floor(100/q)
	for i in range(p+1,q, 1):
		s= s +"_"

	bar = "["+s+"]"
	return bar


def update_text():
	global interval
	global source_name
	global time_string
	global time_format
	global zone
	global ibe
	global st
	global en
	global iso_format
	global UTC
	global JST
	
	# 変換前後のタイムゾーンを指定
	cv_tz = tz.gettz(zone)
	temp=time_string
	nn=time.time()
	if(st != "----"):
		stt  = datetime.datetime.fromisoformat(st)
		stt = stt.astimezone(cv_tz)
		ts = stt.strftime(time_format)
		sttmp=stt.timestamp()
		stt=datetime.datetime.fromtimestamp(sttmp)
		elapsed=dtime(nn-sttmp)
		temp=temp.replace('%ST',ts)
		temp=temp.replace('%EL',elapsed)
	else:
		temp=temp.replace('%EL',"----")
		temp=temp.replace('%ST',"----")
	
	if(en != "----"):
		ent  = datetime.datetime.fromisoformat(en)
		ent = ent.astimezone(cv_tz)
		te = ent.strftime(time_format)
		entmp=ent.timestamp()
		ent=datetime.datetime.fromtimestamp(entmp)
		left= dtime(entmp-nn)
		temp=temp.replace('%EN',te)
		temp=temp.replace('%LF',left)
		if(st != "----"):
			if(entmp-sttmp !=0):
				x = (nn-sttmp)/abs(entmp-sttmp)*100
				n = 2
				y = math.floor(x * 10 ** n) / (10 ** n)
				if y>100:
					 y=100
				if y<0:
					 y=0
				bar=makebar(y)
				span=dtime(entmp-sttmp)
				#span= abs(ent-stt)
				temp=temp.replace('%SP',str(span))
				temp=temp.replace('%Q',bar)
				temp=temp.replace('%P',str(y))
	else:
		temp=temp.replace('%EN',"----")
		temp=temp.replace('%LF',"----")

	temp=temp.replace('%E',ibe)
	temp=temp.replace('%OS',datetime.datetime.now(tz=None).strftime(time_format))
	temp=temp.replace('%JST',datetime.datetime.now(JST).strftime(time_format))
	temp=temp.replace('%UTC',datetime.datetime.now(UTC).strftime(time_format))
	temp=temp.replace('%ZULL',datetime.datetime.now(datetime.timezone.utc).strftime(iso_format))
	temp=temp.replace('%ISO',datetime.datetime.now().astimezone(cv_tz).strftime(iso_format))
	temp=re.sub('%(P|Q|SP)', '----', temp)

	source = obs.obs_get_source_by_name(source_name)
	if source is not None:
		settings = obs.obs_data_create()
		now = datetime.datetime.now()
		now=now.astimezone(cv_tz)
		obs.obs_data_set_string(settings, "text", now.strftime(temp))
		obs.obs_source_update(source, settings)
		obs.obs_data_release(settings)
		obs.obs_source_release(source)

def refresh_pressed(props, prop):
	update_text()

# ------------------------------------------------------------

def script_description():
	return "Updates a text source to the current date and time"

def script_defaults(settings):
	obs.obs_data_set_default_int(settings, "interval", interval)
	obs.obs_data_set_default_string(settings, "utc","UTC")
	obs.obs_data_set_default_string(settings, "format", time_string)
	obs.obs_data_set_default_string(settings, "time_format", time_format)
	obs.obs_data_set_default_string(settings, "zone", zone )
	obs.obs_data_set_default_string(settings, "eve", ibe)
	obs.obs_data_set_default_string(settings, "start", st)
	obs.obs_data_set_default_string(settings, "end", en)
	obs.obs_data_set_default_int(settings, "bar", obsbar)

def script_properties():
	props = obs.obs_properties_create()

	obs.obs_properties_add_int(props, "interval", "Update Interval (seconds)", 1, 3600, 1)


	# Add sources select dropdown
	p = obs.obs_properties_add_list(props, "source", "Text Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)

	# Make a list of all the text sources
	obs.obs_property_list_add_string(p, "[No text source]", "[No text source]")
	
	sources = obs.obs_enum_sources()

	if sources is not None:
		for source in sources:
			name = obs.obs_source_get_name(source)
			source_id = obs.obs_source_get_unversioned_id(source)
			if source_id == "text_gdiplus" or source_id == "text_ft2_source":
				name = obs.obs_source_get_name(source)
				obs.obs_property_list_add_string(p, name, name)
		obs.source_list_release(sources)

	mstime_zone_list = obs.obs_properties_add_list(
		props, "utc", "UTC MASTER", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING
	)

	for mszone in mstz:
		obs.obs_property_list_add_string(mstime_zone_list, mszone, mszone)
		
		
	time_zone_list = obs.obs_properties_add_list(
		props, "zone", "Time zone", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING
	)

	for timezone in zones:
		obs.obs_property_list_add_string(time_zone_list, timezone, timezone)
	
	obs.obs_properties_add_text(props, "format", "time_string", obs.OBS_TEXT_MULTILINE) 
	obs.obs_properties_add_text(props, "time_format", "time_format", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_text(props, "eve", "EVENT", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_text(props, "start", "START", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_text(props, "end", "END", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_int(props, "bar", "BAR LENGTH(100÷X)", 1, 10, 1)
	
	obs.obs_properties_add_button(props, "button", "Refresh", refresh_pressed)
	return props

def normalize_time(input_time_str):
	iso8601_time=parse_datetime(input_time_str)
	if iso8601_time is not None: # Check if iso8601_time is not None
		iso8601_time =iso8601_time.isoformat()
		return iso8601_time
	else:
		return "----" # Return an error message if parsing fails

def parse_datetime(datetime_str):
	datetime_str=re.sub(" +"," ",datetime_str.strip())
	for pattern in patterns:
		if re.match(pattern, datetime_str):
			try:
				if pattern == patterns[0]:
					return datetime.datetime.strptime(datetime_str, "%Y/%m/%d %H:%M")
				elif pattern == patterns[1]:
					return datetime.datetime.strptime(datetime_str, "%Y-%m-%d %H:%M")
				elif pattern == patterns[2]:
					return datetime.datetime.strptime(datetime_str, "%Y-%m-%dT%H:%M:%S")
				elif pattern == patterns[3]:
					return datetime.datetime.strptime(datetime_str, "%Y/%m/%d")
				elif pattern == patterns[4]:
					return datetime.datetime.strptime(datetime_str, "%Y-%m-%d")
				elif pattern == patterns[5]:
					datetime_str=datetime_str.replace('Z', '+00:00')
					return datetime.datetime.fromisoformat(datetime_str) # Call fromisoformat directly on datetime
				elif pattern == patterns[6]:
					dt =parse_rfc2822(datetime_str)
					return datetime.datetime.fromisoformat(dt)
			except ValueError:
				pass
	return None

def script_update(settings):
	global interval
	global source_name
	global time_string
	global time_format
	global zone
	global st
	global en
	global obsbar
	global utc
	global UTC
	global JST
	global ibe
	
	ibe	=obs.obs_data_get_string(settings, "eve")
	utc_string	= obs.obs_data_get_string(settings, "utc")
	interval	= obs.obs_data_get_int(settings, "interval")
	source_name = obs.obs_data_get_string(settings, "source")
	time_string = obs.obs_data_get_string(settings, "format")
	time_format = obs.obs_data_get_string(settings, "time_format")
	zone = obs.obs_data_get_string(settings, "zone")
	st = obs.obs_data_get_string(settings, "start")
	en = obs.obs_data_get_string(settings, "end")
	st = normalize_time(str(st))
	en = normalize_time(str(en))
	obsbar = obs.obs_data_get_int(settings, "bar")
	# 正規表現パターン
	pattern = r"UTC(.)(\d{2}):(\d{2})"
	# 正規表現検索
	match = re.search(pattern, utc_string)
	utc=0
	utc_mstring=""
	if match:
		sign=match.group(1)
		hh = match.group(2)
		mm = match.group(3)
		utc=int(hh)+int(mm)/60
		if sign=="-":
			utc=-utc
		
	t_delta = datetime.timedelta(hours=9)  # 9時間
	JST = datetime.timezone(t_delta, 'JST') 
	t_delta = datetime.timedelta(hours=utc)
	UTC = datetime.timezone(t_delta, utc_string) 
	
	obs.timer_remove(update_text)
	
	if source_name != "":
		obs.timer_add(update_text, interval * 100)
