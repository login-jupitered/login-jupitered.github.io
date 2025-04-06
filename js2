// staff & student logins

isbusy=1;  // 2=stay locked on load, 1=unlock on load, 99=gopost in progress
sessionlocked=false;
screenshowing='busy', screenshowing0='busy';

function showscreen(w) {  // w = screen / busy / lock / minimenu / minihelp
	if(w=='minimenu' && screenshowing=='minimenu') w='screen';  // 'minimenu' toggles to screen
	else if(w==screenshowing) return;
	// show/hide
	setviz('screen', w=='screen', 'errok');
	setviz('busy', w=='busy', 'errok');
	if(w=='busy') setstyle('busydot','busyanim', 'errok');
	setviz('sessionprompt', w=='lock', 'errok');
	if(mini) {
		if(!self.miniscroll) miniscroll=[];
		miniscroll[screenshowing]=[window.pageXOffset,window.pageYOffset];  // remember scroll
		setviz('mininavbar', w!='minihelp' && w!='lock', 'errok');
		setviz('minisubmast', w=='screen', 'errok');
		setviz('minimenu', w=='minimenu', 'errok');
		setviz('minihelp', w=='minihelp', 'errok');
		setviz('minihelpbar', w=='minihelp', 'errok');
		setviz('minisubhelp', w=='minihelp', 'errok');
		setstyle('touchmenulit', (w=='minimenu')?'lit':'', 'errok');
		setstyle('minirighttab', (w=='screen')?'minitab lit clip':'minitab clip', 'errok');
		// restore scroll and put nav bar at top
		var it=miniscroll[w];
		if(it) var x=it[0], y=it[1];
		else var x=0, y=0;
		window.scrollTo(x,y);  // fires scroll event after function
		pagescroll0=y;  // so scroll event doesn't do anything
		minibaropen=true;
		if(self.mininavo) mininavo.style.top='0px';
		// resize right tab in case changed while viewing help or menu
		if(w=='screen') rotatescreen1(0,1);  // redundant onload
	}
	screenshowing=w;
	if(w!='lock') screenshowing0=w;
}

// show/hide busy signal
function setbusy(x,msg) {  // 1 on leaving, 0 after loading
	isbusy=x;
	if(!el('busy')) return;
	setbusymsg(msg);
	showscreen(x?'busy':'screen');
}

function setbusymsg(msg) {
	if(msg) {
		postval('busymsg',msg);
		sethtml('busymsg1',msg,'errok');
	}
	else setval('busymsg','','errok');
}


// on load

window.addEventListener('load',function() {
	mainpageo=el('mainpage');
	sidebaro=el('sidebararea');
	mainpagetop=0;
	mainpageleft=(mini)? 6:20;
	var mainpageright=(mini)? 6:20;
	var mainpagebottom=(mini)? 10:20;
	var o;
	if(sidebaro) {  // teacher & student, not admin; not mini, not student touch
		var w=sidebaro.clientWidth;
		sidebarht=sidebaro.clientHeight;
		mainpageleft=w+20;
		if(self.username!==undefined) {  // staff only
			if(o=el('leftmast')) o.style.left=Math.max(w,66)+'px';
			if(o=el('pagetitle')) o.style.left=(w+20)+'px';
			setval('sidebarwidth',w);
		}
		sidebartop=70;
	}
	if(o=el('pagetitle2')) o.style.left=(el('pagecol2').getBoundingClientRect().left+mainpageleft)+'px';
	if(mini) {
		mininavo=el('mininav');
		var o;
		if(o=el('minisubmast')) {  // specialized mini submast
			var html=o.outerHTML;
			o.outerHTML='';
			mininavo.insertAdjacentHTML('beforeend',html);
			mainpagetop=75;
		}
		else {
			if(o=el('pagebuttons')) {
				o.style.right='auto';
				o.style.left='200px';
			}
			mainpagetop=(self.username!==undefined && el('submast'))? 75:40;
		}
		minibaropen=true;
	}
	else mainpagetop=(self.username!==undefined)? 105:70;
	if(touchos) {
		window.onorientationchange=rotatescreen1;
		rotatescreen1(0,1);
	}
	if(mainpageo) {
		mainpageo.style.padding=mainpagetop+'px '+mainpageright+'px '+mainpagebottom+'px '+mainpageleft+'px';
		if(sidebaro) mainpageo.style.minHeight=(sidebarht+mainpagetop-10)+'px';
	}
	if(self.onload) onload();
	if(isbusy==1) setbusy(0);
	if(self.resubmitted) locksession(true);
	pagescroll0 = window.pageYOffset;  // may change after onload
	if(mini) pagescrolldown = pagescrollup = pagescroll0;
	if(self.mobileapp && platform=='iOS' && !self.demo) savesession();  // session recoverability in ios standalone; not needed for android app
	if(self.watchinputs) recordinputs();
	// touch menu
	if(self.tsidebararea) {
		navsideopen=false;
		navsidew=Math.ceil(tsidebararea.offsetWidth);
		var html=tsidebararea.outerHTML;  // position inside mainpage
		tsidebararea.outerHTML='';
		mainpage.insertAdjacentHTML('beforeend',html);
		tsidebararea.style.left=(-navsidew)+'px';
	}
});

