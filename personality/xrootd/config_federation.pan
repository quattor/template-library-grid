# This template does the federation-related part of the xrootd configuration, if enabled.
# It must be executed after the base Xrootd configuration.

unique template personality/xrootd/config_federation;

# Site-specific federation configuration
variable XROOTD_FEDERATION_SITE_CONFIG ?= null;

# Template for federation redirector Xrootd configuration file installed by RPM
variable XROOTD_FEDREDIR_CONFIG_TEMPLATE ?= XROOTD_CONFIG_DIR+'/xrootd-dpmfedredir_atlas.cfg';

# LFC connection parameters
variable XROOTD_LFC_PARAMS ?= {
  if ( !is_defined(SELF['lfcConnectionRetry']) ) {
    SELF['lfcConnectionRetry'] = 0;
  };
  if ( !is_defined(SELF['lfcSecurityMechanism']) ) {
    SELF['lfcSecurityMechanism'] = 'ID';
  };
  SELF;
};


# Check the list of federations to configure.
variable XROOTD_FEDERATION_LIST ?= error('Attempting to configure Xrootd federation but no federation list (XROOTD_FEDERATION_LIST) is empty');


# Check that all the requireed parameters for the enabled federations have been provided.
# Merge with default params for known federations.
include { 'personality/xrootd/env_federation' };


# Add role 'fedredir' to the current host
'/software/components/xrootd/hosts' = {
  if ( is_defined(SELF[FULL_HOSTNAME]['roles']) ) {
    SELF[FULL_HOSTNAME]['roles'][length(SELF[FULL_HOSTNAME]['roles'])] = 'fedredir';
  } else {
    error('No Xrootd role defined yet for '+FULL_HOSTNAME+' (internal error)');
  };
  SELF;
};


# Add xrootd and cmsd instances for each federation

'/software/components/xrootd/options/xrootdInstances' = {
  foreach (i;federation;XROOTD_FEDERATION_LIST) {
    instance = XROOTD_FEDERATION_PARAMS[federation]['instance'];
    logfile = XROOTD_INSTALL_LOG+'/xrootd.log';
    configfile = XROOTD_CONFIG_DIR+'/xrootd-dpmfedredir_'+instance+'.cfg';
    SELF[instance] = nlist('type', 'fedredir',
                           'configFile', configfile,
                           'federation', federation,
                           'logFile', logfile,
                          );
  };
  SELF;
};

'/software/components/xrootd/options/cmsdInstances' = {
  foreach (i;federation;XROOTD_FEDERATION_LIST) {
    instance = XROOTD_FEDERATION_PARAMS[federation]['instance'];
    SELF[instance] = value('/software/components/xrootd/options/xrootdInstances/'+instance);
    SELF[instance]['logFile'] = XROOTD_INSTALL_LOG+'/cmsd.log';
  };
  SELF;
};

