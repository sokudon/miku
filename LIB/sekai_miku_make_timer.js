var ibemie = "雨上がりの一番星";
var ibekaishi = "2020-10-09T15:00:00+09:00";
var ibeowari = "2020-10-18T21:00:00+09:00";
var date_fm = "YYYY/MM/DD(ddd) HH:mm:ss ([JST,UTC+9:00])";

var NoLeap = "02-28"; // 3/1 2/27かわからないので暫定

var gameselecter = 0;
var worldtimer = [
	["jp", ibekaishi, ibeowari, "JST", 9, "Asia/Tokyo"],
	["ks", ibekaishi, ibeowari, "KST", 9, "Asia/Seoul"],
	["hz", ibekaishi, ibeowari, "HKT", 8, "Asia/Hong_Kong"],
	["usa", ibekaishi, ibeowari, "PST", -8, "America/Los_Angeles"]];

var nomal = "YYYY/MM/DD HH:mm:ss";
var iso = "YYYY-MM-DDTHH:mm:ss";
var ibe = ibemie;

var evnetskip = 77;

window.onload = function () {
	createSelectBox();
	document.gm.gm.selectedIndex = 146;//ロサンゼルス
	document.getElementById("gamename").selectedIndex = document.getElementById("gamename").length - 1;
	update();
	get_web_para();
	ibetime();
	get_count();
}

function escapeHTML(html) {
	return jQuery('<div>').text(html).html();
}

function parsedate(dt) {
	var timezone = [["WITA", "+0800"], ["WIT", "+0900"], ["WIB", "+0700"], ["WET", "+0000"], ["WEST", "+0100"], ["WAT", "+0100"], ["UYT", "-0300"], ["UTC", "+0000"], ["SST", "-1100"], ["PWT", "+0900"], ["PST", "-0800"], ["PKT", "+0500"], ["PHT", "+0800"], ["PET", "-0500"], ["PDT", "-0700"], ["NZST", "+1200"], ["NZDT", "+1300"], ["NPT", "+0545"], ["MYT", "+0800"], ["MST", "-0700"], ["MMT", "+0630"], ["MDT", "-0600"], ["KST", "+0900"], ["JST", "+0900"], ["IST", "+0530"], ["IST", "+0200"], ["IRST", "+0330"], ["IRDT", "+0430"], ["IDT", "+0300"], ["ICT", "+0700"], ["HST", "-1000"], ["HKT", "+0800"], ["GST", "+0400"], ["GMT", "+0000"], ["FJT", "+1200"], ["FJST", "+1300"], ["EST", "-0500"], ["EET", "+0200"], ["EEST", "+0300"], ["EDT", "-0400"], ["ECT", "-0500"], ["EAT", "+0300"], ["ChST", "+1000"], ["CST", "-0600"], ["cST", "-0500"], ["cst", "+0800"], ["COT", "-0500"], ["CLT", "-0400"], ["CLST", "-0300"], ["CET", "+0100"], ["CEST", "+0200"], ["CDT", "-0500"], ["cDT", "-0400"], ["CCT", "+0630"], ["CAT", "+0200"], ["BTT", "+0600"], ["BST", "+0100"], ["BRT", "-0300"], ["BOT", "-0400"], ["BNT", "+0800"], ["BDT", "+0600"], ["AWST", "+0800"], ["AWDT", "+0900"], ["ART", "-0300"], ["AKST", "-0900"], ["AKDT", "-0800"], ["AFT", "+0430"], ["AEST", "+1000"], ["AEDT", "+1100"], ["ACST", "+0930"], ["ACDT", "+1030"]];
	if (dt.match(/(\d\d\d\d)[\/\-](\d\d)[\/\-](\d\d) +(\d\d):(\d\d) *[A-W]+$/)) {
		var tzstring = dt.match(/[A-W]+$/);
		var offset = 0
		if (tzstring == "U") {
			var tz = document.getElementById("utcdiff").options[document.getElementById("utcdiff").selectedIndex].text;
			offset = tz.match(/[\+\-]\d\d\d\d/);
		}
		else {
			for (var i = 0; i < timezone.length; i++) {
				if (tzstring == timezone[i][0]) {
					offset = timezone[i][1];
					break;
				}
			}
		}
		dt = dt.replace(/(\d\d\d\d)[\/\-](\d\d)[\/\-](\d\d) +(\d\d):(\d\d) *[A-W]+$/, "$1-$2-$3T$4:$5:00" + offset);
	}

	var mm = moment(dt);
	if (moment.isMoment(mm)) {
		return mm;
	}
	return "null";
}

