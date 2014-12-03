structure template features/htcondor/templ/groups_mapping;

'text' = {
       txt="<group-mapping>\n";
       foreach(i;regexp;CONDOR_CONFIG['group_regexps']){
			txt=txt + '<group match="' + regexp['match'] + '" result="' + regexp['result'] + '"/>'+"\n";
       };

       txt= txt  + "</group-mapping>\n";
       txt;
};
