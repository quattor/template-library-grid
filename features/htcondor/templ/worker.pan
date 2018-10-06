structure template features/htcondor/templ/worker;

'text' = {
    txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) STARTD

EOF

    foreach (i; opt; CONDOR_CONFIG['options']['worker']) {
        txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n";
    };

    txt = txt + format("MULTICORE=%s\n", CONDOR_CONFIG["multicore"]);

    offline = "false";
    drain = "false";

    if(exists(WN_ATTRS[FULL_HOSTNAME]) && exists(WN_ATTRS[FULL_HOSTNAME]['state'])){
        if(WN_ATTRS[FULL_HOSTNAME]['state'] == 'offline'){
            offline = "true";
        };
        if(WN_ATTRS[FULL_HOSTNAME]['state'] == 'drain'){
            drain = "true";
        };
    };

    txt = txt + format("DRAIN=%s\n", drain);

    txt = txt + format("OFFLINE=%s\n", offline);

    if (CONDOR_CONFIG["multicore"]) {
        txt = txt + format("MAXJOBRETIREMENTTIME=%s\n", CONDOR_CONFIG["maxvacatetime"]);
    };

    if (exists(WN_CPUS[FULL_HOSTNAME])) {
        txt = txt + format("NUM_CPUS=%s\n", WN_CPUS[FULL_HOSTNAME]);
    };

    if(is_defined(WN_ATTRS[FULL_HOSTNAME]['tags']) && (length(WN_ATTRS[FULL_HOSTNAME]['tags'])>0)){
        txt = txt + 'START_TAG = (';
        if(!is_defined(CONDOR_CONFIG["default_all_tag"]) || CONDOR_CONFIG["default_all_tag"]){
            txt = txt + '(WNTag == "ALL")||';
        };
        foreach(i; tag; WN_ATTRS[FULL_HOSTNAME]['tags']){
            txt = txt + '(WNTag == "' + tag + '")||';
        };
        txt = txt + " false)\n\n";
    }else{
        txt = txt + "START_TAG = true\n\n";
    };

    if(is_defined(CONDOR_CONFIG['start_custom'])){
        txt = txt + "START_CUSTOM = " + CONDOR_CONFIG['start_custom'] + "\n\n";
    }else{
        txt = txt + "START_CUSTOM = true\n\n";
    };

    if(is_defined(CONDOR_CONFIG['user_wrapper']) &&
       is_defined(CONDOR_CONFIG['user_wrapper']['path'])){
       txt = txt + "USER_JOB_WRAPPER = " +  CONDOR_CONFIG['user_wrapper']['path'] + "\n\n";
    };

    txt = txt + file_contents('features/htcondor/templ/worker-default');

    txt;
};

