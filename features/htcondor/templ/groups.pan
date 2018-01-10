structure template features/htcondor/templ/groups;

'text' = {

  # building the GROUP_NAMES entry

  submit_attrs = '';

  txt = "GROUP_NAMES = ";

  i=0;
  foreach(name;group;CONDOR_CONFIG['groups']){
	  txt=txt + name;
	  if(i < length(CONDOR_CONFIG['groups']) - 1){
		  txt = txt + ', ';
    };
    i=i+1;
  };
  txt = txt + "\n\n";

  # Some default values
  if(CONDOR_CONFIG['group_defaults']['accept_surplus']){
    txt = txt + "GROUP_ACCEPT_SURPLUS = True\n";
  }else{
    txt = txt + "GROUP_ACCEPT_SURPLUS = False\n";
  };

  # Some default values
  if(CONDOR_CONFIG['group_defaults']['autoregroup']){
    txt = txt + "GROUP_AUTOREGROUP = True\n";
  }else{
    txt = txt + "GROUP_AUTOREGROUP = False\n";
  };

  #Group quotas and limits
  foreach(name;group;CONDOR_CONFIG['groups']){
    is_dynamic='_DYNAMIC_';
    if(group['static']){
      is_dynamic='';
    };
    txt=txt + 'GROUP_QUOTA'+is_dynamic+ name +' = '+to_string(group['quota'])+"\n";
    if(is_defined(group['accept_surplus'])){
      txt=txt + 'GROUP_ACCEPT_SURPLUS' + name + " = ";
      if(group['accept_surplus']){
        txt = txt + "True\n";
      }else{
        txt = txt + "False\n";
      };
    };
  };
  txt = txt + "\n";

  txt;
};


