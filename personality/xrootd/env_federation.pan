# This template  build the federation related parameters.
# It must be executed after the base Xrootd configuration but can be used
# independendly of the actual federation configuration.

unique template personality/xrootd/env_federation;

# Default parameters for some well known federations.
# For LHC VOs, the reference information is at https://svnweb.cern.ch/trac/lcgdm/wiki/Dpm/Xroot/ManualSetup.
# The key is a VO name.
variable XROOTD_FEDERATION_PARAMS_DEFAULT = {
  SELF['atlas'] = nlist('instance', 'atlasfed',
                        'cmsd_mgr_port', 1098,
                        'local_port', 11000,
                        'fedredir', undef,
                        'monitoring_host', 'atlas-fax-eu-collector.cern.ch:9930',
                        'monitoring_options', 'all rbuff 32k flush 30s fstat 60 lfn ops xfr 5 window 5s',
                        'monitoring_events', list('fstat','info','user','redir'),
                        'reporting_host', 'atl-prod05.slac.stanford.edu:9931',
                        'reporting_options', 'every 60s all -buff -poll sync',
                        'xrd_mgr_port', 1094,
                        'n2n_library', 'XrdOucName2NameLFC.so',
#                        Normally retrieved from AGIS but can be used to override AGIS definition
#                        'n2n_directories', list('/atlasdatadisk',
#                                                'atlaslocalgroupdisk',
#                                                'atlasgroupdisk/phys-susy',
#                                                'atlasgroupdisk/soft-test',
#                                                'atlasproddisk',
#                                                'atlasscratchdisk',
#                                               ),
                        'n2n_options', 'pssorigin=localhost sitename=%%ATLAS_SITENAME%%',
                        'n2n_prefix_attr', 'rucioprefix=',
                        'n2n_packages', list('xrootd-server-atlas-n2n-plugin'),
                        'siteName', undef,
                        #'vo', 'atlas',
                       );

  SELF['cms'] =   nlist('instance', 'cmsfed',
                        'cmsd_mgr_port', 1213,
                        'local_port', 11001,
                        'fedredir', undef,
                        'monitoring_host', 'xrootd.t2.ucsd.edu:9930',
                        'monitoring_options', 'all flush io 30s ident 5m fstat 60 lfn ops xfr 5 mbuff 8k rbuff 4k rnums 3 window 5s',
                        'monitoring_events', list('files','io','info','user','redir'),
                        'reporting_host', 'xrootd.t2.ucsd.edu:9931',
                        'reporting_options', 'every 60s all -buff -poll sync',
                        'xrd_mgr_port', 1094,
                        'n2n_library', 'libXrdCmsTfc.so',
                        'n2n_options', 'file:/etc/xrootd/storage.xml?protocol=direct',
                        'n2n_packages', list('xrootd-cmstfc'),
                        'siteName', undef,
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


