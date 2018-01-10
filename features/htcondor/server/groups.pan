unique template features/htcondor/server/groups;

variable CONDOR_CONFIG={

  SELF['cfgfiles'][length(SELF['cfgfiles'])]=nlist( 'name','groups','contents','features/htcondor/templ/groups');

  # Default list of standard group is build on the VO list
  if(!is_defined(SELF['stdgroups'])){
    SELF['stdgroups'] = list();
    foreach(i;vo;VOS){
      SELF['stdgroups'][length(SELF['stdgroups'])]='group_'+replace('\.','_',replace('-','_',vo));
    };
  };

  # By default four standard subgroups for each standard group
  if(!is_defined(SELF['stdsubgroups'])){
    SELF['stdsubgroups'] = list('admin','prod','pilot','default');
  };

  if(!is_defined(SELF['groups'])){
    SELF['groups'] = nlist();
  };

  # Add, if needed, the list of standard groups and subgroups
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

  # Defaults for the group_defaults entry.
  if(!is_defined(SELF['group_defaults'])){
    SELF['group_defaults'] = nlist();
  };

  # Accept group to use more than there quota
  if(!is_defined(SELF['group_defaults']['accept_surplus'])){
    SELF['group_defaults']['accept_surplus'] = true;
  };

  # Accept group to use more than there quota
  if(!is_defined(SELF['group_defaults']['autoregroup'])){
    SELF['group_defaults']['autoregroup'] = false;
  };

  # Default quota for a group
  if(!is_defined(SELF['group_defaults']['quota'])){
    SELF['group_defaults']['quota'] = 0.1;
  };

  # Now build the groups structure
  foreach(i;group;SELF['groups']){
    if(!is_defined(group['static'])){
      group['static'] = false;
    };

    if(!is_defined(group['quota'])){
      group['quota'] = SELF['group_defaults']['quota'];
    };
  };

  # Finally if the list of group regexps is not defined... create a default one
  if(!is_defined(SELF['group_regexps'])){
    SELF['group_regexps'] = list( nlist("match",'^\(([^,]+),\S+admin\S+,[^,]+,[^,]+\)$',"result","group_$1.admin"),
				  nlist("match",'^\(([^,]+),\S+prod\S+,[^,]+,[^,]+\)$',"result","group_$1.prod"),
				  nlist("match",'^\(([^,]+),\S+pilot\S+,[^,]+,[^,]+\)$',"result","group_$1.pilot"),
				  nlist("match",'^\(([^,]+)',"result","group_$1.default"),
				);
    };

  #
  # Define the policy groups. These are declared in the job ClassAds and are used to map a job into a polocy
  #  - by default queue:vo
  #  - be careful if you change it as it may be no longer compliant with the BDII definitions

  if(!is_defined(SELF['policies_regexps'])){
    SELF['policies_regexps'] = list( nlist("match",'^\(([^,]+),[^,]+,[^,]+,([^,]+)\)$',"result","$1.$2"));
  };

  SELF;
};

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/usr/libexec/condor_local_submit_attributes.sh}' = {
  SELF['config']=file_contents('features/htcondor/templ/condor_local_submit_attributes.sh');
  SELF['perms']='0755';
  SELF;
};

'{/etc/condor/groups_list}' = {
  dummy=create('features/htcondor/templ/groups_list');
  SELF['config']=dummy['text'];
  SELF['perms']='0644';
  SELF;
};

'{/etc/condor/groups_mapping.xml}' = {
  dummy=create('features/htcondor/templ/groups_mapping');
  SELF['config']=dummy['text'];
  SELF['perms']='0664';
  SELF;
};

'{/usr/libexec/matching_regexps}' = {
  SELF['config']=file_contents('features/htcondor/templ/matching_regexps');
  SELF['perms']='0755';
  SELF;
};

include 'components/spma/config';

# Needed as the matching script depends on it
'/software/packages' = pkg_repl('voms-clients3');

