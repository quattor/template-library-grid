structure template features/htcondor/templ/submit;

'text' = {
       txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) SCHEDD 

ROTATE_HISTORY_DAILY = true
MAX_HISTORY_ROTATIONS = 1000

EOF
	foreach(i;opt;CONDOR_CONFIG['options']['submit']){
		txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n"; 
	};
	txt = txt + "\n";

	first=true;

	foreach(name;rule;CONDOR_CONFIG['gc_rules']){
	  if(first){
	    txt = txt + "SYSTEM_PERIODIC_REMOVE = (" + rule +')\'+"\n";
	    first=false;
	  }else{
	    txt = txt + '|| (' + rule + ')\'+"\n"; 
	  };
	};

	txt = txt + "\n";
	txt;
};


