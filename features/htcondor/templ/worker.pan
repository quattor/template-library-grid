structure template features/htcondor/templ/worker;

'text' = {
  txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) STARTD

EOF

  foreach(i;opt;CONDOR_CONFIG['options']['worker']){
    txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n"; 
  };

  txt = txt + format("MULTICORE=%s\n",CONDOR_CONFIG["multicore"]);

  offline="false";
  drain="false";

  if(exists(WN_ATTRS[FULL_HOSTNAME]) && exists(WN_ATTRS[FULL_HOSTNAME]['state'])){
    if(WN_ATTRS[FULL_HOSTNAME]['state'] == 'offline'){
      offline="true";
    };
    if(WN_ATTRS[FULL_HOSTNAME]['state'] == 'drain'){
      drain="true";
    };
  };

  txt = txt + format("DRAIN=%s\n",drain);	

  txt = txt + format("OFFLINE=%s\n",offline);

  if (CONDOR_CONFIG["multicore"]) {
    txt = txt + format("MAXJOBRETIREMENTTIME=%s\n", CONDOR_CONFIG["maxvacatetime"]);
  };

  if (exists(WN_CPUS[FULL_HOSTNAME])) {
    txt = txt + format("NUM_CPUS=%s\n",WN_CPUS[FULL_HOSTNAME]);
  };

  txt = txt + file_contents('features/htcondor/templ/worker-default');

  txt;
};



