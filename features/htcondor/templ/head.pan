structure template features/htcondor/templ/head;

'text' = {
       txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) NEGOTIATOR COLLECTOR 

ROTATE_HISTORY_DAILY = true

MAX_HISTORY_ROTATIONS = 10

EOF
	foreach(i;opt;CONDOR_CONFIG['options']['head']){
		txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n"; 
	};
	txt;
};


