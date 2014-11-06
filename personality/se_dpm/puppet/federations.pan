unique template personality/se_dpm/puppet/federations;


'/software/packages/' = {
		     if(is_defined(XROOTD_FEDERATION_PARAMS)){
			if(is_defined(XROOTD_FEDERATION_PARAMS['cms'])){
				SELF[escape('xrootd-cmstfc')] = nlist();
			};
			if(is_defined(XROOTD_FEDERATION_PARAMS['atlas'])){
				SELF[escape('xrootd-server-atlas-n2n-plugin')] = nlist();
			};			
		     };
		     SELF;
};