'/software/components/xrootd/options/federations' = {
  foreach (federation;params;XROOTD_FEDERATION_PARAMS) {
    if ( index(federation,XROOTD_FEDERATION_LIST) >= 0 ) {
      debug('Defining configuration for federation '+federation);
      SELF[federation]['federationXrdManager'] = params['fedredir'] + ':'+ to_string(params['xrd_mgr_port']);
      SELF[federation]['federationCmsdManager'] = params['fedredir'] + '+:'+ to_string(params['cmsd_mgr_port']);
      SELF[federation]['localPort'] = params['local_port'];
      SELF[federation]['localRedirector'] = 'localhost:' + to_string(params['local_port']);
      if ( is_defined(params['valid_path_prefix']) ) {
        SELF[federation]['validPathPrefix'] = params['valid_path_prefix'];
      } else {
        SELF[federation]['validPathPrefix'] = '/' + params['vo'] + '/';
      };
      # namePrefix must be defined only if there is a Name2Name library configured
      if ( is_defined(params['n2n_library']) ) {
        SELF[federation]['n2nLibrary'] = params['n2n_library'];
        if ( is_defined(params['n2n_options']) ) {
          if ( is_defined('/software/components/xrootd/options/dpm/dpnsHost') ) {
            params['n2n_options'] = replace('%%DPNS_HOST%%',value('/software/components/xrootd/options/dpm/dpnsHost'),params['n2n_options']);
          };
          if ( is_defined('/software/components/xrootd/options/dpm/defaultPrefix') ) {
            dpm_vo_home = value('/software/components/xrootd/options/dpm/defaultPrefix')+SELF[federation]['validPathPrefix'];
            dpm_vo_home = replace('/$','',dpm_vo_home);
            params['n2n_options'] = replace('%%DPM_VO_HOME%%',dpm_vo_home,params['n2n_options']);
          };
          if ( is_defined(params['siteName']) ) {
            params['n2n_options'] = replace('%%ATLAS_SITENAME%%',params['siteName'],params['n2n_options']);
          };
          SELF[federation]['n2nLibrary'] = SELF[federation]['n2nLibrary'] + ' ' + params['n2n_options'];
        };
        if ( !is_defined(federation['namePrefix']) &&
             is_defined(value('/software/components/xrootd/options/dpm/defaultPrefix')) ) {
          SELF[federation]['namePrefix'] =  value('/software/components/xrootd/options/dpm/defaultPrefix') + '/' + params['vo'];
        };
        if ( is_defined(params['n2n_directories']) ) {
          if ( ! is_defined(SELF[federation]['namePrefix']) ) {
            error("'namePrefix' must be defined when 'n2n_directories' is specified");
          };
          if ( is_defined(params['n2n_prefix_attr']) ) {
            n2n_prefixes = params['n2n_prefix_attr'];
          } else {
            debug(format('%s: no attribute name specified for N2N prefixes',OBJECT));
            n2n_prefixes = '';
          };
          foreach (i;directory;params['n2n_directories']) {
            directory = replace('^/','',directory);
            if ( !match(directory,'/$') ) {
              directory = directory + '/';
            };
            n2n_prefixes = n2n_prefixes + format("%s/%s,",SELF[federation]['namePrefix'],directory);
          };
          n2n_prefixes = replace(',\s*$','',n2n_prefixes);
          SELF[federation]['n2nLibrary'] = SELF[federation]['n2nLibrary'] + ' ' + n2n_prefixes;
        };
      };
      SELF[federation]['redirectParams'] = params['fedredir'] + ':' + to_string(params['xrd_mgr_port']) + ' ? ' + SELF[federation]['validPathPrefix'];
      if ( is_defined('/software/components/xrootd/options/dpm/dpnsHost') ) {
        SELF[federation]['localRedirectParams'] = value('/software/components/xrootd/options/dpm/dpnsHost') + ':' + 
                                                     to_string(params['local_port']) + ' ' + SELF[federation]['validPathPrefix'];
      };

      if ( is_defined(params['lfc_host']) ) {
        SELF[federation]['lfcHost'] = params['lfc_host'];
        foreach (lfc_param;value;XROOTD_LFC_PARAMS) {
          SELF[federation][lfc_param] = value;
        };
      };

      # Configure Xrootd monitoring if destination hosts are specified
      if ( is_defined(params['monitoring_host']) ) {
        if ( is_defined(params['monitoring_options']) ) {
          monitoring_options = params['monitoring_options'];
        } else {
          monitoring_options = XROOTD_MONITORING_OPTIONS;
        };
        if ( is_defined(params['monitoring_events']) ) {
          monitoring_events = params['monitoring_events'];
        } else {
          monitoring_events = XROOTD_MONITORING_EVENTS;
        };
        monitoring_events_str = '';
        foreach (k;event;monitoring_events) {
           monitoring_events_str = monitoring_events_str + ' ' + event;
        };
        SELF[federation]['monitoringOptions'] = format('%s dest %s %s', monitoring_options, monitoring_events_str, params['monitoring_host']);
      };
      if ( is_defined(params['reporting_host']) ) {
        if ( is_defined(params['reporting_options']) ) {
          reporting_options = params['reporting_options'];
        } else {
          reporting_options = XROOTD_REPORTING_OPTIONS;
        };
        SELF[federation]['reportingOptions'] = params['reporting_host'] + ' ' + reporting_options;
      };
    };
  };
  SELF;
};


# Add packages for N2N mapping, if any required
'/software/packages' = {
  foreach (i;federation;XROOTD_FEDERATION_LIST) {
    if ( is_defined(XROOTD_FEDERATION_PARAMS[federation]['n2n_packages']) ) {
      foreach(j;package;XROOTD_FEDERATION_PARAMS[federation]['n2n_packages'] ) {
        SELF[package] = nlist();
      };
    };
  };
  SELF;
};


# Create the configuration file template for each instance.
# Use the usual filecopy trick to avoid a modification loop between
# filecopy and ncm-xrootd.

'/software/components/filecopy/services'= {
  # Load template configuration file if it exists
  config_template_src = if_exists('personality/xrootd/templates/fedredir_config');
  if ( is_defined(config_template_src) ) {
    src = create(config_template_src);
  };

  foreach (i;federation;XROOTD_FEDERATION_LIST) {
    instance = XROOTD_FEDERATION_PARAMS[federation]['instance'];
    configfile = XROOTD_CONFIG_DIR+'/xrootd-dpmfedredir_'+instance+'.cfg';
    if ( is_defined(src) ) {
      SELF[escape(configfile+'.templ-quattor')] = nlist('config', src['content'],
                                                        'owner', 'root:root',
                                                        'perms', '0644',
                                                        'restart', 'cp '+configfile+'.templ-quattor '+configfile,
                                                        );
    } else if ( configfile != XROOTD_FEDREDIR_CONFIG_TEMPLATE ) {
      SELF[escape(configfile+'.templ-quattor')] = nlist('source', XROOTD_FEDREDIR_CONFIG_TEMPLATE,
                                                        'owner', 'root:root',
                                                        'perms', '0644',
                                                        'restart', 'cp '+configfile+'.templ-quattor '+configfile,
                                                        );
    };
  };
  SELF;
};


# Enable cmsd service

'/software/components/chkconfig/service' = {
  SELF[XROOTD_CMSD_SERVICE] = nlist('on', '345',
                                    'startstop', true
                                   );
  SELF;
};


# Execute site-specific federation configuration, if any.
include { XROOTD_FEDERATION_SITE_CONFIG };

