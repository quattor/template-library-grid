structure template features/htcondor/templ/preempt;

'text' = {
    txt = "";
    if (CONDOR_CONFIG['wctlimit'] != 0) {
        txt = txt + "## Configure default wallclocktime ##\n";
        txt = txt + "PREEMPT = true\n";
        txt = txt + "MaxJobRetirementTime = " + to_string(CONDOR_CONFIG['wctlimit']) + "\n";
    };

    txt;
};