// ios standalone fires once after scroll; mobile safari fires repeatedly while scrolling
window.addEventListener('scroll',onscroll1);  // function must be named because some pages use removeEventListener()
function onscroll1() {
	lastact=Date.now();
	if(self.doscroll) doscroll();
	// sidebar (teacher mode)
	if(self.sidebaro) {  // similar in staff/dropbox.php
		var y=window.pageYOffset;
		var winht=(touchos)? window.innerHeight : document.documentElement.clientHeight;
		// up
		if(y>pagescroll0 && y>0 && sidebartop+sidebarht>winht-20) {
			sidebartop=Math.max(winht-20-sidebarht, sidebartop+pagescroll0-y);
			sidebaro.style.top=sidebartop+'px';
		}
		// down
		else if(y<pagescroll0 && sidebartop<70 && y+5<(document.documentElement.scrollHeight || document.body.scrollHeight)-winht) {
			sidebartop=Math.min(70, sidebartop+pagescroll0-y);
			sidebaro.style.top=sidebartop+'px';
		}
		pagescroll0=y;
	}
	// mini navbar
	else if(self.mininavo && !self.noscrollnav) {
		var y=window.pageYOffset;
		var winht=(touchos)? window.innerHeight : document.documentElement.clientHeight;
		if(y<0 || y+5>document.documentElement.scrollHeight-winht) return;  // beyond max scroll
		// down page
		if(y>pagescroll0) {
			pagescroll0=y, pagescrollup=y;
			if(minibaropen && (y-pagescrolldown>=40)) {  // hide nav
				minibaropen=false;
				mininavo.style.top='-70px';
			}
		}
		// up page
		else if(y<pagescroll0) {
			pagescroll0=y, pagescrolldown=y;
			if(!minibaropen && (pagescrollup-y>=40)) {  // show nav
				minibaropen=true;
				mininavo.style.top='0px';
			}
		}
	}
}

// adjust for portrait/landscape
mobileorient();
function mobileorient() {
	var x=window.orientation;
	var narrow=((x==0 || x==180) && Math.min(window.innerWidth,window.innerHeight)<=378);  // iphone 5 height=568, x1.5 = 378.667
	setstylerule('.alandonly','display', narrow?'none':'');
	setstylerule('.aportonly','display', narrow?'':'none');
	if(mini) {
		setstylerule('.landonly','display', narrow?'none':'');
		setstylerule('.portonly','display', narrow?'':'none');
	}
	return narrow;
}

// rotate touch screen
function rotatescreen1(e,init) {
	window.scrollBy(-window.pageXOffset,0);
	setTimeout(function() {
		var narrow=mobileorient();
		if(mini) {  // alter mini navbar
			var o=el('minirighttab');
			if(o) {
				var winw=window.innerWidth;
				var tabw=el('minileftnav').offsetWidth;
				o.style.maxWidth=(winw-tabw-37)+'px';  // set width of right tab
			}
			else if(o=el('minititle')) {  // substitute teacher: title in bar
				var winw=el('mininav').offsetWidth;
				o.style.width=(winw-38)+'px';
			}
		}
		if(self.rotatescreen) rotatescreen(narrow,init);
	}, init?0:700);  // delay needed for android; none on initial load
}

