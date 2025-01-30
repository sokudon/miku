
timer_update = 500;


setInterval("get_count()", timer_update);

function get_count() {


    var jtc = 9;
    var jtc_sm = 11;
    var tz = document.tzone.owata.options[document.tzone.owata.selectedIndex].text;
    var tzm = tz.match(/-?\d+/g);
    var t_offset = 0;
    var t_offset_min = 0;
    var ostime = document.getElementById("OF").checked;
    if (ostime) {
        t_offset = -Math.floor(new Date().getTimezoneOffset() / 60);
        t_offset_min = -(new Date().getTimezoneOffset() % 60);
        date_fm = "YYYY/MM/DD(ddd) HH:mm:ss (UTC+" + t_offset + ":" + ("0" + t_offset_min).slice(-2) + ")";
        date_fm = date_fm.replace("+-", "-");
    }
    else if (tzm != null) {
        t_offset = parseInt(tzm[0]);
        if (tzm[1] != null) {
            t_offset_min = (parseInt(tzm[1]));
            if (t_offset < 0) {
                t_offset_min = -t_offset_min;
            }
        }

        if (tz != "UTC +09:00　大阪、札幌、東京") {
            date_fm = "YYYY/MM/DD(ddd) HH:mm:ss (" + tz.match(/UTC.*?:\d\d/) + ")";
        }
    }

    jtc = t_offset + t_offset_min / 60;
    if (jtc == 9) {
        date_fm = "YYYY/MM/DD(ddd) HH:mm:ss ([JST,UTC+9:00])";//現在時刻フォーマット
    }
    var diff = (moment() - moment.utc()) / 1000 / 3600;

    var t = moment(ibeowari).add("Hours", diff - jtc);//現地時間
    var now = moment.utc().add("Hours", jtc);
    if (ostime) {
        now = moment();
        date_fm = "YYYY/MM/DD(ddd) HH:mm:ss (UTCZ)";
    }

    var left_time = moment.utc(ibeowari) - moment.utc();

    var zan = "残り時間:"
    if (left_time < 0) {
        left_time = -left_time;
        zan = "超過時間:"
    }



    t = moment(left_time).valueOf() / 1000;

    var timetxt = Math.floor(t / (3600 * 24)) + "日"
        + Math.floor((t % (3600 * 24)) / 3600) + "時間"
        + Math.floor((t % 3600) / 60) + "分"
        + Math.floor(t % 60) + "秒";

    timetxt = timetxt.replace(/^0日/, "");
    if (timetxt.indexOf("NaN") >= 0) {
        timetxt = "----";
    }

    var ibetime = (moment.utc(ibeowari) - moment.utc(ibekaishi)) / 1000;
    var kaishi = "経過時間:";
    var bar = "";
    var esps = (moment.utc() - moment.utc(ibekaishi)) / 1000;
    if (esps < 0) {
        esps = -esps;
        kaishi = "開始まで:"
    }
    if (esps > ibetime) {
        esps = ibetime;
    }
    esps = Math.floor(esps / 3600) + "時間" + Math.floor((esps % 3600) / 60) + "分" + Math.floor(esps % 60) + "秒";
    if (esps.indexOf("NaN") >= 0) {
        esps = "----";
    }

    moment.locale("ja", {
        weekdays: ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"],
        weekdaysShort: ["日", "月", "火", "水", "木", "金", "土"]
    });

    if (getDevice()) {

        date_fm = date_fm.replace(/\(J.+/, "");
    }

    var prog = (moment.utc() - moment.utc(ibekaishi)) / (moment.utc(ibeowari) - moment.utc(ibekaishi)) * 100
    prog = prog.toFixed(2);
    var prog2 = "";
    if (prog == "NaN") {
        prog = "";
    }
    else {
        if (prog < 0) {
            prog = "0";
            prog2 = "0/" + ((moment.utc(ibeowari) - moment.utc(ibekaishi)) / 3600000).toFixed(3) + "時間";
            prog2 += ",0/" + ((moment.utc(ibeowari) - moment.utc(ibekaishi)) / 3600000 / 24).toFixed(3) + "日";
        }
        else if (prog > 100) {
            prog = "100";
            prog2 = ((moment.utc(ibeowari) - moment.utc(ibekaishi)) / 3600000).toFixed(3) + "/" + ((moment.utc(ibeowari) - moment.utc(ibekaishi)) / 3600000).toFixed(3) + "時間";
            prog2 += "," + ((moment.utc(ibeowari) - moment.utc(ibekaishi)) / 3600000 / 24).toFixed(3) + "/" + ((moment.utc(ibeowari) - moment.utc(ibekaishi)) / 3600000 / 24).toFixed(3) + "日";
        }
        else {
            prog2 = ((moment.utc() - moment.utc(ibekaishi)) / 3600000).toFixed(3) + "/" + ((moment.utc(ibeowari) - moment.utc(ibekaishi)) / 3600000).toFixed(3) + "時間";
            prog2 += "," + ((moment.utc() - moment.utc(ibekaishi)) / 3600000 / 24).toFixed(3) + "/" + ((moment.utc(ibeowari) - moment.utc(ibekaishi)) / 3600000 / 24).toFixed(3) + "日";
        }
    }

    var tz = "";
    if (document.getElementById("CUSTOM").checked) {
        date_fm = date_fm.replace(/YYYY\//, "");
        date_fm = date_fm.replace(/:ss */, "");
        date_fm = date_fm.replace(/\([U\[].+/gm, "");
        prog2 = prog2.replace(/\d+.*?時間,/, "");
        if (ostime) {
            tz += "<br>TZ:始GMT" + moment(ibekaishi).format("Z");
            tz += "→終GMT" + moment(ibeowari).format("Z");
        }
        else {
            tz += "<br>TZ:始終UTC" + t_offset + ":" + ("0" + t_offset_min).slice(-2);
        }
    }



    //文字色
    var text_color = "black";
    //画面出力
    timest = "現在時刻:"
    if (ostime) {
        timest += now.format(date_fm)
            + addDST(now) + "<br>";
    }
    else {
        timest += now.format(date_fm) + "<br>";
    }

    if (!document.getElementById("bar").checked) {
        bar = '<progress id="myProgress" value="' + prog + '" max="100"></progress>' + prog + "%<br>";
    }

    timest += kaishi + esps + "<br>"
        + zan + timetxt + "<br>"
    if (ostime) {
        timest += "開始時間:" + moment(ibekaishi).format(date_fm).replace(/UTC(.\d\d)(\d\d)/, "UTC$1:$2") + addDST(ibekaishi) + "<br>"
            + "終了時間:" + moment(ibeowari).format(date_fm).replace(/UTC(.\d\d)(\d\d)/, "UTC$1:$2") + addDST(ibeowari) + "<br>";
    }
    else {
        timest += "開始時間:" + moment.utc(ibekaishi).add("Hours", jtc).format(date_fm) + "<br>"
            + "終了時間:" + moment.utc(ibeowari).add("Hours", jtc).format(date_fm) + "<br>";
    }
    timest += "イベ時間:" + prog2 + "<br>";

    timest += bar;
    timest += tz;

    document.getElementById("ibe").innerHTML = ibemie;
    document.getElementById("cdt_now").innerHTML = timest;

}

function addDST(t) {
    var s = "";
    if (moment(t).isDST()) {
        s = "(DST)";
    }
    return s;
}

function getDevice() {
    var ua = navigator.userAgent;
    if (ua.indexOf('iPhone') > 0 || ua.indexOf('iPod') > 0 || ua.indexOf('Android') > 0 && ua.indexOf('Mobile') > 0) {
        return 'sp';
    } else if (ua.indexOf('iPad') > 0 || ua.indexOf('Android') > 0) {
        return 'tab';
    }
    return null;
}



function fix_url(a) {
    if (a.indexOf("http") >= 0) { } else if (a.indexOf("ttp") >= 0) {
        a = "h" + a;
    } else {
        a = "http" + a;
    }
    return a.replace("http://127.0.0.1:8823/thread/", "");
}
function parseData(data) {
    stringfilter(data);
}

function getweb(urls) {
    var local = new RegExp("(\.\/neta\/[a-zA-Z0-9_\-]+)\.(lua|py)");
    var uri = new RegExp("(h?ttps?)?(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)");
    var lcmm = urls.match(local);
    var urlm = urls.match(uri);
    var text = "";
    var your_url = "";
    if (lcmm != null) {
        your_url = lcmm[0];
        $.get(your_url, parseData);
    } else if (urlm != null) {
        your_url = fix_url(urlm[0]);
        text = "";
        $.ajax({
            url: your_url,
            type: 'GET',
            timeout: 10000,
            success: function (res) {
                stringfilter(rmhtml(res));
            }
        });
    }
    return false;
}

function stringfilter(data) {

    if (data.match(/^from tkinter import/)) {
        makepyscript(data);
        return;
    }

    if (data.match(/^#original src https:\/\/obsproject.com\/forum\/resources\/date\-time.906\//)) {
        makepyplugin(data);
        return;
    }



    //luascritpt
    var obs = [//miritate,kori,makao,mirdere,proseka
        "%d %hh:%mm:%ss(%hsH,%dsD)	%T%n経過時間%K%n残り時間%L%nイベント時間%I%n達成率%P%Q%n%n現地時間%N%n開始(OS)%S%n終了(OS)%E%n%n日本時間 %JST%n開始(JST)%SJ%n終了(JST)%EJ%n%nU-CLOCK %UTC%n開始(U?)%SU%n終了(U?)%EU	%Y-%m-%d(%a)%H:%M:%S(GMT%z)",
        //"%d %hh:%mm:%ss(%hsH,%dsD	%T%n経過時間%K%n残り時間%L%nイベント時間%I%n現地時間%N%n日本時間%JST%n達成率%P%nS %S%nE %E%n%nSJ %SJ%nEJ %EJ%n%nSU %SU%nEU %EU	%Y-%m-%dT%H:%M:%S%z (%a)",
        "%d %hh:%mm:%ss	miriKOREA%L(%P％)	%Y/%m/%d %H:%M:%S",
        "%d %hh:%mm:%ss	miriCN/TW;%L(%P％)	%Y/%m/%d %H:%M:%S",
        "%d %hh:%mm:%ss(%dsD)	ＯＳ時間:%N UTC+0000:%UTC%n経過時間:%K                 日本時間:%JST  %n残り時間:%L                開始時間:%SJ%nイベ時間:%I              終了時間:%EJ                   %n%Q%P％  %T	%Y-%m-%d(%a)%H:%M:%S(GMT%z)",
        "%d %hh:%mm:%ss(%hsH,%dsD)	OS時間:%N      UTC:%UTC%n経過時間%K                 日本時間:%JST  %n残り時間:%L                開始時間:%SJ%nイベント時間:%I          終了時間%EJ                    %T%P％%n%Q	%Y-%m-%dT%H:%M:%S%z (%a)",
        "%d %hh:%mm:%ss(%hsH,%dsD)	日本時間%JST%n経過時間%K%n残り時間%L%nイベント時間%I%n%T%P％%n%Q	%Y-%m-%dT%H:%M:%S%z (%a)",
        ""
    ];
    var sel = $("#obstxt").prop("selectedIndex");
    obs[6] = document.getElementById("user").value;

    var rptxt = obs[sel];
    var rp = rptxt.split("	");


    data = data.replace("2020-04-30T12:00:00+09:00", moment(ibekaishi).format());
    data = data.replace("2020-05-07T21:00:00+09:00", moment(ibeowari).format());
    data = data.replace("でれすて", ibemie);
    data = data.replace("でれすて", ibemie);
    data = data.replace("\"bar\", 1", "\"bar\", 2");

    if (rp.length == 3) {
        data = data.replace("%T%n経過時間%K%n残り時間%L%nイベント時間%I%n現地時間%N%n日本時間%JST%n達成率%P%nS %S%nE %E%n%nSJ %SJ%nEJ %EJ%n%nSU %SU%nEU %EU", rp[1].replace(/%n/gm, "\\n"));
        data = data.replace("%H:%m:%s", rp[0]);
        data = data.replace("%Y/%m/%d %H:%M:%S", rp[2]);
    }
    else {
        data = data.replace("%H:%m:%s", "%d %hh:%mm:%ss(%hsH,%dsD)");
        data = data.replace("%Y/%m/%d %H:%M:%S", "%Y-%m-%dT%H:%M:%S%z (%a)");
    }
    data = data.replace("タイマー停止中(開始前/終了)", "終了しました");

    TextDL(data, "obsduration_timer_39.lua");
    return false;
}


function makepyplugin(data) {

    data = data.replace("星雲の窓辺", ibemie);

    //st=2024-04-30T17:00:00+09:00'
    //en = '2024-05-08T22:00:00+09:00'
    data = data.replace("2024-04-30T17:00:00+09:00", moment(ibekaishi).format());
    data = data.replace("2024-05-08T22:00:00+09:00", moment(ibeowari).format());

    TextDL(data, "obsduration_timer_39.py");
    return false;
}

function makepyscript(data) {

    data = data.replace("ぷろせか", ibemie);

    //s = '2020-12-10T14:00:00+08:00'
    //ss = '2020-12-18T12:00:00Z'
    data = data.replace("2020-12-10T14:00:00+08:00", moment(ibekaishi).format());
    data = data.replace("2020-12-18T12:00:00Z", moment(ibeowari).format());

    TextDL(data, "pythonduration_timer_39.py");
    return false;
}

function makeplugin() {
    getweb("./neta/OBSdere_extend.lua");
}
function makepluginpy() {
    getweb("./neta/date-time_with_tzinfo.py");
}

function makepy() {
    getweb("./neta/ibetimer.py");
}



function makeical() {

    var tmp = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//はんようたいまー//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nDTSTART:20200423T150000Z\r\nDTEND:20200424T150000Z\r\nSUMMARY:うづき\r\nEND:VEVENT\r\nEND:VCALENDAR";

    if (ibekaishi == "" || ibekaishi == "--" || ibemie == "" || moment(ibekaishi).format() == "Invalid date") {
        alert("タイトル名/イベント開始時期は必須なので出力できませんでした（）");
        return;
    }
    else if (moment(ibekaishi).format() == moment(ibeowari).format()) {
        alert("イベント開始終了が同じものはごっごるカレンダーでは使えません()");
        return;
    }
    else {
        tmp = tmp.replace(/DTSTART:\d+T\d+Z/, "DTSTART:" + moment.utc(ibekaishi).format("YYYYMMDDTHHmmss[Z]"));
        if (ibeowari == "" || ibeowari == "--" || moment(ibeowari).format() == "Invalid date") {
            var result = confirm('終了日時が未確定です、仮登録ようにイベント開始日+1時間に設定しますか？');
            if (result) {
                tmp = tmp.replace(/DTEND:\d+T\d+Z/, "DTEND:" + moment.utc(ibekaishi).add(1, "h").format("YYYYMMDDTHHmmss[Z]"));
                tmp = tmp.replace(/SUMMARY:/, "STATUS:TENTATIVE\r\nSUMMARY:");

            }
            else { alert("作成を中止ました（）"); return; }
        }
        else {
            tmp = tmp.replace(/DTEND:\d+T\d+Z/, "DTEND:" + moment.utc(ibeowari).format("YYYYMMDDTHHmmss[Z]"));
        }
        tmp = tmp.replace(/SUMMARY:うづき/, "SUMMARY:" + ibemie);
        TextDL(tmp, "proseka_event.ics")
    }
}
function TextDL(n, t) { b = new Blob([n], { type: "text/plain" }), a = document.createElement("a"), a.download = t, a.href = window.URL.createObjectURL(b), e = document.createEvent("MouseEvent"), e.initEvent("click", !0, !0), a.dispatchEvent(e) }

//https://twitter.com/intent/tweet?

//Twitterボタン
function toTwitter() {
    var url = "";

    s = document.getElementById("ibe").innerHTML + "<br>" + document.getElementById("cdt_now").innerHTML;
    s = s.replace(/<br>/gm, "\r\n");
    s = s.replace(/<.*?>/gm, "");
    s = s.replace(/\r\n\r\n/gm, "\r\n");
    s = s + "\r\nhttp://sokudon.s17.xrea.com/miku_ibetimer.html\r\n#プロセカタイマー";

    if (url == "") {
        url = "http://twitter.com/share?text=" + encodeURIComponent(s);
    } else {
        url = "http://twitter.com/share?url=" + url + "&text=" + encodeURIComponent(s);
    }
    window.open(url, "_blank", "width=600,height=300");
}

const myText = document.getElementById("timer");

function changeTxtColor(newColor) {
    document.body.style.color = newColor;
    //document.getElementById("timer").style.color = newColor;
    // クラス"myText"を持つすべての要素を取得し、スタイルを変更
    var elements = document.getElementsByClassName("myText");
    for (var i = 0; i < elements.length; i++) {
        elements[i].style.color = newColor;
    }

}

function changeBoxColor(newColor, newColor_sec) {
    document.body.style.backgroundColor = newColor;

    if (document.getElementById("same_color").checked) { newColor_sec = newColor; }
    const sections = document.querySelectorAll('.section');
    sections.forEach(section => {
        section.style.backgroundColor = newColor_sec;
    });
}
