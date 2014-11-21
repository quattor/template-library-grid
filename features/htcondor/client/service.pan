unique template features/htcondor/client/service;

variable CONDOR_CONFIG={

	SELF['host'] = LRMS_SERVER_HOST;

	SELF['domain'] = 'grid';
	
	#Define the appropriate config files
	if(!is_defined(SELF['cfgfiles'])){
		SELF['cfgfiles']=list();
	};	

	file_list=list('global','security','worker');

	foreach(i;file;file_list){
		num = length( SELF['cfgfiles']);
		SELF['cfgfiles'][num] = nlist( 'name',file,'contents','features/htcondor/templ/' + file);
	};


	#Now fix the options 
	if(!is_defined(SELF['options'])){
		SELF['options'] = nlist();
	};


	if(!is_defined(SELF['options']['worker'])){
		SELF['options']['worker'] = nlist();
	};

	SELF;
};

include {'features/htcondor/config'};


