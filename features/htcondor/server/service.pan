unique template features/htcondor/server/service;

variable CONDOR_CONFIG={

  SELF['host'] = LRMS_SERVER_HOST;

  SELF['domain'] = 'grid';
	
  #Define the appropriate config files
  if(!is_defined(SELF['cfgfiles'])){
    SELF['cfgfiles']=list();
  };	

  file_list=list('global','security');

  if(FULL_HOSTNAME == SELF['host']){
    file_list[length(file_list)]='head';
  };

  if(FULL_HOSTNAME == CE_HOST){
    file_list[length(file_list)]='submit';
  };

  foreach(i;file;file_list){
    num = length( SELF['cfgfiles']);
    SELF['cfgfiles'][num] = nlist( 'name',file,'contents','features/htcondor/templ/' + file);
  };

  if(!is_defined(SELF['options']['head'])){
    SELF['options']['head'] = nlist();
  };

  if(!is_defined(SELF['options']['submit'])){
    SELF['options']['submit'] = nlist();
  };

  SELF;
};

include {'features/htcondor/server/groups'};

variable CONDOR_HOST=CONDOR_CONFIG['host'];

variable BLPARSER_WITH_UPDATER_NOTIFIER=true;

variable CE_QUEUES ?={
  SELF['vos']['gridq']=VOS;
  SELF;		
};

include {'features/htcondor/config'};

#fix a bug in the blah rpm
include {'components/filecopy/config'};

'/software/components/filecopy/services/{/usr/libexec/condor_status.sh}' = {
  SELF['source']='/usr/libexec/condor_status.sh.save';
  SELF['perms']='0755';
  SELF; 
};

include {'components/dirperm/config'};

'/software/components/dirperm/paths' = push(nlist('path', '/var/glite/blah','type', 'd','owner','tomcat','perm','775'));

include {'components/chkconfig/config'};

'/software/components/chkconfig/service/glite-ce-blah-parser' = nlist('on', '', 'startstop', true);

