unique template personality/se_dpm/puppet/federations;


'/software/packages/' = {
  if(is_defined(XROOTD_FEDERATION_PARAMS)){
     if(is_defined(XROOTD_FEDERATION_PARAMS['cms'])){
       pkg_repl('xrootd-cmstfc');
     };
     if(is_defined(XROOTD_FEDERATION_PARAMS['atlas'])){
       pkg_repl('xrootd-server-atlas-n2n-plugin');
     };
  };
  SELF;
};