function get_web_para() {
	var url = document.location.href;
	var s = "";
	var n = url.indexOf("#");
	if (n > -1) {
		s = url.substring(n + 1, url.length);
		url = url.substring(0, n);
		var nn = s.split(",");

		url = url.substring(0, n);
		var nn = s.split(",");
		ibemie = escapeHTML(decodeURIComponent(nn[0]));//utf8
		if (nn.length >= 2) { ibekaishi = parsedate(decodeURIComponent(nn[1])).format(); }
		if (nn.length >= 3) { ibeowari = parsedate(decodeURIComponent(nn[2])).format(); }
		if (nn.length >= 4) {
			var mode = decodeURIComponent(nn[3]);
			var ms = $('#utcdiff option');
			var reg = new RegExp(mode.replace("$", "\\$") + "$");
			for (var i = 0; i < ms.length; i++) {
				var tmp = ms[i].text;
				if (tmp.match(reg)) {
					ms[i].selected = true;
					break;
				}
			}

		}

		if (nn.length >= 5) {
			var m = nn[4].match(/\d+/);
			document.gm.gm.selectedIndex = m[0];
		}
	}
}

function createSelectBox() {

	//連想配列をループ処理で値を取り出してセレクトボックスにセットする
	for (var i = 0; i < tzJAP.length; i++) {
		let op = document.createElement("option");
		op.value = "";  //value値
		op.text = i + ";" + tzJAP[i][0] + "|" + tzJAP[i][1];   //テキスト値
		if (op.text.match(/GMT[\+/]/)) {
			op.text = op.text.replace(/(GMT[\+\-])/, "$1!")
			op.text = op.text.replace("+!", "-");
			op.text = op.text.replace("-!", "+");
		}
		document.getElementById("sel1").appendChild(op);
	}


	for (var i = evnetskip; i < data.length; i++) {//願いはで追いつきた
		var gop = document.createElement("option");
		gop.value = "";  //value値
		gop.text = data[i][2] + ";" + data[i][3];   //テキスト値

		document.getElementById("gamename").appendChild(gop);
	}
};


function setjp() {
	document.getElementById("kuni").value = "日本";
	settz()
}
function setks() {
	document.getElementById("kuni").value = "ソウル";
	settz()
}
function sethz() {
	document.getElementById("kuni").value = "香港";
	settz()
}
function setlos() {
	document.getElementById("kuni").value = "ロサンゼルス";
	settz()
}

function settz() {
	var s = document.getElementById("kuni").value;
	s = s.toLowerCase();
	for (var i = 0; i < tzJAP.length; i++) {
		var cmp = document.gm.gm.options[i].text.toLowerCase();
		if (cmp.indexOf(s) >= 0) {
			document.gm.gm.selectedIndex = i;
			break;
		}
	}
	var tmp = "";

	for (var i = 0; i < tzJAP.length; i++) {
		var cmp = document.gm.gm.options[i].text.toLowerCase();
		if (cmp.indexOf(s) >= 0) {
			tmp += document.gm.gm.options[i].text + "<br>";
		}
	}
	document.getElementById("RC").innerHTML = tmp;
	ZONE();

	return;
}

