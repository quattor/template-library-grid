structure template features/htcondor/templ/worker;

'text' = {
       txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) STARTD

EOF
	foreach(i;opt;CONDOR_CONFIG['options']['worker']){
		txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n"; 
	};
	txt;
};