// max width on wide screen (staff only)
if(screen.width>1024 && !self.touch && self.username!==undefined) {
	// before html is drawn to avoid jumpiness
	var r=document.documentElement.clientWidth-1024;
	if(r>=20) {
		setstylerule('#rightnav','right',(r+10)+'px');
		setstylerule('#findbox','right',(r+12)+'px');
	}
	// more thorough reposition after html drawn
	window.addEventListener('load',function() {
		window.addEventListener('resize', resizewindow, true);
		resizewindow();
	});
}

function resizewindow() {
	var o, r=document.documentElement.clientWidth-1024;
	if(r<20) r=0;
	if((o=el('pagebuttons')) && !o.hasAttribute('fixed')) o.style.right=r+'px';
	if(o=el('rightnav')) o.style.right=(r+10)+'px';
	if(o=el('findbox')) o.style.right=(r+12)+'px';
	if(o=el('findhotspot')) o.style.right=r+'px';
	if(o=el('findpanel')) o.style.right=r+'px';
	if(o=el('findspace')) o.style.right=r+'px';
	if(o=el('findlist')) o.style.borderBottomRightRadius=(r?12:0)+'px';
}


// NAV MENUS

navopen=0;
findopen=0;

function popnav(i) {
	if(i==closedmenu && !navopen || sessionlocked) return;  // menu already closed by mousedown
	navopen=(i==navopen)? 0:i;
	if(typeof(i)=='number') {  // regular nav menu
		var d=el('tab'+i).className, dim=(d=='tabdim' || d=='navtabdim')? 'dim':'';
		setstyle('tab'+i, (navopen?'navtab':'tab')+dim);
		setstyle('nav'+i, navopen?'navlist':'hide');
		if(!navopen) return;
		var o=el('nav'+i);
	}
	else {  // big menus in nav bars
		var n=(i=='schoolyear')? 2:1;
		setstyle(i+'tab', navopen?'toptab'+n+'hi':'toptab'+n);
		setstyle(i+'list', navopen?'topnav'+n+'list':'hide');
		if(!navopen) return;
		var o=el(i+'list');
		o.style.minWidth=(el(i+'tab').clientWidth-2)+'px';
	}
	// make menu scrollable if taller than window
	o.style.height='auto';
	var winht=(touchos)? window.innerHeight : document.documentElement.clientHeight;
	var r=o.getBoundingClientRect();
	if(r.bottom>winht) {
		o.style.height=(r.height-r.bottom+winht)+'px';
		o.style.borderRadius=(typeof(i)=='number')?'0px 11px 0px 0px':'0px';
	}
	else o.style.borderRadius=(typeof(i)=='number')?'0px 11px 11px 11px':'0px 0px 11px 11px';
}

function showtouchnavmenu() {
	navsideopen=!navsideopen;
	if(navsideopen) {
		setstyle('touchnavbtn','touchnavopen');
		el('tsidebararea').style.top=(70+window.pageYOffset)+'px';
		mainpage.style.transform='translateX('+navsidew+'px)';
	}
	else {
		setstyle('touchnavbtn','');
		mainpage.style.transform='translateX(0px)';
	}
}

// gradebook / school / year menu
function showminimenu2(w) {
	if(!self.mininavopens) mininavopens=[];
	mininavopens[w]=!Boolean(mininavopens[w]);
	setviz(w+'1',mininavopens[w]);
	setviz(w+'2',mininavopens[w]);
	setviz(w+'widget',!mininavopens[w]);
	setstyle(w+'selection', mininavopens[w]?'rowlit pad10':'row pad10');
}


// NAVIGATION

window.onbeforeunload=function() {
	if(dovar && location.href.indexOf('/0/')>=0)
		return "*** CHANGES NOT SAVED ***\n\nChanges will be lost if you click Back, Reload, or close this browser window. Cancel this prompt, then click Logout.";
}

function go(to1,param,m,revert,demook) {  // this is the only way to leave a page; revert=true to discard changes and go to different page
	if(sessionlocked && to1!='logout') return;
	if(document.activeElement && document.activeElement.blur) document.activeElement.blur();  // fail-safe if onchange not fired yet
	if(!revert && !self.demo && grounded()) return;
	if(revert) dovar='';
	if(self.isnetlost && isnetlost()) return;
	if(param!=null) postval('param',param);
	setval('to', to1 || '', 'errok');
	if(self.demo) {
		if(!to1) to1=self.demofile || val('from');
		if(demook) gopost(to1+'.php');
		else if(self.mobileapp) location='../login/';
		else window.close();
		return;
	}
	if(dovar) postval('todo',dovar);
	if(self.timedif!==undefined) postval('pagereq',now(true)-timedif);
	if(self.watchinputs) auditinputs();
	if(!m && !revert) m=(dovar)? 'Saving':'Loading'; ///tr() ?
	setbusy(1,m);
	window.onbeforeunload=null;
	setTimeout(function() {document.form1.submit()});
}

