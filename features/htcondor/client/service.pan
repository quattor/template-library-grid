unique template features/htcondor/client/service;


variable CONDOR_CONFIG={

  SELF['host'] = LRMS_SERVER_HOST;

  SELF['domain'] = 'grid';
	
  #Define the appropriate config files
  if(!is_defined(SELF['cfgfiles'])){
    SELF['cfgfiles']=list();
  };	

  file_list=list('global','security');

  foreach(i;file;file_list){
    num = length( SELF['cfgfiles']);
    SELF['cfgfiles'][num] = nlist( 'name',file,'contents','features/htcondor/templ/' + file);
  };


  #Now fix the options 
  if(!is_defined(SELF['options'])){
    SELF['options'] = nlist();
  };

  SELF;
};

variable CONDOR_HOST ?= CONDOR_CONFIG['host'];

include {
  if(index(FULL_HOSTNAME,CE_HOSTS) < 0){
    'features/htcondor/client/worker';	   	 
  }else{
    'features/htcondor/client/ce';
  };
};


include {'features/htcondor/config'};


