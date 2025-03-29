-- parse json https://gist.github.com/zwh8800/9b0442efadc97408ffff248bc8573064
-- original timer https://obsproject.com/forum/resources/advanced-timer.637/
-- タイトル%T%n経過時間%K%n残り時間%L%nイベント時間%I%n
-- 現地時間%N%n日本時間%JST%n達成率%P%nS %S%nE %E%nSJ %SJ%nEJ %EJ"
-- 拡張前　旧版残り時間だけのやつ　https://raw.githubusercontent.com/sokudon/deresute/2c8516d114a6500b0ad4e91d31a776f5b5d48891/OBSdere.lua
-- みりした、LIVE Carnival Wish you Happiness！！のイベント時間　現行イベントのみ(event duration) ISO8601 recommanded☆ >>> unix >> localtime(OS)
-- http://sokudon.s17.xrea.com/sekai.html
-- http://sokudon.s17.xrea.com/sekai-dere.html
-- UI ENGLISH MODE view textline, 670
-- parameter https://github.com/sokudon/deresute/wiki/OBS-EVENT-DURATION-TIMER(luascript)
--[[
//全部出しさんぷる
OS時間:%N%n経過時間%K           %t日本時間:%JST  %n残り時間:%L          %t%t開始時間:%SJ%nイベント時間:%I     %t%t終了時間%EJ       %T%P％%n%Q

%T	イベント名・タイトル
%N	現在の時間OS依存、時刻書式可能
%UTC	現在の時間UTC設定、時刻書式可能
%JST	日本時間、時刻書式可能
%TZ	America/Los_AngelesTZ現在 変えたらそのタイムゾーン
%%TZN os.dateをつかわないで時刻表示　%Zが使える
%I	イベント期間、経過残書式対応
%T	タイトル名
%K	経過時間、経過残書式対応
%L	残り時間、経過残書式対応
%P	進捗%
%Q	進捗バー

%SS	America/Los_AngelesTZ開始　変えたらそのタイムゾーン
%SJ	イベント開始日本時間
%SU	イベント開始utcsetteing
%S	イベント開始時間 OS依存
　
%EE	America/Los_AngelesTZ終了　変えたらそのタイムゾーン
%EJ	イベント終了日本時間
%SU	イベント開始utcsetteing
%E	イベント終了時間 OS依存


//時刻書式一覧
%Y-%m-%dT%H:%M:%S%z (%a)　＝＞2020-06-02T01:52:00+0900 (Tue曜日)
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
--%Z タイムゾーン (例 EDT)、あるいはタイムゾーンが決定できないならば無し 　　windowsでは%%TZNのみ対応
--%z timezone,osdateのサマータイム有り 

//経過残書式一覧
%d %hh:%mm:%ss(%hs時,%ds日)＝＞日 時:分:秒(時シリアル,日シリある)

%HH	無限時間、少数切り捨て
%MM	無限分、少数切り捨て
%SS	無限秒、少数切り捨て
%hh	24時間以内の時間、少数切り捨て
%mm	60分以内の分、少数切り捨て
%ss	60秒以内の秒、少数切り捨て
%ds	無限時間、少数3桁
%hs	無限分、少数3桁
%ms	無限秒、少数3桁
%H	tostring(hours_infinite))　無限1桁版
%M	 tostring(minutes_infinite))
%S	 tostring(seconds_infinite))
%d	 tostring(days))　日数、少数切り捨て1桁版
%h	 tostring(hours))　24時間～あとは1桁版
%m	 tostring(minutes))
%s	 tostring(seconds))
%t	 tostring(tenths))　miri秒
]] obs = obslua
source_name = ""
finaltime = ""
starttime = ""
title = ""
para_text = ""
time_text = ""
end_text = ""

total_seconds = 0
total = 0
stop_text = ""
mode = ""
a_mode = ""
format = ""
activated = false
global = false
timer_active = false
minute = 0
hour = 0
utc = 0
debugtxt = ""
debugtxt2 = ""
debugtxt3 = ""
debugtxt4 = ""
timezone = "America/Los_Angeles"
timezone_abbr = {}
timezone_offset = {}
timezone_tradision = {}
obsbar = 1
pst = 0
pstst = 0
psten = 0

ENG = true

-- os.date　にわたすとクラッシュする文字列
format_string_avoid_crash = "%%[EJKLNOPQfikloqsvZ]" -- os.date %z Z works unix,but windows never work()
osdate_avoid_crash = "%%[EJKLNOPQfikloqsvzZ]" -- os.date %z Z works unix,but windows never work()

local tz_abbrs = {
    "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST",
    "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT",
    "PST"
}

