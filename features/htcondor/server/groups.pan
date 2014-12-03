unique template features/htcondor/server/groups;

variable CONDOR_CONFIG={

  SELF['cfgfiles'][length(SELF['cfgfiles'])]=nlist( 'name','groups','contents','features/htcondor/templ/groups');

  #Default list of standard group is build on the VO list
  if(!is_defined(SELF['stdgroups'])){
    SELF['stdgroups'] = list();
    foreach(i;vo;VOS){
      SELF['stdgroups'][length(SELF['stdgroups'])]='group_'+replace('\.','_',vo);
    };
  };

  #by default four standard subgroups for each standard group
  if(!is_defined(SELF['stdsubgroups'])){
    SELF['stdsubgroups'] = list('admin','prod','pilot','default');
  };
	
  if(!is_defined(SELF['groups'])){
    SELF['groups'] = nlist();
  };	

  #Add, if needed, the list of standard groups and subgroups
  foreach(i;group;SELF['stdgroups']){
    if(!is_defined(SELF['groups'][group])){
      SELF['groups'][group] = nlist();
    };
    foreach(j;subgroup;SELF['stdsubgroups']){
      if(!is_defined(SELF['groups'][group + '.' + subgroup])){
        SELF['groups'][group + '.' + subgroup] = nlist();
      };			
    };
  };

  #Defaults for the group_defaults entry.
  if(!is_defined(SELF['group_defaults'])){
    SELF['group_defaults'] = nlist();
  };		

  if(!is_defined(SELF['group_defaults']['accept_surplus'])){
    SELF['group_defaults']['accept_surplus'] = true;
  };		

  if(!is_defined(SELF['group_defaults']['quota'])){
    SELF['group_defaults']['quota'] = 0.1;
  };		

  #Now build the groups structure
  foreach(i;group;SELF['groups']){
    if(!is_defined(group['static'])){
      group['static'] = false;
    };

    if(!is_defined(group['quota'])){
      group['quota'] = SELF['group_defaults']['quota'];
    };				
  };

  #finally if the list of group regexps is notr defined... create a default one
  if(!is_defined(SELF['group_regexps'])){
    SELF['group_regexps'] = list( nlist("match",'^\(([^,]+),\S+admin\S+,.+\)$',"result","group_$1.admin"),
				  nlist("match",'^\(([^,]+),\S+prod\S+,.+\)$',"result","group_$1.prod"),
				  nlist("match",'^\(([^,]+),\S+pilot\S+,.+\)$',"result","group_$1.pilot"),
				  nlist("match",'^\(([^,]+)',"result","group_$1.default"),
				);
    };

  SELF;
};

'/software/components/filecopy/services/{/usr/libexec/condor_local_submit_attributes.sh}' = {
  SELF['config']=file_contents('features/htcondor/templ/condor_local_submit_attributes.sh');
  SELF['perms']='0755';
  SELF; 
};

'/software/components/filecopy/services/{/etc/condor/groups_list}' = {
  dummy=create('features/htcondor/templ/groups_list');
  SELF['config']=dummy['text'];
  SELF['perms']='0644';
  SELF; 
};

'/software/components/filecopy/services/{/etc/condor/groups_mapping.xml}' = {
  dummy=create('features/htcondor/templ/groups_mapping');
  SELF['config']=dummy['text'];
  SELF['perms']='0664';
  SELF; 
};

'/software/components/filecopy/services/{/usr/libexec/matching_regexps}' = {
  SELF['config']=file_contents('features/htcondor/templ/matching_regexps');
  SELF['perms']='0755';
  SELF; 
};

