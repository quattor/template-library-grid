structure template features/htcondor/templ/submit;

'text' = {
       if (CE_STATUS == 'Closed' || CE_STATUS == 'Draining') {
           txt = "SCHEDDULER_ENABLE=false\n";
       } else {
           txt = "SCHEDDULER_ENABLE=true\n";
       };
       txt = txt + <<EOF;

if $(SCHEDDULER_ENABLE)
    DAEMON_LIST = $(DAEMON_LIST) SCHEDD
endif
EOF
	foreach(i;opt;CONDOR_CONFIG['options']['submit']){
		txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n"; 
	};
	txt;
};