local tz_untils = {
    1552212000000, 1572771600000, 1583661600000, 1604221200000, 1615716000000,
    1636275600000, 1647165600000, 1667725200000, 1678615200000, 1699174800000,
    1710064800000, 1730624400000, 1741514400000, 1762074000000, 1772964000000,
    1793523600000, 1805018400000, 1825578000000, 1836468000000, 1857027600000,
    1867917600000, 1888477200000, math.huge
}
local tz_offsets = {
    480, 420, 480, 420, 480, 420, 480, 420, 480, 420, 480, 420, 480, 420, 480,
    420, 480, 420, 480, 420, 480, 420, 480
}
tz_posix_string = nil -- "PST8PDT,M3.2.0,M11.1.0"
parsedTZ = nil
posix_offset = nil
posix_abbr = nil
constant_posix = false -- tz_untilsを無視してposixでのフォールバックをするか
posix_vs_fallback = true -- math.hugeでのposixでのフォールバックをするか
tz_len = tonumber(#tz_offsets) - 1
local tz_idx = 1
local tz_st = ""

-- 2024-03-10 2:00LA zoneparser,this Invalidtime but bisectR is always bigger ,fixed 2024-03-10 3:00PDT
-- 2024-11-03 1:30TZ zoneparser,this ambigous time but bisectR is always bigger ,fixed 2024-11-03 1:30PST
-- three alias can be used, 2024-03-10 2:00{zoneparser}
useTZ = "useTZ"
TZ = "TZ"
town_name = "LA"

-- timezone_strings = {"America/Los_Angeles", "America/New_York","US/Mountain","US/Central","Asia/Seoul","Asia/Hong_Kong","Asia/Taipei","Asia/Tokyo","UTC"}
timezone_strings = {
    "Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa", "Africa/Algiers",
    "Africa/Asmara", "Africa/Asmera", "Africa/Bamako", "Africa/Bangui",
    "Africa/Banjul", "Africa/Bissau", "Africa/Blantyre", "Africa/Brazzaville",
    "Africa/Bujumbura", "Africa/Cairo", "Africa/Casablanca", "Africa/Ceuta",
    "Africa/Conakry", "Africa/Dakar", "Africa/Dar_es_Salaam", "Africa/Djibouti",
    "Africa/Douala", "Africa/El_Aaiun", "Africa/Freetown", "Africa/Gaborone",
    "Africa/Harare", "Africa/Johannesburg", "Africa/Juba", "Africa/Kampala",
    "Africa/Khartoum", "Africa/Kigali", "Africa/Kinshasa", "Africa/Lagos",
    "Africa/Libreville", "Africa/Lome", "Africa/Luanda", "Africa/Lubumbashi",
    "Africa/Lusaka", "Africa/Malabo", "Africa/Maputo", "Africa/Maseru",
    "Africa/Mbabane", "Africa/Mogadishu", "Africa/Monrovia", "Africa/Nairobi",
    "Africa/Ndjamena", "Africa/Niamey", "Africa/Nouakchott",
    "Africa/Ouagadougou", "Africa/Porto-Novo", "Africa/Sao_Tome",
    "Africa/Timbuktu", "Africa/Tripoli", "Africa/Tunis", "Africa/Windhoek",
    "America/Adak", "America/Anchorage", "America/Anguilla", "America/Antigua",
    "America/Araguaina", "America/Argentina/Buenos_Aires",
    "America/Argentina/Catamarca", "America/Argentina/ComodRivadavia",
    "America/Argentina/Cordoba", "America/Argentina/Jujuy",
    "America/Argentina/La_Rioja", "America/Argentina/Mendoza",
    "America/Argentina/Rio_Gallegos", "America/Argentina/Salta",
    "America/Argentina/San_Juan", "America/Argentina/San_Luis",
    "America/Argentina/Tucuman", "America/Argentina/Ushuaia", "America/Aruba",
    "America/Asuncion", "America/Atikokan", "America/Atka", "America/Bahia",
    "America/Bahia_Banderas", "America/Barbados", "America/Belem",
    "America/Belize", "America/Blanc-Sablon", "America/Boa_Vista",
    "America/Bogota", "America/Boise", "America/Buenos_Aires",
    "America/Cambridge_Bay", "America/Campo_Grande", "America/Cancun",
    "America/Caracas", "America/Catamarca", "America/Cayenne", "America/Cayman",
    "America/Chicago", "America/Chihuahua", "America/Ciudad_Juarez",
    "America/Coral_Harbour", "America/Cordoba", "America/Costa_Rica",
    "America/Creston", "America/Cuiaba", "America/Curacao",
    "America/Danmarkshavn", "America/Dawson", "America/Dawson_Creek",
    "America/Denver", "America/Detroit", "America/Dominica", "America/Edmonton",
    "America/Eirunepe", "America/El_Salvador", "America/Ensenada",
    "America/Fort_Nelson", "America/Fort_Wayne", "America/Fortaleza",
    "America/Glace_Bay", "America/Godthab", "America/Goose_Bay",
    "America/Grand_Turk", "America/Grenada", "America/Guadeloupe",
    "America/Guatemala", "America/Guayaquil", "America/Guyana",
    "America/Halifax", "America/Havana", "America/Hermosillo",
    "America/Indiana/Indianapolis", "America/Indiana/Knox",
    "America/Indiana/Marengo", "America/Indiana/Petersburg",
    "America/Indiana/Tell_City", "America/Indiana/Vevay",
    "America/Indiana/Vincennes", "America/Indiana/Winamac",
    "America/Indianapolis", "America/Inuvik", "America/Iqaluit",
    "America/Jamaica", "America/Jujuy", "America/Juneau",
    "America/Kentucky/Louisville", "America/Kentucky/Monticello",
    "America/Knox_IN", "America/Kralendijk", "America/La_Paz", "America/Lima",
    "America/Los_Angeles", "America/Louisville", "America/Lower_Princes",
    "America/Maceio", "America/Managua", "America/Manaus", "America/Marigot",
    "America/Martinique", "America/Matamoros", "America/Mazatlan",
    "America/Mendoza", "America/Menominee", "America/Merida",
    "America/Metlakatla", "America/Mexico_City", "America/Miquelon",
    "America/Moncton", "America/Monterrey", "America/Montevideo",
    "America/Montreal", "America/Montserrat", "America/Nassau",
    "America/New_York", "America/Nipigon", "America/Nome", "America/Noronha",
    "America/North_Dakota/Beulah", "America/North_Dakota/Center",
    "America/North_Dakota/New_Salem", "America/Nuuk", "America/Ojinaga",
    "America/Panama", "America/Pangnirtung", "America/Paramaribo",
    "America/Phoenix", "America/Port-au-Prince", "America/Port_of_Spain",
    "America/Porto_Acre", "America/Porto_Velho", "America/Puerto_Rico",
    "America/Punta_Arenas", "America/Rainy_River", "America/Rankin_Inlet",
    "America/Recife", "America/Regina", "America/Resolute",
    "America/Rio_Branco", "America/Rosario", "America/Santa_Isabel",
    "America/Santarem", "America/Santiago", "America/Santo_Domingo",
    "America/Sao_Paulo", "America/Scoresbysund", "America/Shiprock",
    "America/Sitka", "America/St_Barthelemy", "America/St_Johns",
    "America/St_Kitts", "America/St_Lucia", "America/St_Thomas",
    "America/St_Vincent", "America/Swift_Current", "America/Tegucigalpa",
    "America/Thule", "America/Thunder_Bay", "America/Tijuana",
    "America/Toronto", "America/Tortola", "America/Vancouver", "America/Virgin",
    "America/Whitehorse", "America/Winnipeg", "America/Yakutat",
    "America/Yellowknife", "Antarctica/Casey", "Antarctica/Davis",
    "Antarctica/DumontDUrville", "Antarctica/Macquarie", "Antarctica/Mawson",
    "Antarctica/McMurdo", "Antarctica/Palmer", "Antarctica/Rothera",
    "Antarctica/South_Pole", "Antarctica/Syowa", "Antarctica/Troll",
    "Antarctica/Vostok", "Arctic/Longyearbyen", "Asia/Aden", "Asia/Almaty",
    "Asia/Amman", "Asia/Anadyr", "Asia/Aqtau", "Asia/Aqtobe", "Asia/Ashgabat",
    "Asia/Ashkhabad", "Asia/Atyrau", "Asia/Baghdad", "Asia/Bahrain",
    "Asia/Baku", "Asia/Bangkok", "Asia/Barnaul", "Asia/Beirut", "Asia/Bishkek",
    "Asia/Brunei", "Asia/Calcutta", "Asia/Chita", "Asia/Choibalsan",
    "Asia/Chongqing", "Asia/Chungking", "Asia/Colombo", "Asia/Dacca",
    "Asia/Damascus", "Asia/Dhaka", "Asia/Dili", "Asia/Dubai", "Asia/Dushanbe",
    "Asia/Famagusta", "Asia/Gaza", "Asia/Hanoi", "Asia/Harbin", "Asia/Hebron",
    "Asia/Ho_Chi_Minh", "Asia/Hong_Kong", "Asia/Hovd", "Asia/Irkutsk",
    "Asia/Istanbul", "Asia/Jakarta", "Asia/Jayapura", "Asia/Jerusalem",
    "Asia/Kabul", "Asia/Kamchatka", "Asia/Karachi", "Asia/Kashgar",
    "Asia/Kathmandu", "Asia/Katmandu", "Asia/Khandyga", "Asia/Kolkata",
    "Asia/Krasnoyarsk", "Asia/Kuala_Lumpur", "Asia/Kuching", "Asia/Kuwait",
    "Asia/Macao", "Asia/Macau", "Asia/Magadan", "Asia/Makassar", "Asia/Manila",
    "Asia/Muscat", "Asia/Nicosia", "Asia/Novokuznetsk", "Asia/Novosibirsk",
    "Asia/Omsk", "Asia/Oral", "Asia/Phnom_Penh", "Asia/Pontianak",
    "Asia/Pyongyang", "Asia/Qatar", "Asia/Qostanay", "Asia/Qyzylorda",
    "Asia/Rangoon", "Asia/Riyadh", "Asia/Saigon", "Asia/Sakhalin",
    "Asia/Samarkand", "Asia/Seoul", "Asia/Shanghai", "Asia/Singapore",
    "Asia/Srednekolymsk", "Asia/Taipei", "Asia/Tashkent", "Asia/Tbilisi",
    "Asia/Tehran", "Asia/Tel_Aviv", "Asia/Thimbu", "Asia/Thimphu", "Asia/Tokyo",
    "Asia/Tomsk", "Asia/Ujung_Pandang", "Asia/Ulaanbaatar", "Asia/Ulan_Bator",
    "Asia/Urumqi", "Asia/Ust-Nera", "Asia/Vientiane", "Asia/Vladivostok",
    "Asia/Yakutsk", "Asia/Yangon", "Asia/Yekaterinburg", "Asia/Yerevan",
    "Atlantic/Azores", "Atlantic/Bermuda", "Atlantic/Canary",
    "Atlantic/Cape_Verde", "Atlantic/Faeroe", "Atlantic/Faroe",
    "Atlantic/Jan_Mayen", "Atlantic/Madeira", "Atlantic/Reykjavik",
    "Atlantic/South_Georgia", "Atlantic/St_Helena", "Atlantic/Stanley",
    "Australia/ACT", "Australia/Adelaide", "Australia/Brisbane",
    "Australia/Broken_Hill", "Australia/Canberra", "Australia/Currie",
    "Australia/Darwin", "Australia/Eucla", "Australia/Hobart", "Australia/LHI",
    "Australia/Lindeman", "Australia/Lord_Howe", "Australia/Melbourne",
    "Australia/NSW", "Australia/North", "Australia/Perth",
    "Australia/Queensland", "Australia/South", "Australia/Sydney",
    "Australia/Tasmania", "Australia/Victoria", "Australia/West",
    "Australia/Yancowinna", "Brazil/Acre", "Brazil/DeNoronha", "Brazil/East",
    "Brazil/West", "CET", "CST6CDT", "Canada/Atlantic", "Canada/Central",
    "Canada/Eastern", "Canada/Mountain", "Canada/Newfoundland",
    "Canada/Pacific", "Canada/Saskatchewan", "Canada/Yukon",
    "Chile/Continental", "Chile/EasterIsland", "Cuba", "EET", "EST", "EST5EDT",
    "Egypt", "Eire", "Etc/GMT", "Etc/GMT+0", "Etc/GMT+1", "Etc/GMT+10",
    "Etc/GMT+11", "Etc/GMT+12", "Etc/GMT+2", "Etc/GMT+3", "Etc/GMT+4",
    "Etc/GMT+5", "Etc/GMT+6", "Etc/GMT+7", "Etc/GMT+8", "Etc/GMT+9",
    "Etc/GMT-0", "Etc/GMT-1", "Etc/GMT-10", "Etc/GMT-11", "Etc/GMT-12",
    "Etc/GMT-13", "Etc/GMT-14", "Etc/GMT-2", "Etc/GMT-3", "Etc/GMT-4",
    "Etc/GMT-5", "Etc/GMT-6", "Etc/GMT-7", "Etc/GMT-8", "Etc/GMT-9", "Etc/GMT0",
    "Etc/Greenwich", "Etc/UCT", "Etc/UTC", "Etc/Universal", "Etc/Zulu",
    "Europe/Amsterdam", "Europe/Andorra", "Europe/Astrakhan", "Europe/Athens",
    "Europe/Belfast", "Europe/Belgrade", "Europe/Berlin", "Europe/Bratislava",
    "Europe/Brussels", "Europe/Bucharest", "Europe/Budapest", "Europe/Busingen",
    "Europe/Chisinau", "Europe/Copenhagen", "Europe/Dublin", "Europe/Gibraltar",
    "Europe/Guernsey", "Europe/Helsinki", "Europe/Isle_of_Man",
    "Europe/Istanbul", "Europe/Jersey", "Europe/Kaliningrad", "Europe/Kiev",
    "Europe/Kirov", "Europe/Kyiv", "Europe/Lisbon", "Europe/Ljubljana",
    "Europe/London", "Europe/Luxembourg", "Europe/Madrid", "Europe/Malta",
    "Europe/Mariehamn", "Europe/Minsk", "Europe/Monaco", "Europe/Moscow",
    "Europe/Nicosia", "Europe/Oslo", "Europe/Paris", "Europe/Podgorica",
    "Europe/Prague", "Europe/Riga", "Europe/Rome", "Europe/Samara",
    "Europe/San_Marino", "Europe/Sarajevo", "Europe/Saratov",
    "Europe/Simferopol", "Europe/Skopje", "Europe/Sofia", "Europe/Stockholm",
    "Europe/Tallinn", "Europe/Tirane", "Europe/Tiraspol", "Europe/Ulyanovsk",
    "Europe/Uzhgorod", "Europe/Vaduz", "Europe/Vatican", "Europe/Vienna",
    "Europe/Vilnius", "Europe/Volgograd", "Europe/Warsaw", "Europe/Zagreb",
    "Europe/Zaporozhye", "Europe/Zurich", "Factory", "GB", "GB-Eire", "GMT",
    "GMT+0", "GMT-0", "GMT0", "Greenwich", "HST", "Hongkong", "Iceland",
    "Indian/Antananarivo", "Indian/Chagos", "Indian/Christmas", "Indian/Cocos",
    "Indian/Comoro", "Indian/Kerguelen", "Indian/Mahe", "Indian/Maldives",
    "Indian/Mauritius", "Indian/Mayotte", "Indian/Reunion", "Iran", "Israel",
    "Jamaica", "Japan", "Kwajalein", "Libya", "MET", "MST", "MST7MDT",
    "Mexico/BajaNorte", "Mexico/BajaSur", "Mexico/General", "NZ", "NZ-CHAT",
    "Navajo", "PRC", "PST8PDT", "Pacific/Apia", "Pacific/Auckland",
    "Pacific/Bougainville", "Pacific/Chatham", "Pacific/Chuuk",
    "Pacific/Easter", "Pacific/Efate", "Pacific/Enderbury", "Pacific/Fakaofo",
    "Pacific/Fiji", "Pacific/Funafuti", "Pacific/Galapagos", "Pacific/Gambier",
    "Pacific/Guadalcanal", "Pacific/Guam", "Pacific/Honolulu",
    "Pacific/Johnston", "Pacific/Kanton", "Pacific/Kiritimati",
    "Pacific/Kosrae", "Pacific/Kwajalein", "Pacific/Majuro",
    "Pacific/Marquesas", "Pacific/Midway", "Pacific/Nauru", "Pacific/Niue",
    "Pacific/Norfolk", "Pacific/Noumea", "Pacific/Pago_Pago", "Pacific/Palau",
    "Pacific/Pitcairn", "Pacific/Pohnpei", "Pacific/Ponape",
    "Pacific/Port_Moresby", "Pacific/Rarotonga", "Pacific/Saipan",
    "Pacific/Samoa", "Pacific/Tahiti", "Pacific/Tarawa", "Pacific/Tongatapu",
    "Pacific/Truk", "Pacific/Wake", "Pacific/Wallis", "Pacific/Yap", "Poland",
    "Portugal", "ROC", "ROK", "Singapore", "Turkey", "UCT", "US/Alaska",
    "US/Aleutian", "US/Arizona", "US/Central", "US/East-Indiana", "US/Eastern",
    "US/Hawaii", "US/Indiana-Starke", "US/Michigan", "US/Mountain",
    "US/Pacific", "US/Samoa", "UTC", "Universal", "W-SU", "WET", "Zulu"
}

-- https://grok.com/chat/83e5b2cd-7bdc-4409-b1bb-ad88e3fa31ca
function isWindows()
    -- Windows特有の環境変数 "OS" をチェック
    local osName = os.getenv("OS")
    if osName and osName:lower():find("windows") then
        return true
    else
        return false
    end
end

-- Default TZIF file path (adjust based on your system)
timezone_tzif_path = ""

local username = os.getenv("USERNAME")

-- timezoneのtzifバイナリがあるぱす、ぱいそんのdateutil とかcygwinとかもあるが（）
timezone_tzif_path_suggest_window = {
    script_path() .. "zoneinfo/", -- script_path()はこのスクリプトの場所
    -- windows_timzeon_path =  Windows PowerShellを起動します。 Get-ChildItem Env:
    "C:/Users/" .. username ..
        "/AppData/Local/Programs/Python/Python312/Lib/site-packages/dateutil/zoneinfo/dateutil-zoneinfo.tar/",
    "C:/Users/" .. username ..
        "/AppData//Local/Programs/Python/Python312/Lib/site-packages/pytz/zoneinfo/",
    "C:/Program Files/LibreOffice/program/python-core-3.10.16/lib/site-packages/pytz/zoneinfo/",
    "C:/Program Files/LibreOffice/program/python-core-3.10.16/lib/site-packages/dateutil/zoneinfo/dateutil-zoneinfo.tar/",
    "C:/cygwin64/usr/share/zoneinfo/",
    "C:/Users/" .. username .. "/AppData/Local/Lxss/rootfs/usr/share/zoneinfo/",
    -- "C:/Users/" .. username .. "/AppData/Local/Packages/Ubuntu/LocalState/ext4.vhdx, 仮想イメーじなので未対応（
    -- C:/Users/<YourUsername>/NoxVM/<InstanceName>/NOX.vmdk C:/ProgramData/BlueStacks/Engine/UserData/Data.vdi androidエミュレーターも仮想（）　まあadbde()
    "--those are posix timezone,regacy method--",
    "C:/msys64/usr/share/zoneinfo/", "C:/msys64/usr/share/zoneinfo/posix/",
    "C:/Users/" .. username ..
        "/AppData/Local/Programs/Python/Python312/Lib/site-packages/tzdata/",
    "C:/Program Files/LibreOffice/program/python-core-3.10.16/lib/site-packages/tzdata/"
}

-- Unix-like paths //printenv または envコマンドで環境変数を確認
timezone_tzif_path_suggest_unix = {
    script_path() .. "zoneinfo/", -- script_path()はこのスクリプトの場所
    "/usr/share/zoneinfo/", "/etc/localtime/","/var/db/timezone/",
    "/usr/lib/python312/dist-packages/dateutil/zoneinfo/",
    "/usr/local/lib/python312/dist-packages/dateutil/zoneinfo/",
    "/usr/lib/libreoffice/program/python-core-3.10.16/lib/site-packages/pytz/zoneinfo/",
    "/usr/lib/libreoffice/program/python-core-3.10.16/lib/site-packages/dateutil/zoneinfo/",
    "/Applications/LibreOffice.app/Contents/Resources/python-core-3.10.16/lib/site-packages/pytz/zoneinfo/",
    "/Applications/LibreOffice.app/Contents/Resources/python-core-3.10.16/lib/site-packages/dateutil/zoneinfo/dateutil-zoneinfo.tar/"
}

dateformat = {
    "%X %x", "%X", "%x", "%D %x", "%Y-%m-%dT%H:%M:%S%z (%a)",
    "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M", "%Y-%m-%d %H", "%Y-%m-%d",
    "%m-%d %H:%M:%S%z (%a)", "%m-%d %H:%M:%S", "%m-%d %H:%M", "%m-%d %H",
    "%m-%d", "%H:%M:%S%z (%a)", "%H:%M:%S", "%H:%M", "%p %I:%M %B %d",
    "%p %I:%M", "%c", "%a,%d %b %Y %H:%M:%S %z", "%a,%d %b %Y %H:%M %z",
    "%a,%d %b %Y %H %z", "%d %b %Y %H:%M:%S %z", "%d %b %Y %H:%M %z",
    "%d %b %Y %H %z"
}
-- mstz = {"UTC-11:00	UTC-11	協定世界時 - 11","UTC-10:00	ハワイ標準時	ハワイ","UTC-08:00	太平洋標準時	太平洋標準時 (米国およびカナダ)","UTC-07:00	山地標準時	山地標準時 (米国およびカナダ)","UTC-06:00	中部標準時 (メキシコ)	グアダラハラ、メキシコ シティ、モンテレイ","UTC-06:00	中央アメリカ標準時	中央アメリカ","UTC-05:00	東部標準時	東部標準時 (米国およびカナダ)","UTC-05:00	南アメリカ太平洋標準時	ボゴタ、リマ、キト、リオブランコ","UTC-04:30	ベネズエラ標準時	カラカス","UTC-04:00	大西洋標準時	大西洋標準時 (カナダ)","UTC-04:00	南アメリカ西部標準時	ジョージタウン、ラパス、マナウス、サンフアン","UTC-04:00	パラグアイ標準時	アスンシオン","UTC-03:00	太平洋南アメリカ標準時	サンティアゴ","UTC-03:00	南アメリカ東部標準時	カイエンヌ、フォルタレザ","UTC-03:00	モンテビデオ標準時	モンテビデオ","UTC-03:00	グリーンランド標準時	グリーンランド","UTC-03:00	アルゼンチン標準時	ブエノスアイレス","UTC-03:00	E. 南アメリカ標準時	ブラジリア","UTC-02:00	UTC-02	協定世界時 - 02","UTC-01:00	カーボベルデ標準時	カーボベルデ諸島","UTC	モロッコ標準時	カサブランカ","UTC	グリニッジ標準時	モンロビア、レイキャビク","UTC	UTC	協定世界時","UTC	GMT 標準時	ダブリン、エジンバラ、リスボン、ロンドン","UTC+01:00	中央ヨーロッパ標準時	ベオグラード、ブラチスラバ、ブダペスト、リュブリャナ、プラハ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	ロマンス標準時	ブリュッセル、コペンハーゲン、マドリード、パリ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	中央ヨーロッパ標準時	ベオグラード、ブラチスラバ、ブダペスト、リュブリャナ、プラハ","UTC+01:00	ロマンス標準時	ブリュッセル、コペンハーゲン、マドリード、パリ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	ロマンス標準時	ブリュッセル、コペンハーゲン、マドリード、パリ","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	ベオグラード、ブラチスラバ、ブダペスト、リュブリャナ、プラハ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	ナミビア標準時	ウィントフック","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	サラエボ、スコピエ、ワルシャワ、ザグレブ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	中央ヨーロッパ標準時	ベオグラード、ブラチスラバ、ブダペスト、リュブリャナ、プラハ","UTC+01:00	ロマンス標準時	ブリュッセル、コペンハーゲン、マドリード、パリ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+01:00	西 中央アフリカ標準時	西中央アフリカ","UTC+01:00	西 ヨーロッパ標準時	アムステルダム、ベルリン、ベルン、ローマ、ストックホルム、ウィーン","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	E. ヨーロッパ標準時	E. 欧州","UTC+02:00	エジプト標準時	Cairo","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	GTB 標準時	アテネ、ブカレスト","UTC+02:00	イスラエル標準時	中東","UTC+02:00	ヨルダン標準時	アンマン","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	中東標準時	ベイルート","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	E. ヨーロッパ標準時	E. 欧州","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	GTB 標準時	アテネ、ブカレスト","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	エジプト標準時	Cairo","UTC+02:00	GTB 標準時	アテネ、ブカレスト","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+02:00	シリア標準時	ダマスカス","UTC+02:00	Türkiye 標準時	イスタンブール","UTC+02:00	FLE 標準時	ヘルシンキ、キエフ、リガ、ソフィア、タリン、ビリニュス","UTC+02:00	南アフリカ標準時	ハラーレ、プレトリア","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:00	ベラルーシ標準時	ミンスク","UTC+03:00	E. アフリカ標準時	ナイロビ","UTC+03:00	アラビック標準時	バグダッド","UTC+03:00	E. アフリカ標準時	ナイロビ","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:00	E. アフリカ標準時	ナイロビ","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:00	ロシア標準時	モスクワ、サンクトペテルブルク、ボルゴグラード (RTZ 2)","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:00	E. アフリカ標準時	ナイロビ","UTC+03:00	アラブ標準時	クウェート、リヤド","UTC+03:30	イラン標準時	テヘラン","UTC+04:00	コーカサス標準時	エレバン","UTC+04:00	アゼルバイジャン標準時	バクー","UTC+04:00	ジョージア標準時	トビリシ","UTC+04:00	モーリシャス標準時	ポートルイス","UTC+04:00	アラビア標準時	アブダビ、マスカット","UTC+04:00	モーリシャス標準時	ポートルイス","UTC+04:00	アラビア標準時	アブダビ、マスカット","UTC+04:30	アフガニスタン標準時	カブール","UTC+05:00	西アジア標準時	アシハバード、タシケント","UTC+05:00	パキスタン標準時	イスラマバード、カラチ","UTC+05:00	西アジア標準時	アシハバード、タシケント","UTC+05:30	インド標準時	チェンナイ、コルカタ、ムンバイ、ニューデリー","UTC+05:30	スリランカ標準時	スリジャヤワルダナプラコッテ","UTC+05:45	ネパール標準時	カトマンズ","UTC+06:00	バングラデシュ標準時	ダッカ","UTC+06:00	中央アジア標準時	アスタナ","UTC+06:30	ミャンマー標準時	ヤンゴン (ラングーン)","UTC+07:00	東南アジア標準時	バンコク、ハノイ、ジャカルタ","UTC+08:00	シンガポール標準時	クアラルンプール、シンガポール","UTC+08:00	中国標準時	北京、重慶、香港特別行政区、ウルムチ","UTC+08:00	シンガポール標準時	クアラルンプール、シンガポール","UTC+08:00	ウランバートル標準時	ウランバートル","UTC+08:00	シンガポール標準時	クアラルンプール、シンガポール","UTC+08:00	台北標準時	台北","UTC+09:00	東京標準時	大阪、札幌、東京","UTC+09:00	韓国標準時	ソウル","UTC+09:00	東京標準時	大阪、札幌、東京","UTC+10:00	オーストラリア東部標準時	キャンベラ、メルボルン、シドニー","UTC+10:00	西太平洋標準時	グアム、ポートモレスビー","UTC+11:00	中央太平洋標準時	ソロモン諸島、ニューカレドニア","UTC+12:00	フィジー標準時	フィジー","UTC+12:00	UTC+12	協定世界時 + 12","UTC+12:00	ニュージーランド標準時	オークランド、ウェリントン","UTC+12:00	UTC+12	協定世界時 + 12","UTC+13:00	サモア標準時	サモア","UTC+13:00	トンガ標準時	ヌクアロファ"}
mstz = {
    "UTC-11:00	UTC-11	Coordinated Universal Time-11",
    "UTC-10:00	Hawaiian Standard Time	Hawaii",
    "UTC-08:00	Pacific Standard Time	Pacific Time (US & Canada)",
    "UTC-07:00	Mountain Standard Time	Mountain Time (US & Canada)",
    "UTC-06:00	Central Standard Time (Mexico)	Guadalajara, Mexico City, Monterrey",
    "UTC-06:00	Central America Standard Time	Central America",
    "UTC-05:00	SA Pacific Standard Time	Bogota, Lima, Quito, Rio Branco",
    "UTC-05:00	Eastern Standard Time	Eastern Time (US & Canada)",
    "UTC-04:30	Venezuela Standard Time	Caracas",
    "UTC-04:00	SA Western Standard Time	Georgetown, La Paz, Manaus, San Juan",
    "UTC-04:00	Paraguay Standard Time	Asuncion",
    "UTC-04:00	Atlantic Standard Time	Atlantic Time (Canada)",
    "UTC-03:00	SA Eastern Standard Time	Cayenne, Fortaleza",
    "UTC-03:00	Pacific SA Standard Time	Santiago",
    "UTC-03:00	Montevideo Standard Time	Montevideo",
    "UTC-03:00	Greenland Standard Time	Greenland",
    "UTC-03:00	E. South America Standard Time	Brasilia",
    "UTC-03:00	Argentina Standard Time	City of Buenos Aires",
    "UTC-02:00	UTC-02	Coordinated Universal Time-02",
    "UTC-01:00	Cape Verde Standard Time	Cabo Verde Is.",
    "UTC	GMT Standard Time	Dublin, Edinburgh, Lisbon, London",
    "UTC	Greenwich Standard Time	Monrovia, Reykjavik",
    "UTC	Morocco Standard Time	Casablanca",
    "UTC	UTC	Coordinated Universal Time",
    "UTC+01:00	Central Europe Standard Time	Belgrade, Bratislava, Budapest, Ljubljana, Prague",
    "UTC+01:00	Central European Standard Time	Sarajevo, Skopje, Warsaw, Zagreb",
    "UTC+01:00	Namibia Standard Time	Windhoek",
    "UTC+01:00	Romance Standard Time	Brussels, Copenhagen, Madrid, Paris",
    "UTC+01:00	W. Central Africa Standard Time	West Central Africa",
    "UTC+01:00	W. Europe Standard Time	Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna",
    "UTC+02:00	E. Europe Standard Time	E. Europe",
    "UTC+02:00	Egypt Standard Time	Cairo",
    "UTC+02:00	FLE Standard Time	Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius",
    "UTC+02:00	GTB Standard Time	Athens, Bucharest",
    "UTC+02:00	Israel Standard Time	Middle East",
    "UTC+02:00	Jordan Standard Time	Amman",
    "UTC+02:00	Middle East Standard Time	Beirut",
    "UTC+02:00	South Africa Standard Time	Harare, Pretoria",
    "UTC+02:00	Syria Standard Time	Damascus",
    "UTC+02:00	Türkiye Standard Time	Istanbul",
    "UTC+03:00	Arab Standard Time	Kuwait, Riyadh",
    "UTC+03:00	Arabic Standard Time	Baghdad",
    "UTC+03:00	Belarus Standard Time	Minsk",
    "UTC+03:00	E. Africa Standard Time	Nairobi",
    "UTC+03:00	Russian Standard Time	Moscow, St. Petersburg, Volgograd (RTZ 2)",
    "UTC+03:30	Iran Standard Time	Tehran",
    "UTC+04:00	Arabian Standard Time	Abu Dhabi, Muscat",
    "UTC+04:00	Azerbaijan Standard Time	Baku",
    "UTC+04:00	Caucasus Standard Time	Yerevan",
    "UTC+04:00	Georgian Standard Time	Tbilisi",
    "UTC+04:00	Mauritius Standard Time	Port Louis",
    "UTC+04:30	Afghanistan Standard Time	Kabul",
    "UTC+05:00	Pakistan Standard Time	Islamabad, Karachi",
    "UTC+05:00	West Asia Standard Time	Ashgabat, Tashkent",
    "UTC+05:30	India Standard Time	Chennai, Kolkata, Mumbai, New Delhi",
    "UTC+05:30	Sri Lanka Standard Time	Sri Jayawardenepura",
    "UTC+05:45	Nepal Standard Time	Kathmandu",
    "UTC+06:00	Bangladesh Standard Time	Dhaka",
    "UTC+06:00	Central Asia Standard Time	Astana",
    "UTC+06:30	Myanmar Standard Time	Yangon (Rangoon)",
    "UTC+07:00	SE Asia Standard Time	Bangkok, Hanoi, Jakarta",
    "UTC+08:00	China Standard Time	Beijing, Chongqing, Hong Kong SAR, Urumqi",
    "UTC+08:00	Singapore Standard Time	Kuala Lumpur, Singapore",
    "UTC+08:00	Taipei Standard Time	Taipei",
    "UTC+08:00	Ulaanbaatar Standard Time	Ulaanbaatar",
    "UTC+09:00	Korea Standard Time	Seoul",
    "UTC+09:00	Tokyo Standard Time	Osaka, Sapporo, Tokyo",
    "UTC+10:00	AUS Eastern Standard Time	Canberra, Melbourne, Sydney",
    "UTC+10:00	West Pacific Standard Time	Guam, Port Moresby",
    "UTC+11:00	Central Pacific Standard Time	Solomon Is., New Caledonia",
    "UTC+12:00	Fiji Standard Time	Fiji",
    "UTC+12:00	New Zealand Standard Time	Auckland, Wellington",
    "UTC+12:00	UTC+12	Coordinated Universal Time+12",
    "UTC+13:00	Samoa Standard Time	Samoa",
    "UTC+13:00	Tonga Standard Time	Nuku'alofa"
}

hotkey_id_reset = obs.OBS_INVALID_HOTKEY_ID
hotkey_id_pause = obs.OBS_INVALID_HOTKEY_ID

-- https://claude.ai/chat/2766d911-6ecc-4ea2-8d87-caafc0e6c974
-- Integrated TZIF Parser for OBS Lua Script
-- Based on luatz tzfile.lua but without require statements

-- Define metatable implementations that would normally be in tzinfo.lua
-- https://github.com/daurnimator/luatz/tree/master/luatz luatzのパーサーを改造

local tz_info_methods = {}
local tz_info_mt = {__name = "luatz.tz_info", __index = tz_info_methods}
local tt_info_mt = {
    __name = "luatz.tt_info",
    __tostring = function(self)
        return string.format("tt_info:%s=%d", self.abbr, self.gmtoff)
    end
}

-- Define binary reading functions
local function read_int32be(fd)
    local data, err = fd:read(4)
    if data == nil then return nil, err end

    local o1, o2, o3, o4 = data:byte(1, 4)
    local unsigned = o4 + o3 * 2 ^ 8 + o2 * 2 ^ 16 + o1 * 2 ^ 24
    if unsigned >= 2 ^ 31 then unsigned = unsigned - 2 ^ 32 end

    -- print(string.format("%d", unsigned)) -- デバッグ追加
    return unsigned
end

function read_long_bytesToDouble52BitBigEndian(fd)
    local bit = require("bit")
    local data, err = fd:read(8)
    if not data then return nil, err end
    -- バイトを取得
    local b1, b2, b3, b4, b5, b6, b7, b8 = data:byte(1, 8)

    -- 符号判定
    local value
    if b1 >= 0x80 then
        -- 負の値の場合、各バイトを8ビットでNOT（ビット反転）
        local n1 = bit.band(bit.bnot(b1), 0xFF)
        local n2 = bit.band(bit.bnot(b2), 0xFF)
        local n3 = bit.band(bit.bnot(b3), 0xFF)
        local n4 = bit.band(bit.bnot(b4), 0xFF)
        local n5 = bit.band(bit.bnot(b5), 0xFF)
        local n6 = bit.band(bit.bnot(b6), 0xFF)
        local n7 = bit.band(bit.bnot(b7), 0xFF)
        local n8 = bit.band(bit.bnot(b8), 0xFF)

        -- 32ビットずつ分割
        local high = bit.bor(bit.lshift(n1, 24), bit.lshift(n2, 16),
                             bit.lshift(n3, 8), n4)
        local low = bit.bor(bit.lshift(n5, 24), bit.lshift(n6, 16),
                            bit.lshift(n7, 8), n8)

        -- 64ビット値を構築し、最後に+1
        value = high * 2 ^ 32 + low + 1
        if (low < 0) then value = value + 2 ^ 32 end
        value = value * -1

    else
        -- 正の値の場合、そのまま処理
        local high = bit.bor(bit.lshift(b1, 24), bit.lshift(b2, 16),
                             bit.lshift(b3, 8), b4)
        local low = bit.bor(bit.lshift(b5, 24), bit.lshift(b6, 16),
                            bit.lshift(b7, 8), b8)
        value = high * 2 ^ 32 + low
        if (low < 0) then value = value + 2 ^ 32 end
    end

    -- 52ビット精度に制限
    local max52Bit = 2 ^ 53 - 1 -- 9,007,199,254,740,991
    local min52Bit = -2 ^ 53 -- -9,007,199,254,740,992
    if value > max52Bit then
        -- value = max52Bit
        obs.script_log(obs.LOG_INFO, value ..
                           "がmaxこえてます 値が9,007,199,254,740,991,53bit以上の場合 64bit浮動小数点精度は保証されません")
    elseif value < min52Bit then
        -- value = min52Bit
        obs.script_log(obs.LOG_INFO, value ..
                           "minをこえてます 値が-9,007,199,254,740,992,53bit以下の場合 64bit浮動小数点精度は保証されません")
    end

    return value
end

--[[
local bit = require("bit") -- bitライブラリが必要 完全な64bit対応だが、しかしosdateも使えなくなる諸刃の剣（） osdata (doubleでし)
local function read_int64be(fd)
    local data, err = fd:read(8)
    if not data then return nil, err end
    local bytes = {data:byte(1, 8)}
    local int64 = 0
    for i = 0, 7 do
        int64 = bit.bor(bit.lshift(int64, 8), bytes[i + 1])
    end
    return int64
end
]]

-- 64bitエンディアン変換はluaが内部に倍精度浮動小数を用いいているので
-- 負数変換時問題が発生する（）　2^53上まで グロックたんの回答
-- https://grok.com/share/bGVnYWN5_c05ca7f2-e295-4598-90b6-c0c988b0b584  why cannot endian swap at lua5.1 IEEE754problem
-- https://grok.com/chat/0f0a7888-c651-484a-90bd-0b76b7f8d1cb 
-- https://grok.com/share/bGVnYWN5_4ba125df-818b-495f-a677-1a9f2fb271c5 

-- Only available in Lua 5.3+　＜-obsstuioのluagitは5.1らしいのでつかえない、pythonのすとらくちゃーににてる
-- luacheck: push std max
--[[
if string.unpack then
	-- Only available in Lua 5.3+
	function read_int32be(fd)
		local data, err = fd:read(4)
		if data == nil then return nil, err end
		return string.unpack(">i4", data)
	end

	function read_int64be(fd)
		local data, err = fd:read(8)
		if data == nil then return nil, err end
		return string.unpack(">i8", data)
	end
else -- luacheck: pop
	function read_int32be(fd)
		local data, err = fd:read(4)
		if data == nil then return nil, err end
		local o1, o2, o3, o4 = data:byte(1, 4)

		local unsigned = o4 + o3*2^8 + o2*2^16 + o1*2^24
		if unsigned >= 2^31 then
			return unsigned - 2^32
		else
			return unsigned
		end
	end

	function read_int64be(fd)
		local data, err = fd:read(8)
		if data == nil then return nil, err end
		local o1, o2, o3, o4, o5, o6, o7, o8 = data:byte(1, 8)

		local unsigned = o8 + o7*2^8 + o6*2^16 + o5*2^24 + o4*2^32 + o3*2^40 + o2*2^48 + o1*2^56
		if unsigned >= 2^63 then
			return unsigned - 2^64
		else
			return unsigned
		end
	end
end
]]

local function read_flags(fd, n)
    local data, err = fd:read(n)
    if data == nil then return nil, err end

    local res = {}
    for i = 1, n do res[i] = data:byte(i, i) ~= 0 end
    return res
end

--- Moment.js形式に変換する関数
local function convert_momentjs()
    tz_abbrs = {}
    tz_untils = {}
    tz_offsets = {}

    if #timezone_transition < 2 then
        if (#timezone_transition == 1) then
            tz_untils[1] = timezone_transition[1] * 1000
        else
            tz_untils[1] = math.huge
        end
        tz_abbrs[1] = timezone_abbr[1]
        tz_offsets[1] = timezone_offset[1] / 60 * -1
    else
        -- 最初のエントリをUTCに設定
        tz_untils[1] = -2 ^ 31 -- 最小値（Moment.jsの範囲開始）
        tz_abbrs[1] = "UTC" -- 本当はLMTだが、緯度情報がいるのでとりあえずUTCにしておく
        tz_offsets[1] = 0

        -- 既存データをスライド
        translen = tonumber(#timezone_transition)
        for i = 1, translen do
            tz_untils[i] = timezone_transition[i] * 1000
            tz_abbrs[i + 1] = timezone_abbr[i]
            tz_offsets[i + 1] = timezone_offset[i] / 60 * -1
        end

        -- 最後に math.huge を追加
        tz_untils[translen + 1] = math.huge
    end

    tz_len = tonumber(#tz_offsets) - 1

    return
end
-- 先頭と末尾の改行および空白をトリムする関数
local function trim_ends(str)
    if not str then return "" end
    -- 先頭の改行と空白を削除
    str = str:gsub("^[\n%s]+", "")
    -- 末尾の改行と空白を削除
    str = str:gsub("[\n%s]+$", "")
    return str
end

local fifteen_nulls = ("\0"):rep(15)
local function read_tz(fd, file_seek, file_size)

    assert(fd:seek("set", file_seek))

    assert(fd:read(4) == "TZif", "Invalid TZ file")
    local version = assert(fd:read(1))
    if version == "\0" or version == "2" or version == "3" then
        local MIN_TIME = -2 ^ 32 + 1

        assert(fd:read(15) == fifteen_nulls, "Expected 15 nulls")
        tz_posix_string = nil
        local tzh_ttisgmtcnt = assert(read_int32be(fd))
        local tzh_ttisstdcnt = assert(read_int32be(fd))
        local tzh_leapcnt = assert(read_int32be(fd))
        local tzh_timecnt = assert(read_int32be(fd))
        local tzh_typecnt = assert(read_int32be(fd))
        local tzh_charcnt = assert(read_int32be(fd))

        --[[
        obs.script_log(obs.LOG_INFO,
                       string.format("tzh_timecnt: %d", tzh_timecnt))
        obs.script_log(obs.LOG_INFO,
                       string.format("tzh_typecnt : %d", tzh_typecnt))
        obs.script_log(obs.LOG_INFO,
                       string.format("tzh_charcnt: %s", tzh_charcnt))
        -- ]]

        posixTZ = nil
        timezone_transition = {}
        timezone_offset = {}
        timezone_abbr = {}

        -- トランジション時刻
        for i = 1, tzh_timecnt do
            timezone_transition[i] = assert(read_int32be(fd))
        end
        local transition_time_ind = {assert(fd:read(tzh_timecnt)):byte(1, -1)}

        -- タイムゾーン情報
        local ttinfos = {}
        for i = 1, tzh_typecnt do
            ttinfos[i] = {
                gmtoff = assert(read_int32be(fd)),
                isdst = assert(fd:read(1)) ~= "\0",
                abbrind = assert(fd:read(1)):byte()
            }
        end

        local abbreviations = assert(fd:read(tzh_charcnt))

        -- オフセットと略称を格納
        for i = 1, tzh_timecnt do
            local ttinfo = ttinfos[transition_time_ind[i] + 1]
            timezone_offset[i] = ttinfo.gmtoff
            timezone_abbr[i] = abbreviations:sub(ttinfo.abbrind + 1,
                                                 (abbreviations:find("\0",
                                                                     ttinfo.abbrind +
                                                                         1) or
                                                     #abbreviations + 1) - 1)
        end

        if (tzh_timecnt == 0) then
            timezone_transition[1] = nil
            timezone_offset[1] = ttinfos[1].gmtoff
            timezone_abbr[1] = abbreviations
        end

        -- リープ秒
        local leap_seconds = {}
        for i = 1, tzh_leapcnt do
            leap_seconds[i] = {
                offset = assert(read_int32be(fd)),
                n = assert(read_int32be(fd))
            }
        end

        local isstd = assert(read_flags(fd, tzh_ttisstdcnt))
        local isgmt = assert(read_flags(fd, tzh_ttisgmtcnt))

        obs.script_log(obs.LOG_INFO, "TZif 32 passed")

        assert(fd:read(4) == "TZif", "Invalid TZ file")
        local version = assert(fd:read(1))
        if version == "2" or version == "3" then
            local MIN_TIME = -2 ^ 53 + 1

            assert(fd:read(15) == fifteen_nulls, "Expected 15 nulls")

            local tzh_ttisgmtcnt = assert(read_int32be(fd))
            local tzh_ttisstdcnt = assert(read_int32be(fd))
            local tzh_leapcnt = assert(read_int32be(fd))
            local tzh_timecnt = assert(read_int32be(fd))
            local tzh_typecnt = assert(read_int32be(fd))
            local tzh_charcnt = assert(read_int32be(fd))

            --
            obs.script_log(obs.LOG_INFO,
                           string.format("tzh_timecnt: %d", tzh_timecnt))
            obs.script_log(obs.LOG_INFO,
                           string.format("tzh_typecnt : %d", tzh_typecnt))
            obs.script_log(obs.LOG_INFO,
                           string.format("tzh_charcnt: %s", tzh_charcnt))
            -- ]]

            timezone_transition = {}
            timezone_offset = {}
            timezone_abbr = {}

            -- トランジション時刻
            for i = 1, tzh_timecnt do
                timezone_transition[i] = assert(
                                             read_long_bytesToDouble52BitBigEndian(
                                                 fd))
            end
            local transition_time_ind = {
                assert(fd:read(tzh_timecnt)):byte(1, -1)
            }

            -- タイムゾーン情報
            local ttinfos = {}
            for i = 1, tzh_typecnt do
                ttinfos[i] = {
                    gmtoff = assert(read_int32be(fd)),
                    isdst = assert(fd:read(1)) ~= "\0",
                    abbrind = assert(fd:read(1)):byte()
                }
            end

            local abbreviations = assert(fd:read(tzh_charcnt))

            -- オフセットと略称を格納
            for i = 1, tzh_timecnt do
                local ttinfo = ttinfos[transition_time_ind[i] + 1]
                timezone_offset[i] = ttinfo.gmtoff
                timezone_abbr[i] = abbreviations:sub(ttinfo.abbrind + 1,
                                                     (abbreviations:find("\0",
                                                                         ttinfo.abbrind +
                                                                             1) or
                                                         #abbreviations + 1) - 1)
            end

            if (tzh_timecnt == 0) then
                timezone_transition[1] = nil
                timezone_offset[1] = ttinfos[1].gmtoff
                timezone_abbr[1] = abbreviations
            end

            -- リープ秒
            local leap_seconds = {}
            for i = 1, tzh_leapcnt do
                leap_seconds[i] = {
                    offset = assert(read_int32be(fd)),
                    n = assert(read_int32be(fd))
                }
            end

            local isstd = assert(read_flags(fd, tzh_ttisstdcnt))
            local isgmt = assert(read_flags(fd, tzh_ttisgmtcnt))

            local current_pos = fd:seek("cur")
            local end_pos = file_size

            --[[
            obs.script_log(obs.LOG_INFO,
            "TZif posix_tz_string:" .. current_pos)
            obs.script_log(obs.LOG_INFO,
                           "TZif posix_tz_string:" .. end_pos)
                           ]]
            if end_pos > current_pos then
                fd:seek("set", current_pos)
                posix_tz_string = trim_ends(fd:read(end_pos - current_pos)) or
                                      nil

                obs.script_log(obs.LOG_INFO,
                               "TZif posix_tz_string:" .. posix_tz_string)
            else
                posix_tz_string = nil
            end
            obs.script_log(obs.LOG_INFO, "TZif 64 passed")
        end

        -- ttinfosに略称とフラグを追加
        for i = 1, tzh_typecnt do
            local v = ttinfos[i]
            v.abbr = abbreviations:sub(v.abbrind + 1, (abbreviations:find("\0",
                                                                          v.abbrind +
                                                                              1) or
                                           #abbreviations + 1) - 1)
            v.isstd = isstd[i] or false
            v.isgmt = isgmt[i] or false
            setmetatable(v, tt_info_mt)
        end

        -- 最初の標準時間
        local first = 1
        for i = 1, tzh_ttisstdcnt do
            if isstd[i] then
                first = i
                break
            end
        end

        local res = {
            future = nil,
            [0] = {transition_time = MIN_TIME, info = ttinfos[first]}
        }
        for i = 1, tzh_timecnt do
            res[i] = {
                transition_time = timezone_transition[i],
                info = ttinfos[transition_time_ind[i] + 1]
            }
        end

        -- convert_momentjs を呼び出し
        local moment_data = convert_momentjs()

        obs.script_log(obs.LOG_INFO, "TZif processing complete")

        return setmetatable(res, tz_info_mt)
    else
        error("Unsupported version")
    end
end

function android_tzreader(fd, filePath)

    local target = {-1, -1} -- Lua uses 1-based indexing, but we'll keep -1 as per the original logic

    local android_tzseek_text = timezone -- Simulated textbox input (android_tzseek.Text)

    assert(fd:seek("set", 0))

    -- Read the first 24 bytes (header)
    local buffer = fd:read(12)
    if not buffer or #buffer < 12 then
        obs.script_log(obs.LOG_INFO, "File too short or read failed")
        return target
    end

    local indexOffset = assert(read_int32be(fd))
    local dataOffset = assert(read_int32be(fd))
    local zonetabOffset = assert(read_int32be(fd))
    obs.script_log(obs.LOG_INFO, "dataOffset: " .. dataOffset)
    obs.script_log(obs.LOG_INFO, "zonetabOffset: " .. zonetabOffset)

    local indexSize = dataOffset - indexOffset
    local sectionCount = 0
    local maxSections = math.floor(indexSize / 52)
    local tzname = ""

    -- Read 52-byte chunks
    while true do
        buffer = fd:read(40)
        if not buffer or #buffer < 40 then break end
        if sectionCount >= maxSections then break end

        -- Extract timezone name (first 20 bytes, trim nulls)
        tzname = string.sub(buffer, 1, 20):gsub("%z", "")

        if tzname == "TZif2" then break end

        -- Extract offset and length
        local offset = assert(read_int32be(fd))
        local tzLength = assert(read_int32be(fd))
        fd:read(4)

        -- Check if this is the target timezone
        if tzname == android_tzseek_text then
            target[1] = offset
            target[2] = tzLength
            obs.script_log(obs.LOG_INFO, "tzname: " .. tzname)
            obs.script_log(obs.LOG_INFO, "target_offet: " .. target[1])
            obs.script_log(obs.LOG_INFO, "size: " .. target[2])
        end

        sectionCount = sectionCount + 1
    end

    local Tzif_pos = sectionCount * 52 + 24

    if target[2] > 0 then target[1] = target[1] + Tzif_pos end
    return target
end

-- Assuming this is part of a larger function
function process_tzdata(fd, tzdata)

    -- Extract the header (first 4 bytes)
    local header = fd:read(4)
    local file_seek = 0
    local file_size = fd:seek("end")

    if header == "tzda" then
        local target = android_tzreader(fd, tzdata) -- Call the previously converted function
        if target[1] == -1 then
            obs.script_log(obs.LOG_INFO, "android tzdata read failed")
            return nil -- Exit the function if target[0] == -1
        end

        file_seek = target[1]
        file_size = target[2] + target[1]
        obs.script_log(obs.LOG_INFO,
                       "android tzdata read success pos:" .. file_seek,
                       file_size)
    end

    -- Return updated bs and header if needed (adjust based on your function's purpose)
    return read_tz(fd, file_seek, file_size)
end

local function read_tzfile(path)
    local fd = assert(io.open(path, "rb"))
    local tzinfo = process_tzdata(fd, path)

    obs.script_log(obs.LOG_INFO, tzinfo)

    fd:close()
    return tzinfo
end

-- OBS Script helper functions for timezone handling
local function get_timezone_offset(tzinfo, timestamp)
    local info = tzinfo[timestamp]
    return info.gmtoff, info.isdst, info.abbr
end

local function find_timezome_zoneinfo_path()
    local windows = isWindows()
    local possible_paths = {}

    if windows then
        possible_paths = {
            timezone_tzif_path, unpack(timezone_tzif_path_suggest_window)
        }
    else
        possible_paths = {
            timezone_tzif_path, unpack(timezone_tzif_path_suggest_unix)
        }
    end

    for _, path in ipairs(possible_paths) do
        local test_file = path .. "UTC"
        local f = io.open(test_file, "rb")
        if f then
            f:close()
            return path
        end
        test_file = path .. "tzdata"
        local f = io.open(test_file, "rb")
        if f then
            f:close()
            return path .. "tzdata"
        end
    end

    return nil
end

-- Function to load a timezone from dateutil zoneinfo
local function load_timezone(timezone_name)
    local zoneinfo_path = find_timezome_zoneinfo_path()
    if not zoneinfo_path then
        error("Could not find timezone zoneinfo directory")
        return nil
    end

    local tzfile_path = zoneinfo_path .. timezone_name
    if (zoneinfo_path:match("tzdata$")) then tzfile_path = zoneinfo_path end
    obs.script_log(obs.LOG_INFO, tzfile_path)

    return read_tzfile(tzfile_path)
end
local function parseOffset(offset)
    if (offset == nil) then return nil end

    -- obs.script_log(obs.LOG_DEBUG,"parseOffset: Input offset: " .. tostring(offset))
    local sign, hours = offset:match("^([%-%+]?)(%d+)")
    local minutes = offset:match(":(%d+)$")
    hours = tonumber(hours)
    local totalMinutes = hours * 60
    if minutes then totalMinutes = totalMinutes + tonumber(minutes) end
    if sign ~= "-" then totalMinutes = totalMinutes * (-1) end
    -- obs.script_log(obs.LOG_DEBUG, "parseOffset: Calculated totalMinutes: " ..  tostring(totalMinutes * -1))
    return totalMinutes * -1
end

local function parseTransition(transition)
    -- obs.script_log(obs.LOG_DEBUG, "parseTransition: Input transition: " .. tostring(transition))
    if string.sub(transition, 1, 1) == "M" then
        local parts = {}
        for part in string.gmatch(transition:sub(2), "[^/]+") do
            table.insert(parts, part)
        end

        local month, week, day = string.match(parts[1], "(%d+)%.(%d+)%.(%d+)")
        -- obs.script_log(obs.LOG_DEBUG,    "parseTransition: month: " .. tostring(month) ..", week: " .. tostring(week) .. ", day: " ..tostring(day))

        local time = {hour = 2, minute = 0, second = 0}

        if parts[2] then
            local hour, minute, second =
                string.match(parts[2], "(%d+):?(%d+)?:?(%d+)?")
            time.hour = tonumber(hour) or 2
            time.minute = tonumber(minute) or 0
            time.second = tonumber(second) or 0
            -- obs.script_log(obs.LOG_DEBUG,        "parseTransition: hour: " .. tostring(time.hour) ..    ", minute: " .. tostring(time.minute) ..    ", second: " .. tostring(time.second))
        end

        return {
            month = tonumber(month),
            week = tonumber(week),
            day = tonumber(day),
            hour = time.hour,
            minute = time.minute,
            second = time.second
        }
    end
    -- obs.script_log(obs.LOG_WARNING,"parseTransition: Unsupported transition format: " .. tostring(transition))
    return nil
end

function parsePosixTZ(tz)
    -- obs.script_log(obs.LOG_DEBUG, "parsePosixTZ: Input TZ string: " .. tostring(tz))
    local result = {
        stdAbbr = nil,
        stdOffset = 0,
        dst = false,
        dstAbbr = nil,
        dstOffset = nil,
        dstStart = nil,
        dstEnd = nil
    }

    local parts = {}
    for part in string.gmatch(tz, "[^,]+") do
        table.insert(parts, part)
        -- obs.script_log(obs.LOG_DEBUG,    "parsePosixTZ: Found part: " .. tostring(part))
    end

    local localTZ = parts[1]
    -- obs.script_log(obs.LOG_DEBUG, "parsePosixTZ: localTZ: " .. tostring(localTZ))

    local LOCAL_TZ_RE = "^([A-Za-Z]+)([%+%-]?%d+)$" -- 標準的な POSIX タイムゾーン形式
    local LOCAL_TZ_REE = "^([A-Za-Z]+)([%+%-]?%d+)([A-Za-Z]+)$" -- 標準的な POSIX タイムゾーン形式
    local LOCAL_TZ_REEE = "^([A-Za-Z]+)([%+%-]?%d+)([A-Za-Z]+)([%+%-]?%d+)$" -- 標準的な POSIX タイムゾーン形式
    local LOCAL_TZ_AB = "<?[+-]?%d+:?%d?%d?>?" -- lordhowe <+1030>-10:30<+11>-11,M10.1.0,M4.1.0

    local match
    local posix_triangle_bracket = false
    local success_match = nil
    match = localTZ:match(LOCAL_TZ_RE)
    if match then
        success_match = LOCAL_TZ_RE
        -- obs.script_log(obs.LOG_DEBUG, "parsePosixTZ: Matched LOCAL_TZ_RE")
    elseif localTZ:match(LOCAL_TZ_REE) then
        success_match = LOCAL_TZ_REE
        -- obs.script_log(obs.LOG_DEBUG, "parsePosixTZ: Matched LOCAL_TZ_REE")
    elseif localTZ:match(LOCAL_TZ_REEE) then
        success_match = LOCAL_TZ_REEE
        -- obs.script_log(obs.LOG_DEBUG, "parsePosixTZ: Matched LOCAL_TZ_REEE")
    elseif localTZ:match(LOCAL_TZ_AB) then
        success_match = LOCAL_TZ_AB
        posix_triangle_bracket = true
        -- obs.script_log(obs.LOG_DEBUG, "parsePosixTZ: Matched LOCAL_TZ_AB")
    end

    if (posix_triangle_bracket) then
        local matched = ""
        for match in localTZ:gmatch(LOCAL_TZ_AB) do
            matched = matched .. match .. ","
        end

        -- obs.script_log(obs.LOG_DEBUG, "matched:" .. matched)

        local parts_posix_triangle = {}
        for part in string.gmatch(matched, "[^,]+") do
            table.insert(parts_posix_triangle, part)
        end

        result.stdAbbr = parts_posix_triangle[1]
        result.stdOffset = parseOffset(parts_posix_triangle[2]) or 0
        if (#parts_posix_triangle >= 3) then
            result.dst = parts_posix_triangle[3] ~= nil
            result.dstAbbr = parts_posix_triangle[3]
            if (#parts_posix_triangle >= 4) then
                result.dstOffset = parseOffset(parts_posix_triangle[4])
            else
                result.dstOffset = result.stdOffset - 60
            end
        else
            result.dst = nil
        end
    elseif (success_match) then
        local stdAbbr, stdOffset, dstAbbr, dstOffset = localTZ:match(
                                                           success_match)
        result.stdAbbr = stdAbbr
        result.stdOffset = parseOffset(stdOffset) or 0
        result.dst = dstAbbr ~= nil
        result.dstAbbr = dstAbbr
        result.dstOffset = parseOffset(dstOffset)
        result.dstOffset = parseOffset(dstOffset) or (result.stdOffset - 60)
    else
        -- obs.script_log(obs.LOG_WARNING, "parsePosixTZ: Could not parse localTZ: " ..  tostring(localTZ))
        return nil
    end

    -- obs.script_log(obs.LOG_DEBUG,"parsePosixTZ: stdAbbr: " .. tostring(result.stdAbbr))
    -- obs.script_log(obs.LOG_DEBUG,"parsePosixTZ: stdOffset: " .. tostring(result.stdOffset))
    -- if result.dst then
    -- obs.script_log(obs.LOG_DEBUG,    "parsePosixTZ: dstAbbr: " .. tostring(result.dstAbbr))
    -- obs.script_log(obs.LOG_DEBUG, "parsePosixTZ: dstOffset: " ..tostring(result.dstOffset))
    -- end

    if #parts >= 2 then result.dstStart = parseTransition(parts[2]) end
    if #parts >= 3 then result.dstEnd = parseTransition(parts[3]) end

    return result
end

function days(y, m, d)
    -- 月ごとの累積日数テーブル
    local t = {306, 337, 0, 31, 61, 92, 122, 153, 184, 214, 245, 275}

    m = tonumber(m)
    -- 1,2月の場合は前年として計算
    if m < 3 then y = y - 1 end

    local tm = 365 * y + math.floor(y / 4) - math.floor(y / 100) +
                   math.floor(y / 400) + t[m] + d

    return tm
end

function preset_fairfield_dateutc(y, m, d)
    if (tonumber(y) and tonumber(m) and tonumber(d)) then
        if (tonumber(m) > 0 and tonumber(m) <= 12) then
            return (days(y, m, d) - days(1970, 1, 1)) * 86400
        end
    end

    obs.script_log(obs.LOG_DEBUG, "Invalid date ymd " .. tostring(y) ..
                       tostring(m) .. tostring(d))
    return "Invalid date"

end

function transitionToDate(year, transition, offset)
    local jsMonth = transition.month - 1

    local dt = {
        year = year,
        month = jsMonth,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0
    }

    -- 指定された曜日に移動
    local weekday = (tonumber(os.date("!%w", preset_fairfield_dateutc(year,
                                                                      jsMonth +
                                                                          1, 1)))) -- os.date("%w") is 0-indexed (Sunday=0)

    local day_diff = (transition.day - weekday) % 7
    if day_diff < 0 then day_diff = day_diff + 7 end
    dt.day = dt.day + day_diff

    -- 月が異なる場合は1週間進める
    if tonumber(os.date("!%m",
                        preset_fairfield_dateutc(dt.year, dt.month + 1, dt.day))) ~=
        jsMonth + 1 then dt.day = dt.day + 7 end

    -- 指定された週数分進める/戻す
    if transition.week > 1 then
        dt.day = dt.day + (transition.week - 1) * 7

        -- 月が変わってしまったら1週間戻す
        if tonumber(os.date("!%m", preset_fairfield_dateutc(dt.year,
                                                            dt.month + 1, dt.day))) ~=
            jsMonth + 1 then dt.day = dt.day - 7 end
    end

    local time_sec = preset_fairfield_dateutc(dt.year, dt.month + 1, dt.day) +
                         transition.hour * 3600 + transition.minute * 60 +
                         transition.second + offset * 60

    -- obs.script_log(obs.LOG_DEBUG,"data:" .. time_sec ..os.date(" %Y-%m-%d %H:%M:%S ", time_sec) ..os.date("!%Y-%m-%d %H:%M:%S ", time_sec))

    return time_sec
end

function getOffsetForLocalDateWithPosixTZ(localDate, posixTZ)
    parsedTZ = parsePosixTZ(posixTZ)
    if not parsedTZ then return nil end
    if not localDate then return nil end

    local year = tonumber(os.date("!%Y", localDate))
    local month = tonumber(os.date("!%m", localDate))
    local day = tonumber(os.date("!%d", localDate))
    local hour = tonumber(os.date("!%H", localDate))
    local min = tonumber(os.date("!%M", localDate))
    local sec = tonumber(os.date("!%S", localDate))

    local dt = preset_fairfield_dateutc(year, month, day) + hour * 3600 + min *
                   60 + sec

    if parsedTZ.dst then
        local dstStart = transitionToDate(year, parsedTZ.dstStart,
                                          parsedTZ.stdOffset)
        local dstEnd = transitionToDate(year, parsedTZ.dstEnd,
                                        parsedTZ.dstOffset)

        -- obs.script_log(obs.LOG_DEBUG,"dt "..dt.." "..dt-dstStart)
        -- obs.script_log(obs.LOG_DEBUG,"ddstStart  "..dstStart.." "..dt-dstStart)
        -- obs.script_log(obs.LOG_DEBUG,"dstEnd "..dstEnd.." "..dt-dstEnd)

        if dstStart > dstEnd then
            if dt >= dstStart or dt < dstEnd then
                -- obs.script_log(obs.LOG_DEBUG,"dt >= dstStart or dt < dstEnd")
                return parsedTZ.dstOffset, parsedTZ.dstAbbr
            end
           -- obs.script_log(obs.LOG_DEBUG, "dt stdOffset")
        else
            if dt >= dstStart and dt < dstEnd then
                return parsedTZ.dstOffset, parsedTZ.dstAbbr
            end
        end
    end
    -- obs.script_log(obs.LOG_DEBUG,"stdOffset done")

    return parsedTZ.stdOffset, parsedTZ.stdAbbr
end

function formatLocalDateWithOffset(localDate, posixTZ)
    local offset, abbr = getOffsetForLocalDateWithPosixTZ(localDate, posixTZ)
    if not offset then return nil end

    local dt = os.date("*t", localDate) -- local time

    local offset_hours = math.floor(math.abs(offset) / 60)
    local offset_minutes = math.abs(offset) % 60
    local offset_string = string.format("%s%02d:%02d",
                                        offset >= 0 and "+" or "-",
                                        offset_hours, offset_minutes)

    return string.format("%04d-%02d-%02dT%02d:%02d:%02d%s " .. abbr, dt.year,
                         dt.month, dt.day, dt.hour, dt.min, dt.sec,
                         offset_string)
end

-- Cache for loaded timezones
local timezone_cache = {}

-- Get timezone offset in seconds for a given timestamp
function get_timezone_offset_for_timestamp(timezone_name, timestamp)
    -- Check if timezone is already cached
    if not timezone_cache[timezone_name] then
        timezone_cache[timezone_name] = load_timezone(timezone_name)
    end

    local tzinfo = timezone_cache[timezone_name]
    local offset, is_dst, abbr = get_timezone_offset(tzinfo, timestamp)

    return offset, is_dst, abbr
end

-- Convert UTC timestamp to local time
function utc_to_local(timestamp, timezone_name)
    local offset = get_timezone_offset_for_timestamp(timezone_name, timestamp)
    return timestamp + offset
end

-- Convert local time to UTC timestamp
function local_to_utc(local_time, timezone_name)
    -- This is trickier because we need to find the correct offset at the local time
    -- We can approximate by first getting the offset for the local time as if it were UTC
    local approx_offset = get_timezone_offset_for_timestamp(timezone_name,
                                                            local_time)
    local utc_time = local_time - approx_offset

    -- Now get the proper offset using this approximated UTC time
    local actual_offset = get_timezone_offset_for_timestamp(timezone_name,
                                                            utc_time)

    -- If the offsets are different (due to DST boundary), recalculate
    if approx_offset ~= actual_offset then
        utc_time = local_time - actual_offset
    end

    return utc_time
end

function delta_time()
    local now = os.time()
    local year = os.date("%Y", now)
    local month = os.date("%m", now)
    local day = os.date("%d", now)
    local future = os.time {
        year = year,
        month = month,
        day = day,
        hour = hour,
        min = minute
    }
    local seconds = os.difftime(future, now)

    if (seconds < 0) then seconds = seconds + 84600 end

    local total_time = seconds * 10

    return total_time
end

function get_timestring(t, text)
    if (t == nil or t == "Invalid date") then return "Invalid date" end

    total = t * 10
    if (total < 0) then
        total = -total

        if (end_text ~= "") then return end_text end
    end

    local tenths = math.floor(total % 10)
    local seconds = math.floor((total / 10) % 60)
    local minutes = math.floor((total / 600) % 60)
    local hours = math.floor((total / 36000) % 24)
    local days = math.floor(total / 864000)

    local hours_infinite = math.floor(total / 36000)
    local seconds_infinite = math.floor(total / 10)
    local minutes_infinite = math.floor(total / 600)

    local days_sn = string.format("%03.3f", (total / 864000))
    local hours_sn = string.format("%03.3f", (total / 36000))
    local minutes_sn = string.format("%03.3f", (total / 600))
    -- local seconds_sn  = string.format("%03.2f", (total / 10))

    if string.match(text, "%%HH") then
        text = string.gsub(text, "%%HH", "%%H")
        minutes_infinite = string.format("%02d", hours_infinite)
    end

    if string.match(text, "%%MM") then
        text = string.gsub(text, "%%MM", "%%M")
        minutes_infinite = string.format("%02d", minutes_infinite)
    end

    if string.match(text, "%%SS") then
        text = string.gsub(text, "%%SS", "%%S")
        seconds_infinite = string.format("%02d", seconds_infinite)
    end

    if string.match(text, "%%hh") then
        text = string.gsub(text, "%%hh", "%%h")
        hours = string.format("%02d", hours)
    end

    if string.match(text, "%%mm") then
        text = string.gsub(text, "%%mm", "%%m")
        minutes = string.format("%02d", minutes)
    end

    if string.match(text, "%%ss") then
        text = string.gsub(text, "%%ss", "%%s")
        seconds = string.format("%02d", seconds)
    end

    text = string.gsub(text, "%%ds", tostring(days_sn))
    text = string.gsub(text, "%%hs", tostring(hours_sn))
    text = string.gsub(text, "%%ms", tostring(minutes_sn))

    text = string.gsub(text, "%%d", tostring(days))
    text = string.gsub(text, "%%H", tostring(hours_infinite))
    text = string.gsub(text, "%%h", tostring(hours))
    text = string.gsub(text, "%%M", tostring(minutes_infinite))
    text = string.gsub(text, "%%m", tostring(minutes))
    text = string.gsub(text, "%%S", tostring(seconds_infinite))
    text = string.gsub(text, "%%s", tostring(seconds))
    text = string.gsub(text, "%%t", tostring(tenths))

    return text
end

function checkdate(a, b)
    if (a == "Invalid date" or b == "Invalid date" or a == nil or b == nil) then
        return "Either date is Invalid date"
    end
    return true
end

function makebar(p)
    local base = "="
    q = obsbar

    p = p / q

    p = math.floor(p)
    local s = ""
    for i = 0, p - 1 do s = s .. base end
    s = s .. ">"
    for i = p + 1, 100 / q do s = s .. "_" end
    local bar = "[" .. s .. "]"
    return bar
end
-- //! moment-timezone.js
-- //! version : 0.5.44
-- //! Copyright (c) JS Foundation and other contributors
-- //! license : MIT
-- //! github.com/moment/moment-timezone America/Los_Angelesだけ移植（）

-- function closest (num, arr) { //２分探索右方法
-- var len = arr.length;
-- if (num < arr[0]) {
-- return 0;
-- } else if (len > 1 && arr[len - 1] === Infinity && num >= arr[len - 2]) {
-- return len - 1;
-- } else if (num >= arr[len - 1]) {
-- return -1;
-- }

-- var mid;
-- var lo = 0;
-- var hi = len - 1;
-- while (hi - lo > 1) {
-- mid = Math.floor((lo + hi) / 2);
-- if (arr[mid] <= num) {
-- lo = mid;
-- } else {
-- hi = mid;
-- }
-- }
-- return hi;
-- }
--
-- parse : function (timestamp) { momentz port//
------var target  = +timestamp,
--------offsets = this.offsets,
--------untils  = this.untils,
--------max     = untils.length - 1,
--------offset, offsetNext, offsetPrev, i;
------for (i = 0; i < max; i++) {
--------offset     = offsets[i];
--------offsetNext = offsets[i + 1];
--------offsetPrev = offsets[i ? i - 1 : i];
--------if (offset < offsetNext && tz.moveAmbiguousForward) { //flag false 
----------offset = offsetNext;
--------} else if (offset > offsetPrev && tz.moveInvalidForward) {//true 
----------offset = offsetPrev;
--------}
--------if (target < untils[i] - (offset * 60000)) {  //timestamp  seemed UTC-ofset 
----------return offsets[i];
--------}
------}
------return offsets[max];
----},

function binary_search_right(arr, target)
    local left = 1
    local right = #arr
    local result = nil

    while left <= right do
        local mid = math.floor((left + right) / 2)

        if arr[mid] <= target then
            -- 常に右側を優先して探索
            left = mid + 1
            result = mid
        else
            right = mid - 1
        end
    end

    -- 最も右側のターゲット値のインデックスを返す
    return result
end

function binary_search_right_w_offset(arr, offset, target)
    local left = 1
    local right = #arr
    local result = nil

    while left <= right do
        local mid = math.floor((left + right) / 2)

        if (arr[mid] - tz_offsets[mid + 1] * 60 * 1000 <= target) then
            -- 常に右側を優先して探索
            left = mid + 1
            result = mid
        else
            right = mid - 1
        end
    end

    -- 最も右側のターゲット値のインデックスを返す
    return result
end

-- https://claude.ai/chat/952c705a-ed9e-49da-bd87-f99a4a16d707 
function closest_with_offset(num)
    local len = #tz_untils
    if num < tz_untils[1] + tz_offsets[2] then
        return 1

    elseif len > 1 and num >= tz_untils[len - 1] + tz_offsets[len] then -- and tz_untils[len] == math.huge
        return len
    elseif (num >= tz_untils[len]) then
        return -1
    end

    return binary_search_right_w_offset(tz_untils, tz_offsets, num)
end

function get_pst_idx(timestamp)
    if (tz_len == 0) then
        return 1 -- JSTだけとか
    end

    tmp_idx = closest_with_offset(timestamp)
    if (tmp_idx < 1) then tmp_idx = 1 end
    if (tmp_idx > #tz_untils - 1) then tmp_idx = #tz_untils - 1 end

    -- debugtxt2 = tz_untils[tmp_idx]
    tmp_idx = tmp_idx + 1

    -- debugtxt = timestamp
    -- debugtxt3 = tz_offsets[tmp_idx]

    return tmp_idx
end

-- Binary search to find the current time zone transition index
local function closest(timestamp)
    local len = #tz_untils
    if timestamp < tz_untils[1] then return 1 end
    if timestamp > tz_untils[len - 1] then return math.huge end

    return binary_search_right(tz_untils, timestamp)
end

function get_pst(timestamp)
    -- UTCのバイナリ処理
    if (#tz_untils == 1) then
        tz_idx = 1
        return tz_offsets[1] / (-60)
    end

    tz_idx = closest(timestamp)
    if (tz_idx < 1) then
        tz_idx = 1
        return tz_offsets[1] / (-60)
    end
    if (tz_idx > #tz_untils - 1 or constant_posix == true) then
        if (posix_tz_string and posix_tz_string ~= "" and posix_vs_fallback ==
            true) then
            posix_offset, posix_abbr = getOffsetForLocalDateWithPosixTZ(
                                           timestamp / 1000, posix_tz_string)

            return posix_offset / -60
        end

        tz_idx = #tz_untils - 1
        tz_idx = tz_idx + 1
        return tz_offsets[tz_idx] / (-60)
    end

    tz_idx = tz_idx + 1

    return tz_offsets[tz_idx] / (-60)
end

-- パーサー Invalid/ambigousを考慮する場合　momentのデフォルト、さいしょのソース　せんけいたんさく
function get_pst_parser_strict(timestamp)
    target = tonumber(timestamp)
    max = tonumber(#tz_untils) - 1
    offsetPrev = tz_offsets[1]
    for i = 1, max do

        offset = tz_offsets[i]
        -- offsetNext = offsets[i + 1]
        if (i > 2) then offsetPrev = tz_offsets[i - 1] end

        -- if (offset < offsetNext && tz.moveAmbiguousForward) {　//moveAmbiguousForwardはでふぉだとオフ
        -- offset = offsetNext;
        if (offset > offsetPrev) then -- else if (offset > offsetPrev && tz_moveInvalidForward) {
            offset = offsetPrev;
        end
        if (target < tz_untils[i] - (offset * 60000)) then -- tz_untils[i]だけ totzzonetime (2025/01/26).tz,tz_untils[i] - (offset * 60000) でzoneparse 2025/01/26=>2025/01/26TZ
            return timestamp + tz_offsets[i] * (-3600)
        end
    end
    return timestamp + tz_offsets[max] * (-3600)
end

function get_final_pst(timestamp)
    -- UTCのバイナリ処理
    if (#tz_untils == 1) then
        tz_idx = 1
        return tz_offsets[1] / (-60)
    end

    tz_idx = #tz_untils

    return tz_offsets[tz_idx] / (-60)
end

function get_tz_abbr(idx)
    if (idx < 1) then idx = 1 end
    if (tz_idx > #tz_untils - 1 or constant_posix == true) then
        if (posix_tz_string and posix_tz_string ~= "" and posix_vs_fallback ==
            true) then return posix_abbr end

        tz_idx = #tz_untils 
    end

    
    --obs.script_log(obs.LOG_INFO, "tm: " .. tz_abbrs[#tz_untils-1])
    --obs.script_log(obs.LOG_INFO, "tm: " .. tostring(idx))

    return tz_abbrs[idx]
end

function get_tzoffset(timezone)
    local h, m = math.modf(timezone / 3600)
    return string.format("%+.4d", 100 * h + 60 * m)
end

-- Zellerの公式で曜日を計算（0=Sunday, 1=Monday, ..., 6=Saturday）
local function get_weekday(year, month, day)
    if month < 3 then
        month = month + 12
        year = year - 1
    end
    local d = day
    local m = month
    local y = year
    local f =
        (y + math.floor(y / 4) - math.floor(y / 100) + math.floor(y / 400) +
            math.floor((13 * m + 8) / 5 + d)) % 7;
    return f
end

-- https://grok.com/chat/56eda762-0177-41eb-ad70-2d027bd15df4
-- フェアフィールドの定理を応用した年推定関数
local function estimate_year(adjusted_time)
    local avg_seconds_per_year = 31556952 -- 365.2425日 × 86400秒
    local years_offset = math.floor(adjusted_time / avg_seconds_per_year)
    return 1970 + years_offset - 1
end

-- 年のエポック秒を計算する補助関数
local function get_year_epoch(year) return preset_fairfield_dateutc(year, 1, 1) end

function get_time_components(timestamp, offset_seconds)
    if tonumber(timestamp) == nil or tonumber(offset_seconds) == nil then
        obs.script_log(obs.LOG_ERROR, "Invalid input")
        return nil
    end

    -- タイムスタンプにオフセットを適用
    local adjusted_time = timestamp
    local seconds_per_day = 86400
    local total_days = math.floor(adjusted_time / seconds_per_day)
    local remaining_seconds = adjusted_time % seconds_per_day

    -- 負の残り秒を補正
    if remaining_seconds < 0 then
        total_days = total_days - 1
        remaining_seconds = remaining_seconds + seconds_per_day
    end

    -- 時間、分、秒を計算
    local hours = math.floor(remaining_seconds / 3600)
    local minutes = math.floor((remaining_seconds % 3600) / 60)
    local seconds = remaining_seconds % 60

    -- 年の推定（365.2425日ベース）
    local year = estimate_year(adjusted_time)

    -- 年の調整
    while true do
        local year_start = get_year_epoch(year)
        local next_year_start = get_year_epoch(year + 1)

        if adjusted_time >= year_start and adjusted_time < next_year_start then
            break
        elseif adjusted_time < year_start then
            year = year - 1
        else
            year = year + 1
        end
    end

    -- 残り日数の計算
    local days_left = math.floor((adjusted_time - get_year_epoch(year)) /
                                     seconds_per_day)

    -- 月と日を計算
    local days_in_month = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    if year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0) then
        days_in_month[2] = 29 -- 閏年対応
    end
    local month = 1
    while days_left >= days_in_month[month] do
        days_left = days_left - days_in_month[month]
        month = month + 1
    end
    local day = days_left + 1

    -- 曜日計算（仮に既存関数を利用）
    local wday = get_weekday(year, month, day)
    --[[
    obs.script_log(obs.LOG_INFO, "tm: " .. tostring(timestamp))
    obs.script_log(obs.LOG_INFO, "year: " .. tostring(year))
    obs.script_log(obs.LOG_INFO, "m: " .. tostring(month))
    obs.script_log(obs.LOG_INFO, "d: " .. tostring(day))
    obs.script_log(obs.LOG_INFO, "h: " .. tostring(hours))
    obs.script_log(obs.LOG_INFO, "m: " .. tostring(minutes))
    obs.script_log(obs.LOG_INFO, "s: " .. tostring(seconds))
    obs.script_log(obs.LOG_INFO, "w: " .. tostring(wday))
    ]]

    return {
        year = year,
        month = month,
        day = day,
        hour = hours,
        minute = minutes,
        second = seconds,
        wday = wday + 1,
        offset = offset_seconds
    }
end

-- strftime風のフォーマット関数
function strftime(format, timestamp, offset_hours)
    local offset_seconds = offset_hours * 3600
    local components = get_time_components(timestamp, offset_seconds)
    if components == nil then return nil end
    local months = {
        "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct",
        "Nov", "Dec"
    }
    local weekdays = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"}
    -- フォーマット置換
    local result = format
    result = result:gsub("%%Y", string.format("%04d", components.year))
    result = result:gsub("%%b", months[tonumber(components.month)])
    result = result:gsub("%%m", string.format("%02d", components.month))
    result = result:gsub("%%d", string.format("%02d", components.day))
    result = result:gsub("%%H", string.format("%02d", components.hour))
    result = result:gsub("%%M", string.format("%02d", components.minute))
    result = result:gsub("%%S", string.format("%02d", components.second))
    result = result:gsub("%%S", string.format("%02d", components.second))
    if (tz_idx == math.huge) then
        result = result:gsub("%%Z", posix_abbr)
    else
        result = result:gsub("%%Z", tz_abbrs[tz_idx])
    end
    local int_part, frac_part = math.modf(offset_hours) -- 整数部と小数部に分割
    local minutes = math.floor(math.abs(frac_part) * 60 + 0.5) -- 小数部を60倍し四捨五入
    local formatted = string.format("%+02d:%02d", int_part, minutes) -- フォーマット
    result = result:gsub("%%z", formatted)
    result = result:gsub("%%a", weekdays[components.wday])

    return result
end

function tznow(format_str, utc_time)

    local offset_hours = get_pst(utc_time * 1000)
    local timestamp = utc_time + offset_hours * 3600

    local result = strftime(format_str, timestamp, offset_hours)

    if result ~= nil then
        return result
    else
        return "Invalid Time"
    end

end

function set_time_text()
    local text = para_text
    local elaspted = get_timestring(lefttime(starttime) * -1, format)
    local left = get_timestring(lefttime(finaltime), format)

    local ibetime = checkdate(lefttime(starttime), lefttime(finaltime))
    local prog = ""
    local bar = ""
    if (ibetime == true) then
        ibetime = get_timestring(parse_json_date_utc(finaltime) -
                                     parse_json_date_utc(starttime), format)
        prog = string.format("%2.2f", math.abs(
                                 lefttime(starttime) /
                                     (parse_json_date_utc(finaltime) -
                                         parse_json_date_utc(starttime)) * 100))

        if (parse_json_date_utc(starttime) >= os.time()) then
            prog = 0
            left = get_timestring(parse_json_date_utc(finaltime) -
                                      parse_json_date_utc(starttime), format)
            elaspted = get_timestring(0, format)
        end
        if (tonumber(prog) > 100) then
            prog = 100
            elaspted = get_timestring(parse_json_date_utc(finaltime) -
                                          parse_json_date_utc(starttime), format)
            if (end_text ~= "") then
                left = end_text
            else
                left = get_timestring(0, format)
            end
        end
        bar = makebar(prog)
    end

    local utc_times = os.time()
    pst = get_pst(utc_times * 1000)
    tz_st = get_tz_abbr(tz_idx)

    --[[
    obs.script_log(obs.LOG_INFO, "pst" .. pst)
    obs.script_log(obs.LOG_INFO, "u" .. tz_untils[tz_idx - 1])
    obs.script_log(obs.LOG_INFO, "o" .. tz_offsets[tz_idx])
    obs.script_log(obs.LOG_INFO, "a" .. tz_abbrs[tz_idx])
    obs.script_log(obs.LOG_INFO, "a" .. tzst)
    --]]

    local time_textq = string.gsub(time_text, format_string_avoid_crash, "")
    local time_textj = "!" .. string.gsub(time_textq, "%%z", "+0900")
    local time_textu = "!" ..
                           string.gsub(time_textq, "%%z",
                                       get_tzoffset(utc * 3600))

    local time_textp = "!" .. (string.gsub(time_textq, "%%zz", tz_st) or "Invalid tz_st")
    time_textp = string.gsub(time_textp, "%%z", get_tzoffset(pst * 3600))

    local negative_local = os.date(time_textq, utc_times) -- local negative not work
    if (negative_local == nil) then
        text = string.gsub(text, "%%N", "negative_local not supported:nil")
    else
        text = string.gsub(text, "%%N", negative_local)
    end
    text = string.gsub(text, "%%TZN", tznow(time_text, utc_times) or "Invalid TZN")
    text = string.gsub(text, "%%TZ", os.date(time_textp, utc_times + pst * 3600) or "Invalid TZ")
    text = string.gsub(text, "%%JST", os.date(time_textj, utc_times + 9 * 3600) or "Invalid JST")
    text = string.gsub(text, "%%UTC", os.date(time_textu, utc_times + utc * 3600) or "Invalid UTC")

    if (tz_len > 0) then -- #tz_untilslen>=2
        pst = get_final_pst(tz_untils[tz_len] / 1000)
        tz_st = tz_abbrs[tz_len + 1]
        local time_textpp = "!" .. string.gsub(time_textq, "%%zz", tz_st)
        time_textpp = string.gsub(time_textpp, "%%z", get_tzoffset(pst * 3600))
        local timestamp = tz_untils[tz_len] / 1000 + pst * 3600
        local offset_str = get_tzoffset(pst * 3600)
        local date_str = os.date(time_textpp, timestamp)
        -- Debug logs
        --[[
        obs.script_log(obs.LOG_INFO, "time_textpp: " .. tostring(time_textpp))
        obs.script_log(obs.LOG_INFO, "tz_len: " .. tostring(tz_len))
        obs.script_log(obs.LOG_INFO,
                       "tz_untils[tz_len]: " .. tostring(tz_untils[tz_len]))
        obs.script_log(obs.LOG_INFO, "timestamp: " .. tostring(timestamp))
        obs.script_log(obs.LOG_INFO, "pst: " .. tostring(pst))
        obs.script_log(obs.LOG_INFO, "tz_st: " .. tostring(tz_st))
        obs.script_log(obs.LOG_INFO, "date_str: " .. tostring(date_str))
        ]]

        -- if (true == false) then -- date_str ~= nil and offset_str ~= nil then  
        --    text = string.gsub(text, "%%EXP", date_str .. " " .. offset_str)

        local offset_hours = pst
        local format_str = "%Y-%m-%dT%H:%M:%S%z %a %Z"
        local result = strftime(format_str, timestamp, offset_hours)

        -- obs.script_log(obs.LOG_INFO, "result: " .. tostring(result))

        if result ~= nil then
            text = string.gsub(text, "%%EXP", result)
        else
            text = string.gsub(text, "%%EXP", "input:" .. timestamp ..
                                   " os.date not supported")
        end
    else
        if tz_untils[1] == math.huge or tonumber(tz_untils[1]) == nil then
            text = string.gsub(text, "%%EXP", tz_untils[1])
        else
            pst = tz_offsets[1]
            local timestamp = tz_untils[1] / 1000 + pst * 3600
            local offset_hours = pst
            local format_str = "%Y-%m-%dT%H:%M:%S%z %a %Z"
            local result = strftime(format_str, timestamp, offset_hours)
            --[[
            obs.script_log(obs.LOG_INFO, "pst: " .. tostring(pst))
            obs.script_log(obs.LOG_INFO, "tz_st: " .. tostring(timestamp))
            obs.script_log(obs.LOG_INFO, "result: " .. tostring(result))
            ]]
            if result ~= nil then
                text = string.gsub(text, "%%EXP", result)
            end
        end
    end

    text = string.gsub(text, "%%I", ibetime)
    text = string.gsub(text, "%%T", title)
    text = string.gsub(text, "%%K", elaspted)
    text = string.gsub(text, "%%L", left)
    text = string.gsub(text, "%%P", prog)
    text = string.gsub(text, "%%Q", bar)

    if (parse_json_date_utc(starttime) == "Invalid date") then
        text = string.gsub(text, "%%SJ?", "Invalid date")
    else
        pstst = get_pst(parse_json_date_utc(starttime) * 1000)
        tz_st = get_tz_abbr(tz_idx)
        local time_textps = "!" .. string.gsub(time_textq, "%%zz", tz_st)
        time_textps =
            string.gsub(time_textps, "%%z", get_tzoffset(pstst * 3600))
        text = string.gsub(text, "%%SS", os.date(time_textps,
                                                 parse_json_date_utc(starttime) +
                                                     pstst * 3600))
        text = string.gsub(text, "%%SU", os.date(time_textu,
                                                 parse_json_date_utc(starttime) +
                                                     utc * 3600))
        text = string.gsub(text, "%%SJ", os.date(time_textj,
                                                 parse_json_date_utc(starttime) +
                                                     9 * 3600))
        text = string.gsub(text, "%%S",
                           os.date(time_textq, parse_json_date_utc(starttime)))
    end

    if (parse_json_date_utc(finaltime) == "Invalid date") then
        text = string.gsub(text, "%%EJ?", "Invalid date")
    else
        psten = get_pst(parse_json_date_utc(finaltime) * 1000)
        tz_st = get_tz_abbr(tz_idx)

        text = string.gsub(text, "%%DB3", debugtxt3)
        text = string.gsub(text, "%%DB2", debugtxt2)
        text = string.gsub(text, "%%DB", debugtxt)

        local time_textpe = "!" .. string.gsub(time_textq, "%%zz", tz_st)
        time_textpe =
            string.gsub(time_textpe, "%%z", get_tzoffset(psten * 3600))
        text = string.gsub(text, "%%EE", os.date(time_textpe,
                                                 parse_json_date_utc(finaltime) +
                                                     psten * 3600))
        text = string.gsub(text, "%%EU", os.date(time_textu,
                                                 parse_json_date_utc(finaltime) +
                                                     utc * 3600))
        text = string.gsub(text, "%%EJ", os.date(time_textj,
                                                 parse_json_date_utc(finaltime) +
                                                     9 * 3600))
        text = string.gsub(text, "%%E",
                           os.date(time_textq, parse_json_date_utc(finaltime)))
    end

    text = string.gsub(text, osdate_avoid_crash, "") -- フリーズ文字 %%[EJKLNOPQfikloqsvZ]

    text = os.date(text)

    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
end

function timer_callback()

    total = total - 1

    if total < 1 then
        -- stop_timer()
        total = 0
    end

    set_time_text()
end

function start_timer()
    timer_active = true
    obs.timer_add(timer_callback, 100)
end

function stop_timer()
    timer_active = false
    obs.timer_remove(timer_callback)
end

function on_event(event)
    if event == obs.OBS_FRONTEND_EVENT_STREAMING_STARTED then
        if mode == "Streaming timer" then
            total = 0
            stop_timer()
            start_timer()
        end
    elseif event == obs.OBS_FRONTEND_EVENT_STREAMING_STOPPED then
        if mode == "Streaming timer" then stop_timer() end
    elseif event == obs.OBS_FRONTEND_EVENT_RECORDING_STARTED then
        if mode == "Recording timer" then
            total = 0
            stop_timer()
            start_timer()
        end
    elseif event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPED then
        if mode == "Recording timer" then stop_timer() end
    end
end

function activate(activating)
    if activated == activating then return end

    activated = activating

    if activating then
        if global then return end

        total = total_seconds

        stop_timer()
        start_timer()
    end
end

function activate_signal(cd, activating)
    local source = obs.calldata_source(cd, "source")
    if source ~= nil then
        local name = obs.obs_source_get_name(source)
        if (name == source_name) then activate(activating) end
    end
end

function source_activated(cd) activate_signal(cd, true) end

function source_deactivated(cd) activate_signal(cd, false) end

function reset(pressed)
    if not pressed then return end

    if mode == "Countdown" then
        -- local t= lefttime(finaltime)
        total_seconds = total_seconds + 1
    end

    total = total_seconds
    stop_timer()
    set_time_text()
end

function on_pause(pressed)
    if not pressed then return end

    if timer_active then
        stop_timer()
    else
        stop_timer()
        start_timer()
    end
end

function pause_button_clicked(props, p)
    on_pause(true)
    return false
end

function reset_button_clicked(props, p)
    reset(true)
    return false
end

function lefttime(dt)
    local timedata = parse_json_date_utc(dt)
    if (type(timedata) == "string") then return dt end
    local t = timedata - os.time()
    return t
end

function elasped(dt)
    local timedata = parse_json_date_utc(dt)
    if (type(timedata) == "string") then return dt end
    local t = timedata - os.time()
    return -t
end

-- custum timetable
function timezoneparse(tz)
    local timezone = {
        {"ACDT", "+1030"}, {"ACST", "+0930"}, {"AEDT", "+1100"},
        {"AEST", "+1000"}, {"AFT", "+0430"}, {"AKDT", "-0800"},
        {"AKST", "-0900"}, {"ART", "-0300"}, {"AWDT", "+0900"},
        {"AWST", "+0800"}, {"BDT", "+0600"}, {"BNT", "+0800"}, {"BOT", "-0400"},
        {"BRT", "-0300"}, {"BST", "+0100"}, {"BTT", "+0600"}, {"CAT", "+0200"},
        {"CCT", "+0630"}, {"cDT", "-0400"}, {"CDT", "-0500"}, {"CEST", "+0200"},
        {"CET", "+0100"}, {"CLST", "-0300"}, {"CLT", "-0400"}, {"COT", "-0500"},
        {"cst", "+0800"}, {"cST", "-0500"}, {"CST", "-0600"}, {"ChST", "+1000"},
        {"EAT", "+0300"}, {"ECT", "-0500"}, {"EDT", "-0400"}, {"EEST", "+0300"},
        {"EET", "+0200"}, {"EST", "-0500"}, {"FJST", "+1300"}, {"FJT", "+1200"},
        {"GMT", "+0000"}, {"GST", "+0400"}, {"HKT", "+0800"}, {"HST", "-1000"},
        {"ICT", "+0700"}, {"IDT", "+0300"}, {"iST", "+0200"}, {"IST", "+0530"},
        {"IRDT", "+0430"}, {"IRST", "+0330"}, {"JST", "+0900"},
        {"KST", "+0900"}, {"MDT", "-0600"}, {"MMT", "+0630"}, {"MST", "-0700"},
        {"MYT", "+0800"}, {"NPT", "+0545"}, {"NZDT", "+1300"},
        {"NZST", "+1200"}, {"PDT", "-0700"}, {"PET", "-0500"}, {"PHT", "+0800"},
        {"PKT", "+0500"}, {"PST", "-0800"}, {"PWT", "+0900"}, {"SST", "-1100"},
        {"UT", "+0000"}, {"UTC", "+0000"}, {"UYT", "-0300"}, {"WAT", "+0100"},
        {"WEST", "+0100"}, {"WET", "+0000"}, {"WIB", "+0700"}, {"WIT", "+0900"},
        {"WITA", "+0800"}
    }
    -- %a%a+$ paturn fix

    if (tz == "UU") then return get_tzoffset(utc * 3600) end

    stlen = tonumber(#timezone)
    for i = 1, stlen do
        if (tz == timezone[i][1]) then return timezone[i][2] end
    end

    return nil
end

-- https://claude.ai/chat/805aaf7b-938a-486f-afe0-3109f98fb181
-- RFC 2822 date parser
-- Example input: "Tue, 15 Nov 1994 08:12:31 +0200"

local months = {
    Jan = 1,
    Feb = 2,
    Mar = 3,
    Apr = 4,
    May = 5,
    Jun = 6,
    Jul = 7,
    Aug = 8,
    Sep = 9,
    Oct = 10,
    Nov = 11,
    Dec = 12
}

local weekdays = {Sun = 0, Mon = 1, Tue = 2, Wed = 3, Thu = 4, Fri = 5, Sat = 6}

local function parse_timezone(tz)

    -- Parse numeric timezone (+0200 format)
    local sign, hour, min = tz:match("([+-])(%d%d)(%d%d)")
    if (sign) then
    else
        local tzval = timezoneparse(tz)
        if (tzval) then
            sign, hour, min = tzval:match("([+-])(%d%d)(%d%d)")
        end
    end

    if sign and hour and min then
        local offset = tonumber(hour) * 3600 + tonumber(min) * 60
        return sign == "+" and offset or -offset
    end

    return nil
end

local function parse_rfc2822_date(date_string)
    -- Remove optional weekday and comma
    date_string = date_string:gsub("^%w+,%s*", "")

    local ymd = "(%d+)%s+(%a+)%s+(%d+)%s+([%a%d+-]+)" -- ローカル時間MD
    local ymdh = "(%d+)%s+(%a+)%s+(%d+)%s+(%d+)%s+([%a%d+-]+)" -- ローカル時間MD+h
    local ymdhm = "(%d+)%s+(%a+)%s+(%d+)%s+(%d+):(%d+)%s+([%a%d+-]+)" -- ローカル時間MD+HM
    local ymdhms = "(%d+)%s+(%a+)%s+(%d+)%s+(%d+):(%d+):(%d+)%s+([%a%d+-]+)" -- ローカル時間MDhms

    local day, month, year, hour, min, sec, tz
    if (date_string:match(ymdhms)) then
        day, month, year, hour, min, sec, tz = date_string:match(ymdhms)
    elseif (date_string:match(ymdhm)) then
        day, month, year, hour, min, tz = date_string:match(ymdhm)
        sec = 0
    elseif (date_string:match(ymdh)) then
        day, month, year, hour, tz = date_string:match(ymdh)
        min, sec = 0, 0
    elseif (date_string:match(ymd)) then
        day, month, year, tz = date_string:match(ymd)
        hour, min, sec = 0, 0, 0
    end

    if not (day and month and year and hour and min and sec and tz) then
        return nil, "Invalid date format"
    end

    -- Convert components to numbers
    day = tonumber(day)
    year = tonumber(year)
    hour = tonumber(hour)
    min = tonumber(min)
    sec = tonumber(sec)

    -- Convert month name to number
    month = months[month]
    if not month then return nil, "Invalid month name" end

    -- Validate ranges
    if day < 1 or day > 31 or hour < 0 or hour > 23 or min < 0 or min > 59 or
        sec < 0 or sec > 59 then return nil, "Component out of range" end

    -- Handle two-digit years
    if year < 100 then year = year + (year >= 50 and 1900 or 2000) end

    -- Parse timezone
    local tz_offset = parse_timezone(tz)
    if not tz_offset then return nil, "Invalid timezone" end

    -- Return a table with parsed components
    return {
        year = year,
        month = month,
        day = day,
        hour = hour,
        min = min,
        sec = sec,
        tz_offset = tz_offset
    }
end

-- Example usage
local function test_parser()
    local test_dates = {
        -- "Tue, 15 Nov 1994 08:12:31 +0200",  -- With seconds
        -- "16 Nov 1994 08:12 GMT",            -- Without seconds
        -- "17 Nov 94 08:12:31 EST",           -- With seconds, 2-digit year
        -- "18 Nov 94 08:12 EDT",              -- Without seconds, 2-digit year
        -- "19 Nov 94 08 EDT",              -- Without seconds, 2-digit year
        -- "11 Nov 94 EDT",              -- Without seconds, 2-digit year
        "28 Nov 2024 22:00:00 JST", "28 Nov 2024 22:00 JST",
        "28 Nov 2024 22 +0900"
    }
    -- 2024/11/28 22:00:00   28 Nov 2024 22:00:00 JST
    for _, date in ipairs(test_dates) do
        local result, err = parse_rfc2822_date(date)
        if result then
            print("Year:" .. result.year)
            print("Month:" .. result.month)
            print("Day:" .. result.day)
            print("Hour:" .. result.hour)
            print("Minute:" .. result.min)
            print("Second:" .. result.sec)
            print("Timezone offset (seconds):" .. result.tz_offset)
        else
            print("Error:" .. err)
        end
    end
end

function parse_json_date_utc(json_date)
    local pattern =
        "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%+%-])(%d?%d?)%:?(%d?%d?)"

    if (json_date:match(pattern) == nil) then
        if (json_date:match(
            "(%d+)%s+(%a+)%s+(%d+)(%s*%d*)(:?%d*)(:?%d*)%s+([%a%d+-]+)")) then -- RFC2822
            local date, err = parse_rfc2822_date(json_date)
            if (date) then
                return
                    preset_fairfield_dateutc(date.year, date.month, date.day) -
                        date.tz_offset + date.hour * 3600 + date.min * 60 +
                        date.sec
            else
                return "Invalid date"
            end
        end

        if (json_date:match("%s?%a%a+$")) then -- try parse UTC FIX
            local normal =
                "(%d+)[%-%/](%d+)[%-%/](%d+) +(%d+)%:(%d+)%s?(%a%a+)$" -- ローカル時間MD+HM
            if (json_date:match(normal)) then
                local year, month, day, hour, min, tz = json_date:match(normal)

                -- zone_parser minimum
                if (tz == useTZ or tz == TZ or tz == town_name) then
                    if (tonumber(year) and tonumber(month) and tonumber(day)) then
                        if (tonumber(month) > 0 and tonumber(month) <= 12) then
                            timestamp = preset_fairfield_dateutc(year, month,
                                                                 day) + hour *
                                            3600 + min * 60
                        end
                    else
                        return "Invalid date"
                    end

                    tmp_idx = get_pst_idx(timestamp * 1000)

                    offset = tz_offsets[tmp_idx] * (-60)
                    return timestamp - offset
                end

                local tz_offset = parse_timezone(tz)
                if (tz_offset) then
                    return preset_fairfield_dateutc(year, month, day) -
                               tz_offset + hour * 3600 + min * 60
                else
                    return "Invalid date"
                end
            end
        end

        local unix = "^(%d+)$"
        local normalp = "(%d+)[%-%/](%d+)[%-%/](%d+)$" -- ローカル時間MD
        local normalq = "(%d+)[%-%/](%d+)[%-%/](%d+) +(%d+)$" -- ローカル時間MD+h
        local normal = "(%d+)[%-%/](%d+)[%-%/](%d+) +(%d+)%:(%d+)$" -- ローカル時間MD+HM
        local normalr = "(%d+)[%-%/](%d+)[%-%/](%d+) +(%d+)%:(%d+)%:([%d%.]+)" -- ローカル時間MDhms

        if (json_date:match(normal)) then
            local year, month, day, hour, minute, seconds = json_date:match(
                                                                normal)
            return os.time {
                year = year,
                month = month,
                day = day,
                hour = hour,
                min = minute,
                sec = 0
            }
        end
        if (json_date:match(normalp)) then
            local year, month, day, hour, minute, seconds = json_date:match(
                                                                normalp)
            return os.time {
                year = year,
                month = month,
                day = day,
                hour = 0,
                min = 0,
                sec = 0
            }
        end
        if (json_date:match(normalq)) then
            local year, month, day, hour, minute, seconds = json_date:match(
                                                                normalq)
            return os.time {
                year = year,
                month = month,
                day = day,
                hour = hour,
                min = 0,
                sec = 0
            }
        end
        if (json_date:match(normalr)) then
            local year, month, day, hour, minute, seconds = json_date:match(
                                                                normalr)
            return os.time {
                year = year,
                month = month,
                day = day,
                hour = hour,
                min = minute,
                sec = seconds
            }
        end
        if (json_date:match(unix)) then return json_date end

        return "Invalid date"
    end

    local year, month, day, hour, minute, seconds, offsetsign, offsethour,
          offsetmin = json_date:match(pattern)
    local offset = 0
    if offsetsign ~= 'Z' then
        offset = tonumber(offsethour) * 3600 + tonumber(offsetmin) * 60
        if offsetsign == "-" then offset = offset * -1 end
    end

    -- ymd 1-12月のみパーす
    return preset_fairfield_dateutc(year, month, day) - offset + hour * 3600 +
               minute * 60 + seconds

    -- local temp = os.date("*t",timestamp)
    -- if(temp.isdst) then  --パースした時刻がサマーがしらべる
    -- offset = offset -3600  --0.5サマータイムもあるので（）、オーストラリアだと使えないかも
    -- end
    -- return timestamp + get_timezone() -offset

    -- return timestamp + get_timezone_the_day() -offset

    -- old method ,avoid crrupt dateme in DST timezone, simply time slide method use OSTIME
    -- hourはサマータイム越境時タイムマシンが発生するので最後に足す、幻の2時(2020-03-08T02:00:00) -05:00
    -- https://ja.wikipedia.org/wiki/%E5%A4%8F%E6%99%82%E9%96%93　ブラジルが0時豪州3時なので4時までずらす
    -- local timestamp = os.time{year = year, month = month, day = day, hour = 4, min = minute, sec = seconds}
    -- return timestamp + get_timezone_offset(timestamp) -offset  + (hour-4)*3600
end

function get_timezone_the_day()
    local hh = tonumber(string.format("%d", (tonumber(os.date("%z")) / 100)))
    local mm = ((tonumber(os.date("%z")) - 100 * hh) / 60) * 3600
    local hhmm = hh * 3600 + mm
    return hhmm -- サマー有りタイムゾーン時差情報
end

-- http://lua-users.org/wiki/TimeZone
function get_timezone()
    local now = os.time()
    return os.difftime(now, os.time(os.date("!*t", now))) -- サマーなしタイムゾーン時差情報 現在時間
end

function get_tzoffset(timezone)
    local h, m = math.modf(timezone / 3600)
    return string.format("%+.4d", 100 * h + 60 * m)
end

function get_timezone_offset(ts) -- サマー有りタイムゾーン時差情報 当時の時間
    local utcdate = os.date("!*t", ts)
    local localdate = os.date("*t", ts)
    localdate.isdst = false -- this is the trick
    return os.difftime(os.time(localdate), os.time(utcdate))
end

function settings_modified(props, prop, settings)
    local mode_setting = obs.obs_data_get_string(settings, "mode")
    local p_duration = obs.obs_properties_get(props, "duration")
    local p_hour = obs.obs_properties_get(props, "hour")
    local p_minutes = obs.obs_properties_get(props, "minutes")
    local p_stop_text = obs.obs_properties_get(props, "stop_text")
    local p_a_mode = obs.obs_properties_get(props, "a_mode")
    local button_pause = obs.obs_properties_get(props, "pause_button")
    local button_reset = obs.obs_properties_get(props, "reset_button")

    if (mode_setting == "Countdown") then
        obs.obs_property_set_visible(p_duration, true)
        obs.obs_property_set_visible(p_hour, false)
        obs.obs_property_set_visible(p_minutes, false)
        obs.obs_property_set_visible(p_stop_text, true)
        obs.obs_property_set_visible(button_pause, true)
        obs.obs_property_set_visible(button_reset, true)
        obs.obs_property_set_visible(p_a_mode, true)
    elseif (mode_setting == "Countup") then
        obs.obs_property_set_visible(p_duration, false)
        obs.obs_property_set_visible(p_hour, false)
        obs.obs_property_set_visible(p_minutes, false)
        obs.obs_property_set_visible(p_stop_text, false)
        obs.obs_property_set_visible(button_pause, true)
        obs.obs_property_set_visible(button_reset, true)
        obs.obs_property_set_visible(p_a_mode, true)
    elseif (mode_setting == "Specific time") then
        obs.obs_property_set_visible(p_duration, false)
        obs.obs_property_set_visible(p_hour, true)
        obs.obs_property_set_visible(p_minutes, true)
        obs.obs_property_set_visible(p_stop_text, true)
        obs.obs_property_set_visible(button_pause, true)
        obs.obs_property_set_visible(button_reset, true)
        obs.obs_property_set_visible(p_a_mode, true)
    elseif (mode_setting == "Streaming timer") then
        obs.obs_property_set_visible(p_duration, false)
        obs.obs_property_set_visible(p_hour, false)
        obs.obs_property_set_visible(p_minutes, false)
        obs.obs_property_set_visible(p_stop_text, false)
        obs.obs_property_set_visible(button_pause, false)
        obs.obs_property_set_visible(button_reset, false)
        obs.obs_property_set_visible(p_a_mode, false)
    elseif (mode_setting == "Recording timer") then
        obs.obs_property_set_visible(p_duration, false)
        obs.obs_property_set_visible(p_hour, false)
        obs.obs_property_set_visible(p_minutes, false)
        obs.obs_property_set_visible(p_stop_text, false)
        obs.obs_property_set_visible(button_pause, false)
        obs.obs_property_set_visible(button_reset, false)
        obs.obs_property_set_visible(p_a_mode, false)
    end

    return true
end

function script_properties()

    local props = obs.obs_properties_create()

    local p_mode = obs.obs_properties_add_list(props, "mode", "Mode",
                                               obs.OBS_COMBO_TYPE_EDITABLE,
                                               obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(p_mode, "Countdown", "countdown") -- 右だけ日本語化

    local c_mode = obs.obs_properties_add_list(props, "UTC",
                                               "WorldTime UTC+-??",
                                               obs.OBS_COMBO_TYPE_EDITABLE,
                                               obs.OBS_COMBO_FORMAT_STRING)
    for i = 1, #mstz do
        obs.obs_property_list_add_string(c_mode, mstz[i], mstz[i])
    end

    -- タイムゾーン選択を追加
    local timezone_prop = obslua.obs_properties_add_list(props, "timezone",
                                                         "TIMEZONE",
                                                         obslua.OBS_COMBO_TYPE_EDITABLE,
                                                         obslua.OBS_COMBO_FORMAT_STRING)
    for i = 1, #timezone_strings do
        obs.obs_property_list_add_string(timezone_prop,
                                         timezone_strings[tonumber(i)],
                                         timezone_strings[tonumber(i)])
    end

    obs.obs_property_set_modified_callback(p_mode, settings_modified)
    obs.obs_property_set_long_description(f_prop,
                                          "%d - days\n%hh - hours with leading zero (00..23)\n%h - hours (0..23)\n%HH - hours with leading zero (00..infinity)\n%H - hours (0..infinity)\n%mm - minutes with leading zero (00..59)\n%m - minutes (0..59)\n%MM - minutes with leading zero (00..infinity)\n%M - minutes (0..infinity)\n%ss - seconds with leading zero (00..59)\n%s - seconds (0..59)\n%SS - seconds with leading zero (00..infinity)\n%S - seconds (0..infinity)\n%t - tenths")

    local p = obs.obs_properties_add_list(props, "source", "Text Source",
                                          obs.OBS_COMBO_TYPE_EDITABLE,
                                          obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(p, "[No text source]", "[No text source]")

    local sources = obs.obs_enum_sources()

    if sources ~= nil then
        for _, source in ipairs(sources) do
            name = obs.obs_source_get_name(source)
            source_id = obs.obs_source_get_unversioned_id(source)
            if source_id == "text_gdiplus" or source_id == "text_ft2_source" then
                name = obs.obs_source_get_name(source)
                obs.obs_property_list_add_string(p, name, name)
            end
        end
        obs.source_list_release(sources)
    end

    local p_title_text
    local p_start_text
    local p_stop_text
    local f_prop
    local p_para_text
    local p_time_text

    if (true) then -- ENGLISH MODE delete if(false), use if(true)
        p_title_text = obs.obs_properties_add_text(props, "title_text",
                                                   "EVENT NAME:",
                                                   obs.OBS_TEXT_DEFAULT)
        p_start_text = obs.obs_properties_add_text(props, "start_text",
                                                   "START:ex　2020-02-26 15:00 PST",
                                                   obs.OBS_TEXT_DEFAULT)
        p_stop_text = obs.obs_properties_add_text(props, "stop_text",
                                                  "END:ex　2020-03-26 21:00 PDT",
                                                  obs.OBS_TEXT_DEFAULT)
        f_prop = obs.obs_properties_add_text(props, "format",
                                             "ELASPED/LEFT format",
                                             obs.OBS_TEXT_DEFAULT)
        p_para_text = obs.obs_properties_add_text(props, "para_text",
                                                  "TIME parameter:",
                                                  obs.OBS_TEXT_MULTILINE)
        local time_mode = obs.obs_properties_add_list(props, "time_text",
                                                      "TIME format:",
                                                      obs.OBS_COMBO_TYPE_EDITABLE,
                                                      obs.OBS_COMBO_FORMAT_STRING)
        for i = 1, #dateformat do
            obs.obs_property_list_add_string(time_mode, dateformat[i],
                                             dateformat[i])
        end
        p_end_text = obs.obs_properties_add_text(props, "end_text",
                                                 "STOP text:(empty not use)",
                                                 obs.OBS_TEXT_DEFAULT)
    else
        p_title_text = obs.obs_properties_add_text(props, "title_text",
                                                   "イベント名:",
                                                   obs.OBS_TEXT_DEFAULT)
        p_start_text = obs.obs_properties_add_text(props, "start_text",
                                                   "開始時間:例　2020-02-26T15:00:00+09:00",
                                                   obs.OBS_TEXT_DEFAULT)
        p_stop_text = obs.obs_properties_add_text(props, "stop_text",
                                                  "終了時間:例　2020/02/26 21:00 JST",
                                                  obs.OBS_TEXT_DEFAULT)
        f_prop = obs.obs_properties_add_text(props, "format",
                                             "経過/残表示形式",
                                             obs.OBS_TEXT_DEFAULT)
        p_para_text = obs.obs_properties_add_text(props, "para_text",
                                                  "表示する時間:",
                                                  obs.OBS_TEXT_MULTILINE)
        local time_mode = obs.obs_properties_add_list(props, "time_text",
                                                      "時刻表記:",
                                                      obs.OBS_COMBO_TYPE_EDITABLE,
                                                      obs.OBS_COMBO_FORMAT_STRING)
        for i = 1, #dateformat do
            obs.obs_property_list_add_string(time_mode, dateformat[i],
                                             dateformat[i])
        end
        p_end_text = obs.obs_properties_add_text(props, "end_text",
                                                 "タイマー停止の文字:(空欄だと未使用)",
                                                 obs.OBS_TEXT_DEFAULT)
    end

    obs.obs_properties_add_int(props, "bar", "PROGRESSBAR(100÷X)", 1, 10, 1)

    local p_a_mode = obs.obs_properties_add_list(props, "a_mode",
                                                 "Activation mode",
                                                 obs.OBS_COMBO_TYPE_EDITABLE,
                                                 obs.OBS_COMBO_FORMAT_STRING)
    obs.obs_property_list_add_string(p_a_mode, "Global (timer always active)",
                                     "global")
    obs.obs_property_list_add_string(p_a_mode, "Start timer on activation",
                                     "start_reset")

    local button_pause = obs.obs_properties_add_button(props, "pause_button",
                                                       "Start/Pause",
                                                       pause_button_clicked)
    local reset_button = obs.obs_properties_add_button(props, "reset_button",
                                                       "Reset",
                                                       reset_button_clicked)

    local tzpath_prop = obslua.obs_properties_add_list(props, "tzpath",
                                                       "tzpath",
                                                       obslua.OBS_COMBO_TYPE_EDITABLE,
                                                       obslua.OBS_COMBO_FORMAT_STRING)
    if (isWindows()) then
        for i = 1, #timezone_tzif_path_suggest_window do
            obs.obs_property_list_add_string(tzpath_prop,
                                             timezone_tzif_path_suggest_window[tonumber(
                                                 i)],
                                             timezone_tzif_path_suggest_window[tonumber(
                                                 i)])
        end
    else

        for i = 1, #timezone_tzif_path_suggest_unix do
            obs.obs_property_list_add_string(tzpath_prop,
                                             timezone_tzif_path_suggest_unix[tonumber(
                                                 i)],
                                             timezone_tzif_path_suggest_unix[tonumber(
                                                 i)])
        end
    end

    obs.obs_property_set_visible(p_time_text, true)
    obs.obs_property_set_visible(p_stop_text, true)
    obs.obs_property_set_visible(p_start_text, true)
    obs.obs_property_set_visible(p_para_text, true)
    obs.obs_property_set_visible(p_title_text, true)
    obs.obs_property_set_visible(p_end_text, true)
    obs.obs_property_set_visible(button_pause, true)
    obs.obs_property_set_visible(button_reset, true)
    obs.obs_property_set_visible(p_a_mode, true)

    return props
end

function script_description()
    return
        "Sets a text source to act as a timer with advanced options. Hotkeys can be set for starting/stopping and to the reset timer.%TZ %SS %EE moment-timezone-with-data-10-year-range.js America/Los_Angeles ONLY PORTED(EXPERIMENTAL)"
    -- を備えたタイマーとして機能するようにテキスト ソースを設定します。ホットキーは開始/停止およびリセット タイマーに設定できます。%TZ %SS %EE moment-timezone-with-data-10-year-range.js America/Los_Angeles ONLY PORTED(EXPERIMENTAL)"
end

-- function script_description()
--   return "複数タイムゾーン対応イベント期間タイマー"
-- end

-- スクリプトの残りの部分でタイムゾーン関数を使用
-- Los Angeles特有のbisect検索の代わりに、以下を使用します：
-- local offset, is_dst, abbr = get_timezone_offset_for_timestamp(settings.timezone, timestamp)

function cut_string(s, max)
    if (#s >= max) then s = s:sub(1, max) end

    return s
end

function script_update(settings)
    stop_timer()

    mode = obs.obs_data_get_string(settings, "mode")
    a_mode = obs.obs_data_get_string(settings, "a_mode")
    utc_st = obs.obs_data_get_string(settings, "UTC")
    local sign, hour, min = utc_st:match("^UTC([+-])(%d%d):?(%d%d)")
    utc = 0
    if (hour == nil) then
    else
        utc = hour + min / 60
        if (sign == "-") then utc = -utc end
    end

    if mode == "Countdown" then
        local dt =
            cut_string(obs.obs_data_get_string(settings, "stop_text"), 30) -- "2020-02-26T21:00:00+09:00"	
        finaltime = dt
        local t = lefttime(dt)
        if (t == "Invalid date") then

        else
            -- if t<0 then
            -- t=0
            -- end
        end

        total_seconds = total_seconds + 1
        local dt = cut_string(obs.obs_data_get_string(settings, "start_text"),
                              30) -- "2020-02-26T21:00:00+09:00"	
        starttime = dt

    else
        total_seconds = 0
    end

    if a_mode == "Global (timer always active)" then
        global = true
    else
        global = false
    end

    hour = obs.obs_data_get_int(settings, "hour")
    minute = obs.obs_data_get_int(settings, "minutes")
    source_name = cut_string(obs.obs_data_get_string(settings, "source"), 100)
    stop_text = cut_string(obs.obs_data_get_string(settings, "stop_text"), 30)
    end_text = cut_string(obs.obs_data_get_string(settings, "end_text"), 30)
    format = cut_string(obs.obs_data_get_string(settings, "format"), 100)
    title = cut_string(obs.obs_data_get_string(settings, "title_text"), 100)
    para_text = cut_string(obs.obs_data_get_string(settings, "para_text"), 255)
    time_text = cut_string(obs.obs_data_get_string(settings, "time_text"), 100)
    obsbar = obs.obs_data_get_int(settings, "bar")
    timezone = obs.obs_data_get_string(settings, "timezone")
    timezone_tzif_path = obs.obs_data_get_string(settings, "tzpath")

    if (timezone ~= nil) then load_timezone(timezone) end

    set_time_text()

    reset(true)
end

function script_defaults(settings)
    obs.obs_data_set_default_string(settings, "UTC", "UTC-08:00")
    obs.obs_data_set_default_string(settings, "start_text",
                                    "2024-12-10 15:00PST")
    obs.obs_data_set_default_string(settings, "stop_text", "2024-12-18 21:00PST")
    obs.obs_data_set_default_string(settings, "mode", "Countdown")
    obs.obs_data_set_default_string(settings, "a_mode",
                                    "Global (timer always active)")
    obs.obs_data_set_default_string(settings, "format",
                                    "%d %hh:%mm:%ss(%hsH,%dsD)")
    obs.obs_data_set_default_string(settings, "title_text",
                                    "あっちこっち飼育員体験！")
    obs.obs_data_set_default_string(settings, "time_text",
                                    "%Y-%m-%dT%H:%M:%S%z (%a)")
    obs.obs_data_set_default_string(settings, "para_text",
                                    "DATENNOW:%TZ\nEND     :%EE\nELAPSED :%K\nLEFT    :%L\nDURATION:%I\n%T%P％\n%Q")
    obs.obs_data_set_default_string(settings, "end_text", "THE EVENT HAS ENDED")
    obs.obs_data_set_default_double(settings, "bar", 2)
    obs.obs_data_set_default_string(settings, "timezone", "America/Los_Angeles")
    obs.obs_data_set_default_string(settings, "tzpath", timezone_tzif_path)

end

function script_save(settings)
    local hotkey_save_array_reset = obs.obs_hotkey_save(hotkey_id_reset)
    local hotkey_save_array_pause = obs.obs_hotkey_save(hotkey_id_pause)
    obs.obs_data_set_array(settings, "reset_hotkey", hotkey_save_array_reset)
    obs.obs_data_set_array(settings, "pause_hotkey", hotkey_save_array_pause)
    obs.obs_data_array_release(hotkey_save_array_pause)
    obs.obs_data_array_release(hotkey_save_array_reset)
end

function script_load(settings)
    local sh = obs.obs_get_signal_handler()
    obs.signal_handler_connect(sh, "source_activate", source_activated)
    obs.signal_handler_connect(sh, "source_deactivate", source_deactivated)

    hotkey_id_reset = obs.obs_hotkey_register_frontend("reset_timer_thingy",
                                                       "Reset Timer", reset)
    hotkey_id_pause = obs.obs_hotkey_register_frontend("pause_timer",
                                                       "Start/Stop Timer",
                                                       on_pause)
    local hotkey_save_array_reset = obs.obs_data_get_array(settings,
                                                           "reset_hotkey")
    local hotkey_save_array_pause = obs.obs_data_get_array(settings,
                                                           "pause_hotkey")
    obs.obs_hotkey_load(hotkey_id_reset, hotkey_save_array_reset)
    obs.obs_hotkey_load(hotkey_id_pause, hotkey_save_array_pause)
    obs.obs_data_array_release(hotkey_save_array_reset)
    obs.obs_data_array_release(hotkey_save_array_pause)

    obs.obs_frontend_add_event_callback(on_event)
end