function ibetime() {
	var ostime = document.getElementById("OF").checked;
	var st = "";
	var tzz = document.getElementById("utcdiff").options[document.getElementById("utcdiff").selectedIndex].text;
	var tzm = tzz.match(/\-?\d+/g);
	var tzadd = tzm[0] * 1 + tzm[1] / 60;
	var tzst = tzJAP[document.gm.gm.selectedIndex][0];

	var tzs = moment(ibekaishi).tz(tzst).format("z");
	var tze = moment(ibeowari).tz(tzst).format("z");

	if (ostime) {
		st = "OS時間(LOCAL)\t"
			+ moment(ibekaishi).format(iso + "ZZ") + "\t"
			+ moment(ibeowari).format(iso + "ZZ") + "\r\n"
			+ "日本時間(JST)\t"
			+ moment(ibekaishi).utc().add("Hours", 9).format(iso + "+09:00") + "\t"
			+ moment(ibeowari).utc().add("Hours", 9).format(iso + "+09:00") + "\r\n"
			+ "M$時間\t"
			+ moment.utc(ibekaishi).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]) + "\t"
			+ moment.utc(ibeowari).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]) + "\r\n"
			+ "もめんと時間" + tzs + "/" + tze + "\t"
			+ moment(ibekaishi).tz(tzst).format() + "\t"
			+ moment(ibeowari).tz(tzst).format() + "\r\n"
			+ "もめんとlocal時間+TZST\t"
			+ moment(ibekaishi).tz(tzst).format("YYYY/MM/DD HH:mm z") + "(" + tzst + ")\t"
			+ moment(ibeowari).tz(tzst).format("YYYY/MM/DD HH:mm z") + "(" + tzst + ")\r\n"
			+ "UNIXepoc秒\t"
			+ moment(ibekaishi).unix() + "\t"
			+ moment(ibeowari).unix();

	}
	else {

		st = "OS時間(LOCAL)\t"
			+ moment(ibekaishi).format(nomal) + "\t"
			+ moment(ibeowari).format(nomal) + "\r\n"
			+ "日本時間(JST)\t"
			+ moment(ibekaishi).utc().add("Hours", 9).format(nomal) + "\t"
			+ moment(ibeowari).utc().add("Hours", 9).format(nomal) + "\r\n"
			+ "M$時間\t"
			+ moment.utc(ibekaishi).add("Hours", tzadd).format(nomal) + "\t"
			+ moment.utc(ibeowari).add("Hours", tzadd).format(nomal) + "\r\n"
			+ "もめんと時間" + tzs + "/" + tze + "\t"
			+ moment(ibekaishi).tz(tzst).format(nomal) + "\t"
			+ moment(ibeowari).tz(tzst).format(nomal) + "\r\n"
			+ "もめんとlocal時間+TZST\t"
			+ moment(ibekaishi).tz(tzst).format("YYYY/MM/DD HH:mm z") + "(" + tzst + ")\t"
			+ moment(ibeowari).tz(tzst).format("YYYY/MM/DD HH:mm z") + "(" + tzst + ")\r\n"
			+ "UNIXepoc秒\t"
			+ moment(ibekaishi).unix() + "\t"
			+ moment(ibeowari).unix();


	}
	st = st.replace(/\r\n/gm, "	</td></tr><tr><td>");
	st = "<tr><td>" + st.replace(/\t/gm, "</td><td>");
	st = st.replace(/<td><\/td>/gm, "");
	st = st.replace(/<tr><td>$/, "");
	st = st.replace(/\+\-/gm, "-");
	st = st.replace(/Invalid date/gm, "--(未確定)");

	var header = "<th></th><th>開始時刻(START)</th><th>終了時刻(END)</th>"
	var st = "<table id=\"sampleTable\" class=\"tablesorter\">"
		+ "<thead><tr>" + header
		+ "</tr></thead><tbody>"
		+ st + "</tbody></table>";



	document.getElementById("end").innerHTML = st;
	var tmp = "ぷろせか" + ibe;
	if (ibe != ibemie) {
		tmp = ibemie;
	}
	document.getElementById("dere").innerHTML = tmp;

	ZONE();
}

function UTC(i) {
	var tm = "";
	if (i > 0) {
		tm = "-" + ("0" + i).slice(-2);
	}
	else {
		tm = "+" + ("0" + (-i)).slice(-2);
	}
	return tm + ":00"
}
function isPatchJson(value,defalutvalue) {
	// value が undefined, null, 空文字でないかつ、momentで有効な日時なら moment オブジェクトを返す
	if (value !== undefined && value !== null && value !== "" && moment(value).isValid()) {
		return moment(value).format("YYYY-MM-DD[T]HH:mm:ssZ"); // moment オブジェクトを返す（呼び出し側で format() 可能）
	}

	return defalutvalue; // それ以外はデフォルト値をそのまま返す
}

