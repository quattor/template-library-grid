structure template features/htcondor/templ/groups_list;

'text' = {
    txt = '';
    foreach (group; j; CONDOR_CONFIG['groups']) {
        txt = txt + group + "\n";
    };

    txt;
};
