# This template  build the federation related parameters.
# It must be executed after the base Xrootd configuration but can be used
# independendly of the actual federation configuration.

unique template glite/xrootd/env_federation;

# Default parameters for some well known federations.
# The key is a VO name.
variable XROOTD_FEDERATION_PARAMS_DEFAULT = {
  SELF['atlas'] = nlist('instance', 'atlasfed',
                        'cmsd_mgr_port', 1098,
                        'lfc_host', 'prod-lfc-atlas-ro.cern.ch',
                        'local_port', 11000,
                        'fedredir', undef,
                        'monitoring_host', 'atl-prod05.slac.stanford.edu:9930',
                        'reporting_host', 'atl-prod05.slac.stanford.edu:9931',
                        'xrd_mgr_port', 1094,
                        'n2n_library', 'XrdOucName2NameLFC.so',
                        'n2n_options', 'root=%%DPM_VO_HOME%% match=%%DPNS_HOST%%',
                        'n2n_packages', list(nlist('name', 'xrootd-server-atlas-n2n-plugin',
                                                   'version', '1.0.0-3.el5',
                                                   'arch', PKG_ARCH_GLITE),
                                             nlist('name', 'lfc-libs',
                                                   'version', '1.8.3.1-1.el5',
                                                   'arch', PKG_ARCH_GLITE),
                                             nlist('name', 'lfc-devel',
                                                   'version', '1.8.3.1-1.el5',
                                                   'arch', PKG_ARCH_GLITE),
                                           ),
                        #'vo', 'atlas',
                       );

  SELF['cms'] =   nlist('instance', 'cmsfed',
                        'cmsd_mgr_port', 1213,
                        'local_port', 11001,
                        'fedredir', undef,
                        'xrd_mgr_port', 1094,
                        'n2n_library', 'libXrdCmsTfc.so',
                        'n2n_options', 'file:/etc/xrootd/storage.xml?protocol=direct',
                        'n2n_packages', list(nlist('name', 'xerces-c',
                                                   'version', '2.7.0-8.el5',
                                                   'arch', PKG_ARCH_GLITE),
                                             nlist('name', 'xrootd-cmstfc', 
                                                   'version', '1.4.3-3.osg.el5',
                                                   'arch', PKG_ARCH_GLITE),
                                            ),
                        'valid_path_prefix', '/store/',
                        'vo', 'cms',
                       );
  SELF;
};


# Ensure that the list of federations to configure, if defined, is a list.
# It can also be specified as a string if there is only one federation.
# If undefined, define it as an empty list to ease further processing.
variable XROOTD_FEDERATION_LIST ?= undef;
variable XROOTD_FEDERATION_LIST_TMP = {
  if ( !is_defined(XROOTD_FEDERATION_LIST) ) {
    list();
  } else if ( is_string(XROOTD_FEDERATION_LIST) ) {
    list(XROOTD_FEDERATION_LIST);
  } else if ( !is_list(XROOTD_FEDERATION_LIST) ) {
    error('XROOTD_FEDERATION_LIST must be a string or a list of string');
  } else {
    XROOTD_FEDERATION_LIST;
  };
};
variable XROOTD_FEDERATION_LIST = undef;
variable XROOTD_FEDERATION_LIST = XROOTD_FEDERATION_LIST_TMP;


# Check that all the requireed parameters for the enabled federations have been provided.
# Merge with default params for known federations.
variable XROOTD_FEDERATION_PARAMS = {
    foreach (i;federation;XROOTD_FEDERATION_LIST) {
    if ( !is_defined(SELF[federation]) ) {
      if ( is_defined(XROOTD_FEDERATION_PARAMS_DEFAULT[federation]) ) {
        SELF[federation] = XROOTD_FEDERATION_PARAMS_DEFAULT[federation];
      } else {
        error("No parameter specified in XROOTD_FEDERATION_PARAMS for Xrootd federation '"+federation+"'");
      };
    } else {
       if ( is_defined(XROOTD_FEDERATION_PARAMS_DEFAULT[federation]) ) {
         foreach (param;value;XROOTD_FEDERATION_PARAMS_DEFAULT[federation]) {
           if ( !is_defined(SELF[federation][param]) ) {
             debug("Parameter '"+param+"' for federation '"+federation+"' set to default value ("+to_string(value)+")");
             SELF[federation][param] = value;
           };
         };
       };
    };
    fed_params = SELF[federation];
    if ( !is_defined(fed_params['xrd_mgr_port']) ) {
      error("xrootd manager port for Xrootd federation '"+federation+"' not specified: no default");
    };
    if ( !is_defined(fed_params['cmsd_mgr_port']) ) {
      error("cmsd manager port for Xrootd federation '"+federation+"' not specified: no default");
    };
    if ( !is_defined(fed_params['local_port']) ) {
      error("xrootd local port for Xrootd federation '"+federation+"' not specified: no default");
    };
    if ( !is_defined(fed_params['fedredir']) ) {
      error("Global redirector to use for Xrootd federation '"+federation+"' not specified: no default");
    };
    if ( !is_defined(fed_params['instance']) ) {
      SELF[federation]['instance'] = federation+'fed';
    };
    if ( !is_defined(fed_params['vo']) ) {
      SELF[federation]['vo'] = federation;
    };
  };

  debug('XROOTD_FEDERATION_PARAMS: '+to_string(XROOTD_FEDERATION_PARAMS));
  SELF;
};


