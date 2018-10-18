structure template features/htcondor/templ/groups_mapping;

'text' = {
    txt = "<group-mapping>\n";
    foreach(i; regexp; CONDOR_CONFIG['group_regexps']){
        txt = txt + format("<group match=\"%s\" result=\"%s\"/>\n", regexp['match'], regexp['result']);
    };

    foreach(i; regexp; CONDOR_CONFIG['policies_regexps']){
        txt = txt + format("<policy match=\"%s\" result=\"%s\"/>\n", regexp['match'], regexp['result']);
    };

    if(is_defined(CONDOR_CONFIG['tags_regexps'])){
        foreach(i; regexp; CONDOR_CONFIG['tags_regexps']){
            txt = txt + format("<tag match=\"%s\" result=\"%s\"/>\n", regexp['match'], regexp['result']);
        };
    };
    txt = txt +  '<tag match=".*" result="ALL"/>' + "\n";

    txt = txt  + "</group-mapping>\n";
    txt;
};
