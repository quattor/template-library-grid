unique template features/htcondor/client/ce;

variable CONDOR_CONFIG={

	file_list=list('submit');

	foreach(i;file;file_list){
		num = length( SELF['cfgfiles']);
		SELF['cfgfiles'][num] = nlist( 'name',file,'contents','features/htcondor/templ/' + file);
	};

	if(!is_defined(SELF['options']['submit'])){
		SELF['options']['submit'] = nlist();
	};

	SELF;
};


include {'features/htcondor/server/groups'};

variable BLPARSER_WITH_UPDATER_NOTIFIER=true;

variable CE_QUEUES ?={
  SELF['vos']['gridq']=VOS;
  SELF;		
};

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






