unique template features/htcondor/server/service;

variable CONDOR_CONFIG={

  SELF['host'] = LRMS_SERVER_HOST;

  SELF['domain'] = 'grid';
	
  #Define the appropriate config files
  if(!is_defined(SELF['cfgfiles'])){
    SELF['cfgfiles']=list();
  };	

  file_list=list('global','security','head');

  foreach(i;file;file_list){
    num = length( SELF['cfgfiles']);
    SELF['cfgfiles'][num] = nlist( 'name',file,'contents','features/htcondor/templ/' + file);
  };

  if(!is_defined(SELF['options']['head'])){
    SELF['options']['head'] = nlist();
  };

  SELF;
};

include {'features/htcondor/server/groups'};

variable CONDOR_HOST=CONDOR_CONFIG['host'];

variable CE_QUEUES ?={
  SELF['vos']['gridq']=VOS;
  SELF;
};


include {
  if(index(FULL_HOSTNAME,CE_HOSTS) >= 0){
    'features/htcondor/client/ce';
  }else{
    null;
  };
};


include {'features/htcondor/config'};
