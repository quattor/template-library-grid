structure template features/htcondor/templ/submit;

'text' = {
    txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) SCHEDD

ROTATE_HISTORY_DAILY = true
MAX_HISTORY_ROTATIONS = 1000

EOF
    if(is_defined(CONDOR_CONFIG['queue_superusers_list'])){
        txt = txt + 'QUEUE_SUPER_USERS = ' + CONDOR_CONFIG['queue_superusers_list'];
    };

    foreach (i; opt; CONDOR_CONFIG['options']['submit']) {
        txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n";
    };
    txt = txt + "\n";

    first = true;

    foreach (name; rule; CONDOR_CONFIG['gc_rules']) {
        if (first) {
            txt = txt + "SYSTEM_PERIODIC_REMOVE = (" + rule + ')\' + "\n";
            first = false;
        } else {
            txt = txt + '|| (' + rule + ')\' + "\n";
        };
    };

    txt = txt + "\n";

    if (is_defined(CONDOR_CONFIG['submit_rules']) && (length(CONDOR_CONFIG['submit_rules'])>0)) {
        txt = txt + 'SUBMIT_REQUIREMENT_NAMES =';

        foreach (name; rule; CONDOR_CONFIG['submit_rules']) {
            txt = txt + ' ' + name;
        };

        txt = txt + "\n";

        foreach (name; rule; CONDOR_CONFIG['submit_rules']) {
            if(!is_defined(rule['rule'])){
                error("rule CONDOR_CONFIG[submit_rules][" + name + "] is missing rule definition.");
            };
            txt = txt + 'SUBMIT_REQUIREMENT_' + name + ' = ' + rule['rule'] + "\n";
            if (is_defined(rule['reason'])) {
                txt = txt + 'SUBMIT_REQUIREMENT_' + name + '_REASON = "' + rule['reason'] + '"' + "\n";
            };
        };

        txt = txt + "\n";
    };

    txt;
};