function get_count() {

	var tt = ibeowari;//undefinedで現在時刻
	var ts = ibekaishi;//undefinedで現在時刻
	var st = "";
	var stt = "";
	var stm = "";
	var ostime = document.getElementById("OF").checked;
	var tzz = document.getElementById("utcdiff").options[document.getElementById("utcdiff").selectedIndex].text;
	var tzm = tzz.match(/\-?\d+/g);
	var tzadd = tzm[0] * 1 + tzm[1] / 60;
	var tzst = tzJAP[document.gm.gm.selectedIndex][0];
	var tzPST = "America/Los_Angeles";
	var tzs = moment(ibekaishi).tz(tzst).format("z");
	var tze = moment(ibeowari).tz(tzst).format("z");

	st = "<tr><th>OSたいむ</th><th>日本版</th><th>韓国版</th><th>香港版</th><th>中国版</th><th>北米版</th></tr>";
	st = st.replace("日本版", moment(ts).format() + "～" + moment(tt).format());

	worldtimer[0][1] = ts;
	worldtimer[0][2] = tt;

	var tsbk = ts;
	//tt=NextYearNoLeap(tt);
	//ts=NextYearNoLeap(ts);

	var kst = moment(ts).utc().add("h", 9).add("y", 1).format("YYYY-MM-DD[T]HH:mm:ss+09:00");
	var ken = moment(tt).utc().add("h", 9).add("y", 1).format("YYYY-MM-DD[T]HH:mm:ss+09:00");
	var hst = moment(kst).add("h", 1).format("YYYY-MM-DD[T]HH:mm:ss+09:00");
	var hen = moment(ken).add("h", 1).format("YYYY-MM-DD[T]HH:mm:ss+09:00");
	var cst = null;
	var cen = null;
	var gst = moment(ts).utc().add("h", 9).add("y", 1).format("YYYY-MM-DD HH:mm:ss");
	var gen = moment(tt).utc().add("h", 9).add("y", 1).format("YYYY-MM-DD HH:mm:ss");


	var patch_idx = 12;//ぱっちの位置/ぱっちの位置のグーグルマクロとの
	patch_idx--;//ぱっちの位置のグーグルマクロとのjs修正

	// dataからpatchJsonを取得してパース
	var patchString = data[last_oversea][patch_idx]; // インデックス12にpatchJson文字列
	var patchJson = { patch: false, columns: {} };
	if (data[last_oversea][patch_idx] != "") {
		if (patchString) {
			try {
				patchJson = JSON.parse(patchString);
			} catch (e) {
				console.error("patchJsonのパースに失敗: ", e.message);
				patchJson = { patch: false, columns: {} }; // エラー時は空のデフォルト
			}
		}

		// patchJsonから値を取得して上書き（厳密なチェック）
		if (patchJson && patchJson.patch && patchJson.columns && typeof patchJson.columns === "object") {
			// momentで値を取得し、フォーマット// 使用例
			kst = isPatchJson(patchJson.columns.kst,kst);
			ken = isPatchJson(patchJson.columns.ken,ken);
			hst = isPatchJson(patchJson.columns.hst,hst);
			hen = isPatchJson(patchJson.columns.hen,hen);
			cst = isPatchJson(patchJson.columns.cst,cst);
			cen = isPatchJson(patchJson.columns.cen,cen);
			gst = isPatchJson(patchJson.columns.gst,gst);
			gen = isPatchJson(patchJson.columns.gen,gen);
		}
	}


	worldtimer[1][1] = moment(kst).format();
	worldtimer[1][2] = moment(ken).format();

	worldtimer[2][1] = moment(hst).format();
	worldtimer[2][2] = moment(hen).format();

	worldtimer[3][1] = moment(moment.tz(gst, tzPST)).local().format();
	worldtimer[3][2] = moment(moment.tz(gen, tzPST)).local().format();

	st = st.replace("韓国版", moment(kst).format() + "～" + moment(ken).format());
	st = st.replace("香港版", moment(kst).add("h", 1).format() + "～" + moment(ken).add("h", 1).format());
	st = st.replace("中国版", moment(cst).format() + "～" + moment(cen).format());
	st = st.replace("北米版", moment(moment.tz(gst, tzPST)).local().format() + "～" + moment(moment.tz(gen, tzPST)).local().format());

	//+"M$時間\t"
	//+moment.utc(ibekaishi).add("Hours",tzadd).format().replace("Z","+"+tzm[0] +":"+tzm[1])+"\t"
	//+moment.utc(ibeowari).add("Hours",tzadd).format().replace("Z","+"+tzm[0] +":"+tzm[1])+"\r\n"
	stm = "<tr><th>M$時間</th><th>日本版</th><th>韓国版</th><th>香港版</th><th>中国版</th>北米版</th></tr>";
	stm = stm.replace("日本版", moment.utc(tsbk).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]) + "～" + moment.utc(tt).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]));

	stm = stm.replace("韓国版", moment.utc(kst).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]) + "～" + moment.utc(ken).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]));
	stm = stm.replace("香港版", moment.utc(kst).add("h", 1 + tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]) + "～" + moment.utc(ken).add("h", 1 + tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]));
	stm = stm.replace("中国版", moment.utc(cst).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]) + "～" + moment.utc(cen).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]));
	stm = stm.replace("北米版", moment.utc(moment.tz(gst, tzPST)).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]) + "～" + moment.utc(moment.tz(gen, tzPST)).add("Hours", tzadd).format().replace("Z", "+" + tzm[0] + ":" + tzm[1]));

	stm = stm.replace(/\+\-/gm, "-");



	stt = "<tr><th>もーめんとTZ時間</th><th>日本版</th><th>韓国版</th><th>香港版</th><th>中国版</th><th>北米版</th></tr>";
	stt = stt.replace("日本版", moment(ts).tz(tzst).format() + "～" + moment(tt).tz(tzst).format());

	stt = stt.replace("韓国版", moment(kst).tz(tzst).format() + "～" + moment(ken).tz(tzst).format());
	stt = stt.replace("香港版", moment(kst).add("h", 1).tz(tzst).format() + "～" + moment(ken).add("h", 1).tz(tzst).format());
	stt = stt.replace("中国版", moment(cst).tz(tzst).format() + "～" + moment(cen).tz(tzst).format());
	stt = stt.replace("北米版", moment(moment.tz(gst, tzPST)).tz(tzst).format("YYYY-MM-DD[T]HH:mm:ssZ(z)") + "～" + moment(moment.tz(gen, tzPST)).tz(tzst).format("YYYY-MM-DD[T]HH:mm:ssZ(z)"));

	var header = "<th></th><th>日本版</th><th>韓国版</th><th>香港版</th><th>中国版</th><th>北米版</th>";
	var st = "<table id=\"sampleTable\" class=\"tablesorter\">" + "<thead><tr>" + header + "</tr></thead><tbody>" + st + stm + stt + "</tbody></table>";

	//画面出力
	document.getElementById("tt").innerHTML = st;


}