function revert() {
	if(!dovar || self.demo || sessionlocked) return false;
	setbusymsg("Reverting");
	dovar='';
	if(self.watchinputs) auditinputs();
	setTimeout(function() {document.form1.submit()});
}

leaveok=false;
function grounded() {
	if(leaveok) return;  // avoid recursion
	if(self.leaving) {
		if(leaving()=='dontleave') return true;
	}
	if(self.helppanel) savehelp();
	leaveok=1;
}

// prevent Back navigation
if(history.pushState && !self.demo) {
	history.pushState('','');
	window.onpopstate=function(event) {history.pushState('','');}
}


// DO

dovar='';
function doit(x,p) {
	if(self.demo) return;
	x+=',';
	if((','+dovar).indexOf(','+x)<0) dovar+=x;
	if(p!=null) postval('param',p);
}


// PRESERVE SESSION

// when must leave browser window and return: mobile app open file, google/dropbox pickers
// overrides="var=val&var=val..." to replace or add to hidden inputs
function savesession(overrides) {
	if(!inp('session') || self.proxy) return;  // save only if in session
	var a=[];
	var o,v,it;
	var z=document.form1.elements.length-1;
	for(var i=0; i<=z; i++) {
		o=document.form1.elements[i];
		if(o.type!='hidden') continue;
		v=o.name;
		if(v=='to' || v=='todo' || v=='serial') continue;  // preserve all hidden inputs except these
		a[v]=o.value;
	}
	if(overrides) {
		overrides=overrides.split('&');
		for(var i=0; i<overrides.length; i++) {
			it=overrides[i].split('=');
			a[it[0]]=it[1];
		}
	}
	var flat='';
	for(v in a) {
		if(flat) flat+="\n";
		flat+=v+"\t"+a[v];
	}
	var ok1=savelocal('session_time',now(true));
	var ok2=savelocal('session_url',document.form1.action);
	var ok3=savelocal('session_post',flat);
	if(!ok1 || !ok2 || !ok3) {
		logit('abort savesession');
		deletelocal('session');
	}
}

// return true if session to recover, false if none
function recoversession() {
	var timestamp=getlocal('session_time');
	if(!timestamp) return;
	var url=getlocal('session_url');
	var post=getlocal('session_post');
	deletelocal('session');
	if(!url || !post) return;  // fail-safe
	if(now(true)-timestamp>60*60) return logit('session stale');  // ignore after 1 hour
	postval('recoversession',1);  // for diagnostics
	post=post.split("\n");
	for(var i=0; i<post.length; i++) {
		var it=post[i].split("\t");
		postval(it[0],it[1]);
	}
	//if(location.host.indexOf('jupitered.com')==-1) alert('recoversession');  ///dev
	gopost(url);  // 0/staff.php, 0/student.php
	return true;
}


// watch hidden inputs for corruption
watchinputs=true, hidinputs=[];

function recordinputs() {  // on load record hidden inputs
	var v,o;
	for(v in document.form1.elements) {
		if(v-0 || v==0 || v=='find' || (v+'').substr(0,6)=='usesub') continue;
		o=document.form1.elements[v];
		if(o.type!='hidden' || el('text_'+v) || el(v+'_script') || el(v+'_1') || el(v+'_label')) continue;  // not textbox, checkbox, radio, menu
		hidinputs[v]=String(o.value);
	}
}

function auditinputs() {  // on leave check if hidden inputs corrupted
	var v,o;
	for(v in hidinputs) {
		o=document.form1.elements[v];
		if(!o || String(o.value)==hidinputs[v] || hidinputs[v].length>100) continue;
		watchjs=true;
		if(val('from')!='pod')  // known issue with pod on Edge/browser
			logjserror('corrupt input '+v+'='+hidinputs[v]+' ≠ '+o.value);
		o.value=hidinputs[v];
	}
}
