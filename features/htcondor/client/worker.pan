unique template features/htcondor/client/worker;

variable CONDOR_CONFIG={

	file_list=list('worker');

	foreach(i;file;file_list){
		num = length( SELF['cfgfiles']);
		SELF['cfgfiles'][num] = nlist( 'name',file,'contents','features/htcondor/templ/' + file);
	};

	if(!is_defined(SELF['options']['worker'])){
		SELF['options']['worker'] = nlist();
	};

	SELF;
};
