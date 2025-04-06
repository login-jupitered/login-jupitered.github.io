<!doctype html>
<html>
<head>
<base href="/login/">
<script>

if(navigator.userAgent.indexOf('Android')>=0)
	window.addEventListener('load',function() {setTimeout(sniff,100);});  // screen/window size wrong at first
else
	window.addEventListener('load',sniff);

function sniff() {

	mini=(navigator.userAgent.toLowerCase().indexOf('mobile')>0 && navigator.userAgent.indexOf('iPad')==-1 && Math.max(screen.width,screen.height)<1000)? 1:0;
		// ipad is 1024x768; netbooks may have size 1280x720, zoom may result in 1012x569; all phones have "mobile" in agent string
	touch=mini;

	ww=window.innerWidth;
	wh=window.innerHeight;
	if(ww<wh) sw=Math.min(screen.width,screen.height), sh=Math.max(screen.height,screen.width);  // screen size may or may not reflect orientation
	else sw=Math.max(screen.width,screen.height), sh=Math.min(screen.height,screen.width);
	scale=(Math.abs(ww-sw)<=2)? 1 : sw/ww;  // ignore slight irregularities
	bar=sh-wh*scale;  // size of browser bar (about 120) or status bar (about 20-25), adjust for screen zoom
		// got false bar 88 on android standalone first time only; okay if false positive for laptop fullscreen
	mobileapp=(navigator.standalone || bar<=40);
	
	document.form1.elements['mini'].value = mini;
	document.form1.elements['screensize'].value = screen.width+'x'+screen.height;
	document.form1.elements['mobileapp'].value = mobileapp? 1:0;

	try {  // detect ipad posing as laptop
		if(navigator.platform=='MacIntel' && navigator.maxTouchPoints>1) savecookie('agent','iPad-',0);
	} catch(e) {}

		redir=recoversession();  // redirects if valid
	
		document.form1.submit();
	}
</script>
<meta name=viewport content="width=device-width, initial-scale=1">
<title>Jupiter</title>
<script src="../js/1.js?4"></script>
<script src="../js/2.js?4"></script>
</head>
<body style="margin:20px; font-family:Arial; font-size:13px; user-select:text;">
<form name=form1 method=post action="/login/index.php">
<input type=hidden name=checkbrowser value=1>
<input type=hidden name=mini>
<input type=hidden name=screensize>
<input type=hidden name=mobileapp>
<input type=submit value="Continue" style="width:500px; height:300px; opacity:0;">
</form>
</body>
</html>