function NextYearNoLeap(date) {
	if (moment([moment(date).utc().add("h", 9).format("YYYY")]).isLeapYear()) {
		if (moment(date).utc().add("h", 9).format("MMDD") == "0229") {
			date = moment(date).utc().add("h", 9).format("YYYY-" + NoLeap + "[T]HH:mm:ss+09:00");
		}
	}
	return date;
}

function update() {
	var sel = document.getElementById("gamename").selectedIndex + evnetskip - 1;
	if (sel > evnetskip - 1) {
		ibemie = escapeHTML(data[sel][2]);
		ibekaishi = parsedate(data[sel][7]).format();
		ibeowari = parsedate(data[sel][8]).format();
		last_oversea = sel;
		ibetime();
		get_count();
	}
}
function setend() {
	document.getElementById("gamename").selectedIndex = document.getElementById("gamename").length - 1;
	update();
}

var last_oversea = 1;

function setoversea() {
	var lastyear = (parseInt(moment().utc().add("h", 9).format("YYYY")) - 1) + moment().utc().add("h", 9).format("-MM-DD[T]HH:mm:ss+09:00");
	var event = -1;
	for (var i = evnetskip - 1; i < data.length; i++) {
		var offset = -moment(data[i][8]).add("h", 17) + moment(lastyear);
		if (offset < 0) {
			event = i - evnetskip + 1;
			//document.getElementById("kuni").value=data[i][2];
			break;
		}
	}
	document.getElementById("gamename").selectedIndex = event;
	update();
}
function makeplugintz_py() {
	getweb("./neta/obsduration_timer_39usatz.py");
}
function makeplugintz() {
	getweb("./neta/obsduration_timer_39usatz.lua");
}
function makeplugin() {
	getweb("./neta/OBSdere_extend.lua");
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

function mkjp() {
	gameselecter = 0;
	var TZF = document.getElementById("TZOP").checked;
	if (TZF) {
		makeplugintz();
	}
	else {
		makeplugin();
	}
}

function mkks() {
	gameselecter = 1;
	var TZF = document.getElementById("TZOP").checked;
	if (TZF) {
		makeplugintz();
	}
	else {
		makeplugin();
	}
}

function mkhz() {
	gameselecter = 2;
	var TZF = document.getElementById("TZOP").checked;
	if (TZF) {
		makeplugintz();
	}
	else {
		makeplugin();
	}
}

function mkusa() {
	gameselecter = 3;
	var TZF = document.getElementById("TZOP").checked;
	if (TZF) {
		makeplugintz();
	}
	else {
		makeplugin();
	}
}
function mkusa_py() {
	gameselecter = 3;
	makeplugintz_py();
}


function stringfilter(data) {

	if (data.indexOf("dateutil") > 0) {
		var tzst = tzJAP[document.gm.gm.selectedIndex][0];

		data = data.replace("2024-04-30T17:00:00+09:00", moment(worldtimer[gameselecter][1]).tz(tzst).format("YYYY-MM-DD HH:mmz"));
		data = data.replace("2024-05-08T22:00:00+09:00", moment(worldtimer[gameselecter][2]).tz(tzst).format("YYYY-MM-DD HH:mmz"));
		data = data.replace("星雲の窓辺", ibemie);


		TextDL(data, "obsduration_timer_39usatz.py");
		return false;
	}

	var obs = [//miritate,kori,makao,mirdere,proseka
		"%d %hh:%mm:%ss(%hsH,%dsD)	%T%n経過時間%K%n残り時間%L%nイベント時間%I%n達成率%P%Q%n%n現地時間%N%n開始(OS)%S%n終了(OS)%E%n%n日本時間 %JST%n開始(JST)%SJ%n終了(JST)%EJ%n%nU-CLOCK %UTC%n開始(U?)%SU%n終了(U?)%EU	%Y-%m-%d(%a)%H:%M:%S(GMT%z)",
		//"%d %hh:%mm:%ss(%hsH,%dsD	%T%n経過時間%K%n残り時間%L%nイベント時間%I%n現地時間%N%n日本時間%JST%n達成率%P%nS %S%nE %E%n%nSJ %SJ%nEJ %EJ%n%nSU %SU%nEU %EU	%Y-%m-%dT%H:%M:%S%z (%a)",
		"%d %hh:%mm:%ss	miriKOREA%L(%P％)	%Y/%m/%d %H:%M:%S",
		"%d %hh:%mm:%ss	miriCN/TW;%L(%P％)	%Y/%m/%d %H:%M:%S",
		"%d %hh:%mm:%ss(%dsD)	ＯＳ時間:%N UTC+0000:%UTC%n経過時間:%K                 日本時間:%JST  %n残り時間:%L                開始時間:%SJ%nイベ時間:%I              終了時間:%EJ                   %n%Q%P％  %T	%Y-%m-%d(%a)%H:%M:%S(GMT%z)",
		"%d %hh:%mm:%ss(%hsH,%dsD)	OS時間:%N      UTC:%UTC%n経過時間%K                 日本時間:%JST  %n残り時間:%L                開始時間:%SJ%nイベント時間:%I          終了時間%EJ                    %T%P％%n%Q	%Y-%m-%dT%H:%M:%S%z (%a)",
		"%d %hh:%mm:%ss(%hsH,%dsD)	%%K現在時間%UTC%n%%K終了時間%EU%n経過時間%K%n残り時間%L%nイベント時間%I%n%T%P％%n%Q	%Y-%m-%dT%H:%M:%S%z (%a)",
		""
	];

	var rptxt = obs[5];
	var rp = rptxt.split("	");

	var TZF = document.getElementById("TZST").checked;
	var TZOP = document.getElementById("TZOP").checked;
	var ENG = document.getElementById("ENG").checked;
	var tzst = worldtimer[gameselecter][5];
	var difftz = worldtimer[gameselecter][4];
	var gettz = moment(worldtimer[gameselecter][2]).tz(tzst).format("z");
	var tzsupport = "";

	if (TZOP) {

		//PSTname="America/Los_Angeles"
		//PSTabbrs={"PST","PDT"}
		//PSTuntils={1520762400000,1541322000000}
		//PSToffsets={480,420}

		var tt = ZONE();
		tzsupport = "_tz_" + tt.name.replace(/\//gm, "_");
		data = data.replace(/America\/Los_Angeles/gm, tt.name);
		//rp[1] = rp[1].replace("%%K","%TZ TIMEZONE:"+ tt.name +"%n");

		var cut_country = tt.name.replace(/^.*?\//, "").replace(/_/, "");

		data = data.replace(/town_name = "LA"/, 'town_name = "' + cut_country + '"');
		rp[1] = rp[1].replace(/%%K/gm, "");
		rp[1] = rp[1].replace("%UTC", "%TZ");
		rp[1] = rp[1].replace("%EU", "%EE");


		data = data.replace("{PST PDT}", "{" + JSON.stringify(tt.abbrs).replace("[", "").replace("]", "") + "}");
		data = data.replace("{1520762400000 1541322000000}", "{" + JSON.stringify(tt.untils).replace("[", "").replace("]", "") + "}");
		data = data.replace("{480,420}", "{" + tt.offsets + "}");
		data = data.replace(/{}/gm, "{\"\"}");
		data = data.replace(/null}/gm, "math_huge}");
		data = data.replace(/null/gm, "nil");

		data = data.replace(/%TIMEZONE/gm, "%TZ %SS %EE moment-timezone-with-data-10-year-range.js " + tt.name + " のみ移植されてます(実験的)");

	}

	if (ENG) {
		//進捗BARの段階(100÷X)
		//	if(false)then
		//--	if(true)then  --ENGLISH MODE delete if(false), use if(true)
		//--	return "Sets a text source to act as a timer with advanced options. Hotkeys can be set for starting/stopping and to the reset timer."
		//	return "高度なオプションを備えたタイマーとして機能するようにテキスト ソースを設定します。ホットキーは開始/停止およびリセット タイマーに設定できます。"

		data = data.replace("	if(false)then", "");
		data = data.replace("--	if(true)then", "	if(true)then");
		data = data.replace("進捗BARの段階(100÷X)", "PROGRESSBAR(100÷X)");
		data = data.replace("--	return \"Sets a text source", "	return \"Sets a text source");
		data = data.replace("	return \"高度なオプション", "--");
		data = data.replace("タイマー停止中(開始前/終了)", "THE EVENT HAS ENDED");
		data = data.replace("のみ移植されてます(実験的)", "ONLY PORTED(EXPERIMENTAL)");
		//現在時間%UTC%n%%K終了時間%EU%n経過時間%K%n残り時間%L%nイベント時間
		rp[1] = rp[1].replace("現在時間", "DATENNOW:");
		rp[1] = rp[1].replace("終了時間", "END     :");
		rp[1] = rp[1].replace("経過時間", "ELAPSED :");
		rp[1] = rp[1].replace("イベント時間", "DURATION:");
		rp[1] = rp[1].replace("残り時間", "LEFT    :");

	}

	if (TZF) {
		data = data.replace("2020-04-30T12:00:00+09:00", moment(worldtimer[gameselecter][1]).tz(tzst).format("YYYY-MM-DD HH:mmz"));
		data = data.replace("2020-05-07T21:00:00+09:00", moment(worldtimer[gameselecter][2]).tz(tzst).format("YYYY-MM-DD HH:mmz"));
	}
	else {
		data = data.replace("2020-04-30T12:00:00+09:00", moment(worldtimer[gameselecter][1]).format());
		data = data.replace("2020-05-07T21:00:00+09:00", moment(worldtimer[gameselecter][2]).format());
	}
	data = data.replace("でれすて", ibemie);
	data = data.replace("でれすて", ibemie);
	data = data.replace("\"bar\", 1", "\"bar\", 2");

	if (gettz == "PDT") {
		difftz = -7;
	}
	data = data.replace("\"UTC\", 0", "\"UTC\", " + difftz);

	if (rp.length == 3) {
		data = data.replace("%T%n経過時間%K%n残り時間%L%nイベント時間%I%n現地時間%N%n日本時間%JST%n達成率%P%nS %S%nE %E%n%nSJ %SJ%nEJ %EJ%n%nSU %SU%nEU %EU", rp[1].replace(/%%K/gm, gettz).replace(/%n/gm, "\\n"));
		//worldtimer[gameselecter][3]).replace(/%n/gm,"\\n"));
		data = data.replace("%H:%m:%s", rp[0]);
		data = data.replace("%Y/%m/%d %H:%M:%S", rp[2]);
	}
	else {
		data = data.replace("%H:%m:%s", "%d %hh:%mm:%ss(%hsH,%dsD)");
		data = data.replace("%Y/%m/%d %H:%M:%S", "%Y-%m-%dT%H:%M:%S%z (%a)");
	}
	data = data.replace("タイマー停止中(開始前/終了)", "終了しました");

	data = data.replace(/ロサンゼルス/gm, tzJAP[document.gm.gm.selectedIndex][0]);
	data = data.replace(/%TIMEZONE/gm, "");




	TextDL(data, "obsduration_timer_39" + worldtimer[gameselecter][0] + tzsupport + ".lua");
	return false;
}

function TextDL(n, t) { b = new Blob([n], { type: "text/plain" }), a = document.createElement("a"), a.download = t, a.href = window.URL.createObjectURL(b), e = document.createEvent("MouseEvent"), e.initEvent("click", !0, !0), a.dispatchEvent(e) }

function stringifyWithInfinity(obj) {
	return JSON.stringify(obj, (key, value) => {
		if (value === Infinity) {
			return 'Infinity';
		} else if (value === -Infinity) {
			return '-Infinity';
		}
		return value;
	});
}

function infinytime_keep(date_until) {
	if (date_until == "Infinity") {
		return "INFINTY";
	}

	var date = moment(date_until).format();

	return date;
}

function infinytime_keep_tz(date_until, tzst) {
	if (date_until == "Infinity") {
		return "INFINTY";
	}

	var date = moment(date_until).tz(tzst).format();

	return date;
}

function ZONE() {

	var tzst = tzJAP[document.gm.gm.selectedIndex][0];
	var tt = moment.tz.zone(tzst);

	var st = stringifyWithInfinity(tt) + "\r\n";

	//tt =JSON.parse(JSON.stringify(tt));

	for (var i = 0; i < tt.abbrs.length; i++) {
		st = st + "<tr><td>" + infinytime_keep(tt.untils[i]) + moment(tt.untils[i]).format("dddd") + "</td><td>" + infinytime_keep_tz(tt.untils[i], tzst) + moment(tt.untils[i]).tz(tzst).format("dddd") + "</td><td>前のタイムゾーン" + tt.abbrs[i] + " " + (-1) * tt.offsets[i] / 60 + "</td></tr>";
	}

	st = st.replace(/Invalid date/gm, "");

	var header = "<th>OS時間</th><th>TZローカル版</th><th>タイムゾーン</th>";
	st = "<table id=\"sampleTable\" class=\"tablesorter\">" + "<thead><tr>" + header + "</tr></thead><tbody>" + st + "</tbody></table>";


	document.getElementById("tzzone").innerHTML = st;
	return tt;
}