structure template features/htcondor/templ/condor_mapfile;

'text' = {
    txt = '';

    foreach(i; rule; CONDOR_CONFIG['mapping'])
        if(!is_null(rule))
            txt = txt + rule['type'] + ' ' + rule['regex'] + ' ' + rule['result'] + "\n";

    txt;
};
