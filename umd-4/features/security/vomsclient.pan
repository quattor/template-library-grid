unique template features/security/vomsclient;

include { 'components/vomsclient/config' };

variable VOMS_LSC_FILE ?= true;
variable VOMSES_DIR ?= '/etc/vomses';
'/software/components/vomsclient/vomsServersDir' = VOMSES_DIR;
'/software/components/vomsclient/' = {
	if ( VOMS_LSC_FILE ) {
		SELF['lscfile']=VOMS_LSC_FILE;
		SELF;
	} else {
		SELF;
	};
};
