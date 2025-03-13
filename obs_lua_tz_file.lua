obs = obslua

-- Global variables for time zone data
local source_name = ""
local time_text = ""
local para_text = ""
local timezone = "America/Los_Angeles"
local tz_abbrs = {
    "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST",
    "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT", "PST", "PDT",
    "PST"
}

format_string_avoid_crash = "%%[EJKLNOPQfikloqsvZ]" -- os.date %z Z works unix,but windows never work()
osdate_avoid_crash = "%%[EJKLNOPQfikloqsvzZ]" -- os.date %z Z works unix,but windows never work()

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
tz_len = tonumber(#tz_offsets) - 1
local tz_idx = 1
local tz_st = ""

-- List of available time zones (abbreviated for brevity; expand as needed)
local timezone_strings = {
    "Africa/Abidjan", "America/Los_Angeles", "America/New_York", "Asia/Seoul",
    "Asia/Tokyo", "Europe/London", "Europe/Paris", "Australia/Sydney", "UTC"
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
    "C:/cygwin64/usr/share/zoneinfo/"
}

-- Unix-like paths //printenv または envコマンドで環境変数を確認
timezone_tzif_path_suggest_unix = {
    script_path() .. "zoneinfo/", -- script_path()はこのスクリプトの場所
    "/usr/share/zoneinfo/", "/etc/localtime/",
    "/usr/lib/python312/dist-packages/dateutil/zoneinfo/",
    "/usr/local/lib/python312/dist-packages/dateutil/zoneinfo/",
    "/usr/lib/libreoffice/program/python-core-3.10.16/lib/site-packages/pytz/zoneinfo/",
    "/usr/lib/libreoffice/program/python-core-3.10.16/lib/site-packages/dateutil/zoneinfo/",
    "/Applications/LibreOffice.app/Contents/Resources/python-core-3.10.16/lib/site-packages/pytz/zoneinfo/",
    "/Applications/LibreOffice.app/Contents/Resources/python-core-3.10.16/lib/site-packages/dateutil/zoneinfo/dateutil-zoneinfo.tar/"
}

-- Supported date formats
local dateformat =
    { -- Z work TZN,but unix user work  see format_string_avoid_crash
        "%Y-%m-%d %H:%M:%S %z (%a)", "%m-%d %H:%M", "%H:%M",
        "%Y-%m-%d(%a)%H:%M:%S %z %Z", "%a,%d %b %Y %H:%M:%S %z",
        "%Y-%m-%dT%H:%M:%S%z", -- iso8601
        "%a,%d %b %Y %H:%M:%S %Z"
    }

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
        tz_abbrs[1] = "UTC"
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

local fifteen_nulls = ("\0"):rep(15)
local function read_tz(fd, file_seek)

    assert(fd:seek("set", file_seek))

    assert(fd:read(4) == "TZif", "Invalid TZ file")
    local version = assert(fd:read(1))
    if version == "\0" or version == "2" or version == "3" then
        local MIN_TIME = -2 ^ 32 + 1

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

        -- 64bitDB 使えないので省略、まあ正のあたりだけならつかえる
        -- if version == "2" or version == "3" then
        -- end

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
    obs.script_log(obs.LOG_INFO, "dataOffset: " ..dataOffset)
    obs.script_log(obs.LOG_INFO, "zonetabOffset: " ..zonetabOffset)

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
            obs.script_log(obs.LOG_INFO, "target_offet: " ..target[1])
            obs.script_log(obs.LOG_INFO, "size: " ..target[2])
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

    if header == "tzda" then
        local target = android_tzreader(fd, tzdata) -- Call the previously converted function
        if target[1] == -1 then
            obs.script_log(obs.LOG_INFO, "android tzdata read failed")
            return nil -- Exit the function if target[0] == -1
        end

        file_seek = target[1]
        obs.script_log(obs.LOG_INFO,
                       "android tzdata read success pos:" .. file_seek)
    end

    -- Return updated bs and header if needed (adjust based on your function's purpose)
    return read_tz(fd, file_seek)
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

-- Cache for loaded timezones
local timezone_cache = {}

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

-- Binary search to find the current time zone transition index
local function closest(timestamp)
    local len = #tz_untils
    if timestamp < tz_untils[1] then return 1 end
    if timestamp >= tz_untils[len - 1] then return len end

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
    if (tz_idx > #tz_untils - 1) then
        tz_idx = #tz_untils - 1
        tz_idx = tz_idx + 1

        return tz_offsets[tz_idx] / (-60)
    end

    tz_idx = tz_idx + 1

    return tz_offsets[tz_idx] / (-60)
end

-- Get the current time zone offset in hours
local function get_tz_offset(timestamp)
    if #tz_untils <= 1 then return tz_offsets[1] / -60 end
    tz_idx = closest(timestamp)
    tz_st = tz_abbrs[tz_idx]
    return tz_offsets[tz_idx] / -60
end

-- Format the offset as a string (e.g., "+0800")
local function get_tzoffset(offset_seconds)
    local h, m = math.modf(offset_seconds / 3600)
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

-- 月と日を計算
local days_in_month = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

-- 年のエポック秒を計算する補助関数
local function get_year_epoch(year) return preset_fairfield_dateutc(year, 1, 1) end

function get_time_components(timestamp, offset_seconds)
    if tonumber(timestamp) == nil or tonumber(offset_seconds) == nil then
        obs.script_log(obs.LOG_ERROR,
                       "Invalid input" .. timestamp .. offset_seconds)
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
    repeat
        local year_start = get_year_epoch(year)
        local next_year_start = get_year_epoch(year + 1)

        if adjusted_time >= year_start and adjusted_time < next_year_start then
            break
        elseif adjusted_time < year_start then
            year = year - 1
        else
            year = year + 1
        end
    until false

    -- 残り日数の計算
    local days_left = math.floor((adjusted_time - get_year_epoch(year)) /
                                     seconds_per_day)

    -- 閏年対応
    if year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0) then
        days_in_month[2] = 29
    else
        days_in_month[2] = 28
    end
    local month = 1
    while days_left >= days_in_month[month] do
        days_left = days_left - days_in_month[month]
        month = month + 1
    end
    local day = days_left + 1

    -- 曜日計算（仮に既存関数を利用）
    local wday = get_weekday(year, month, day)

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
    result = result:gsub("%%Z", tz_abbrs[tz_idx])
    result = result:gsub("%%z", string.format("%+02d:%02d", offset_hours, 0))
    result = result:gsub("%%a", weekdays[components.wday])

    return result
end

-- https://teratail.com/questions/292340でみつけたアルゴの移植 fairfieldのプリセットでの計算
-- https://ja.wikipedia.org/wiki/%E3%83%84%E3%82%A7%E3%83%A9%E3%83%BC%E3%81%AE%E5%85%AC%E5%BC%8F
function days(y, m, d)
    -- 月ごとの累積日数テーブル
    local t = {306, 337, 0, 31, 61, 92, 122, 153, 184, 214, 245, 275}

    m = tonumber(m)
    -- 1,2月の場合は前年として計算
    if (m < 3) then y = y - 1 end

    local tm = 365 * y + math.floor(y / 4) - math.floor(y / 100) +
                   math.floor(y / 400) + t[m] + d

    return tm
end

function preset_fairfield_dateutc(y, m, d)
    return (days(y, m, d) - days(1970, 1, 1)) * 86400
end

function tznow(format_str, utc_time)

    local offset_hours = get_pst(utc_time * 1000)
    local timestamp = utc_time + offset_hours * 3600

    local result = strftime(format_str, timestamp, offset_hours)

    if result ~= nil then
        return result
    else
        return "Invaid Time"
    end

end

function get_timezone_offset(ts) -- サマー有りタイムゾーン時差情報 当時の時間 negativeだとこれも使えない
    local utcdate = os.date("!*t", ts) -- lutc work
    local localdate = os.date("*t", ts) -- local negative not work
    localdate.isdst = false -- this is the trick
    return os.difftime(os.time(localdate), os.time(utcdate))
end

-- Update the text source with the current time
local function set_time_text()
    local utc_time = os.time()

    local text = para_text
    local time_text_clean =
        string.gsub(time_text, format_string_avoid_crash, "")

    pst = get_pst(os.time() * 1000)

    --[[
    obs.script_log(obs.LOG_INFO, "pst"..pst)
    obs.script_log(obs.LOG_INFO, "u"..tz_untils[tz_idx-1])
    obs.script_log(obs.LOG_INFO, "o"..tz_offsets[tz_idx ])
    obs.script_log(obs.LOG_INFO, "a"..tz_abbrs[tz_idx ])
    ]]

    local format_str = time_text_clean
    local format_utc = string.gsub(time_text_clean, "%%z", "UTC")
    local format_jst = string.gsub(time_text_clean, "%%z", "JST")
    local format_tz = string.gsub(time_text_clean, "%%z", pst)

    text = string.gsub(text, "%%TZN", tznow(time_text, utc_time))

    --[[
    text = string.gsub(text, "%%NGU", os.date("!"..format_tz, -1))  --UTC works
    local negative_local =  os.date(format_tz, -1) --local negative not work
    if(negative_local==nil)then
    text = string.gsub(text, "%%NG","negative_local not supported:nil")
    else
    text = string.gsub(text, "%%NG",negative_local)
    end
    ]]
    local negative_local = os.date(format_str, utc_time) -- local negative not work
    if (negative_local == nil) then
        text = string.gsub(text, "%%N", "negative_local not supported:nil")
    else
        text = string.gsub(text, "%%N", negative_local)
    end
    text = string.gsub(text, "%%UTC", os.date("!" .. format_utc, utc_time))
    text = string.gsub(text, "%%JST",
                       os.date("!" .. format_jst, utc_time + 9 * 3600))
    text = string.gsub(text, "%%TZ",
                       os.date("!" .. format_tz, utc_time + pst * 3600))

    text = string.gsub(text, osdate_avoid_crash, "")
    text = os.date(text, utc_time)

    local source = obs.obs_get_source_by_name(source_name)
    if source then
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
end

-- Timer callback to update the text periodically
local function timer_callback() set_time_text() end

-- Script properties for OBS Studio
function script_properties()
    local props = obs.obs_properties_create()

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

    local tz = obs.obs_properties_add_list(props, "timezone", "Time Zone",
                                           obs.OBS_COMBO_TYPE_EDITABLE,
                                           obs.OBS_COMBO_FORMAT_STRING)
    for _, tz_name in ipairs(timezone_strings) do
        obs.obs_property_list_add_string(tz, tz_name, tz_name)
    end

    obs.obs_properties_add_text(props, "para_text", "Text Format:",
                                obs.OBS_TEXT_MULTILINE)
    local fmt = obs.obs_properties_add_list(props, "time_text", "Time Format",
                                            obs.OBS_COMBO_TYPE_EDITABLE,
                                            obs.OBS_COMBO_FORMAT_STRING)
    for _, df in ipairs(dateformat) do
        obs.obs_property_list_add_string(fmt, df, df)
    end

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

    return props
end

-- Script description
function script_description()
    return
        "Displays the current time in a selected time zone within a text source in OBS Studio."
end

-- Update script settings
function script_update(settings)
    obs.timer_remove(timer_callback)

    source_name = obs.obs_data_get_string(settings, "source")
    timezone = obs.obs_data_get_string(settings, "timezone")
    para_text = obs.obs_data_get_string(settings, "para_text")
    time_text = obs.obs_data_get_string(settings, "time_text")
    timezone_tzif_path = obs.obs_data_get_string(settings, "tzpath")

    load_timezone(timezone)
    set_time_text()
    obs.timer_add(timer_callback, 1000) -- Update every second
end

-- Set default settings
function script_defaults(settings)
    obs.obs_data_set_default_string(settings, "time_text",
                                    "%Y-%m-%d %H:%M:%S %z (%a)")
    obs.obs_data_set_default_string(settings, "para_text",
                                    "Current Time:\nTZN:%TZN\n//os.date windows doesnot work negative timestamp()\nos.time:%N\nUTC:%UTC\nJST:%JST\nTZ:%TZ")
    obs.obs_data_set_default_string(settings, "timezone", "America/Los_Angeles")
    obs.obs_data_set_default_string(settings, "tzpath", timezone_tzif_path)
end

-- Load the script
function script_load(settings) obs.timer_add(timer_callback, 1000) end
