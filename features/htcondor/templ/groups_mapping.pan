structure template features/htcondor/templ/groups_mapping;

'text' = {
    txt = "<group-mapping>\n";
    foreach(i; regexp; CONDOR_CONFIG['group_regexps']){
        txt = txt + '<group match="' + regexp['match'] + '" result="' + regexp['result'] + '"/>' + "\n";
    };

    foreach(i; regexp; CONDOR_CONFIG['policies_regexps']){
        txt = txt + '<policy match="' + regexp['match'] + '" result="' + regexp['result'] + '"/>' + "\n";
    };
       
    if(is_defined(CONDOR_CONFIG['tags_regexps'])){
        foreach(i; regexp; CONDOR_CONFIG['tags_regexps']){
            txt = txt + '<tag match="' + regexp['match'] + '" result="' + regexp['result'] + '"/>' + "\n";
        };
    };
    txt = txt +  '<tag match=".*" result="ALL"/>' + "\n";

    txt = txt  + "</group-mapping>\n";
    txt;
};
