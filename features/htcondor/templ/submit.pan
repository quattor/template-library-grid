structure template features/htcondor/templ/submit;

'text' = {
       txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) SCHEDD 

EOF
	foreach(i;opt;CONDOR_CONFIG['options']['submit']){
		txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n"; 
	};
	txt;
};


