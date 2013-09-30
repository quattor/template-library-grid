
unique template glite/xrootd/config;

# Define basic Xrootd installation files and directories
include { 'glite/xrootd/env' };

# Use Alice token authorization mechanism
variable XROOTD_AUTH_USE_TOKEN ?= false;
variable XROOTD_TOKEN_AUTHZ_CONF_FILE ?= XROOTD_AUTH_TOKEN_CONF_DIR + '/TkAuthz.Authorization';
variable XROOTD_AUTH_TOKEN_PRIVKEY_DEFAULT ?= XROOTD_AUTH_TOKEN_CONF_DIR + '/privkey.pem';
variable XROOTD_AUTH_TOKEN_PUBKEY_DEFAULT ?= XROOTD_AUTH_TOKEN_CONF_DIR + '/pubkey.pem';
# Multiple VO support with token-based authz is unsecure...
variable XROOTD_AUTH_TOKEN_MULTIPLE_VOS_ENABLED ?= false;

variable XROOTD_AUTH_LIBRARY_TOKEN_AUTH ?= 'libXrdAliceTokenAcc.so.0.0.0';

# Configuration file templates to push on Xrootd nodes (they will be pushed to XROOTD_CONFIG_DIR).
# Set to null to use those provided by the RPM.
variable XROOTD_DISK_CONFIG_NAME ?= 'xrootd-dpmdisk.cfg';
variable XROOTD_REDIR_CONFIG_NAME ?= 'xrootd-dpmredir.cfg';

# Default monitoring options, when enabled
variable XROOTD_MONITORING_OPTIONS ?= 'all rbuff 32k auth flush 30s  window 5s dest files info user io redir';
variable XROOTD_REPORTING_OPTIONS ?= 'every 60s all -buff -poll sync';
# Monitoring destinations: both must be lists
variable XROOTD_MONITORING_DESTINATIONS ?= undef;
variable XROOTD_REPORTING_DESTINATIONS ?= undef;

# Default instances
variable XROOTD_XROOTD_INSTANCES = {
  # At least one disk and one redir instances are needed
  disk_instance_found = false;
  redir_instance_found = false;
  foreach (instance;params;SELF) {
    if ( params['type'] == 'disk' ) {
      disk_instance_found = true;
    } else  if ( params['type'] == 'redir' ) {
      redir_instance_found = true;
    };
  };
  if ( !disk_instance_found || !redir_instance_found ) {
    error("XROOTD_XROOTD_INSTANCES invalid: at least a disk and a redirector instance are required");
  };
  SELF;
};

# This variable sets the role of the node (redir, disk, both)
variable XROOTD_SERVER_ROLES ?= error("XROOTD_SERVER_ROLES undefined: no default providedi. Possible roles: disk, redir");


# Ensure that required elements are configured if token-based authz is used
variable XROOTD_TOKEN_AUTH_PARAMS = {
  # exportedVOs can be specified either as a list or nlist. Convert to a nlist for easier
  # further processing if this is a list.
  # When this is a list, assume that the exported path is empty which means that the VO name
  # will be appended to exportedPathRoot. If it is an nlist, for each VO, the value is a nlist
  # allowing to specify the export path, either as an absolute path or as a path relative to
  # exportedPathRoot.
  if ( XROOTD_AUTH_USE_TOKEN ) {
    if ( !is_defined(SELF['tokenPrivateKey']) ) {
      SELF['tokenPrivateKey'] = XROOTD_AUTH_TOKEN_PRIVKEY_DEFAULT;
    };
    if ( !is_defined(SELF['tokenPublicKey']) ) {
      SELF['tokenPublicKey'] = XROOTD_AUTH_TOKEN_PUBKEY_DEFAULT;
    };
    if ( !is_defined(SELF['exportedVOs']) ) {
      error("XROOTD_TOKEN_AUTH_PARAMS['exportedVOs'] is required when using Xrootd token-based authz");
    } else {
      if ( is_list(XROOTD_TOKEN_AUTH_PARAMS['exportedVOs']) ) {
        exported_vos = nlist();
        foreach (i;vo;XROOTD_TOKEN_AUTH_PARAMS['exportedVOs']) {
          exported_vos[vo] = nlist();
        };
        SELF['exportedVOs'] = undef;
        SELF['exportedVOs'] = exported_vos;
      };
      if ( is_nlist(SELF['exportedVOs']) ) {
        foreach(vo;params;SELF['exportedVOs']) {
          if ( index(vo,VOS) < 0 ) {
            error("Exported VO '"+vo+"' is not configured on local node");
          };
        };
      } else {
        error("XROOTD_TOKEN_AUTH_PARAMS['exportedVOs'] must be a list or nlist");
      };
    };
  };

  SELF;
};


###############################
# Define Xrootd options       #
###############################

'/software/components/xrootd/options' = {
  if ( is_defined(XROOTD_PARAMS) ) {
    foreach (k;v;XROOTD_PARAMS) {
      SELF[k] = v;
    };
  };

  if ( !is_defined(SELF['authzLibraries']) ) {
    SELF['authzLibraries'] = list(XROOTD_AUTH_LIBRARY_TOKEN_AUTH);
  };

  if ( !is_defined(SELF['daemonUser']) ) {
    error("XROOTD_PARAMS['daemonUser'] undefined: no default value");
  };
  if ( !is_defined(SELF['daemonGroup']) ) {
    error("XROOTD_PARAMS['daemonGroup'] undefined: no default value");
  };

  if ( XROOTD_AUTH_USE_TOKEN ) {
    foreach (k;v;XROOTD_TOKEN_AUTH_PARAMS) {
      if ( k != 'exportedVOs' ) {
        if ( (k == 'authorizedPaths') ||
             (k == 'mappedFQANs') ||
             (k == 'principal') ||
             (k == 'defaultPrefix') ||
             (k == 'replacementPrefix') ) {
          SELF['dpm'][k] = v;
        } else {
          SELF['tokenAuthz'][k] = v;
        };
      };
    };
    SELF['tokenAuthz']['authzConf'] = XROOTD_TOKEN_AUTHZ_CONF_FILE;
    if ( !is_defined(SELF['dpm']['authorizedPaths']) ) {
      error("XROOTD_TOKEN_AUTH_PARAMS['authorizedPaths'] undefined: no default");
    };
    if ( (length(XROOTD_TOKEN_AUTH_PARAMS['exportedVOs']) > 1) && !XROOTD_AUTH_TOKEN_MULTIPLE_VOS_ENABLED ) {
      error('Multiple VOs exported with token-based authz: to really allow it, define XROOTD_AUTH_TOKEN_MULTIPLE_VOS_ENABLED');
    } else {
      SELF['tokenAuthz']['exportedVOs'] = XROOTD_TOKEN_AUTH_PARAMS['exportedVOs'];
    };
  };
  SELF['installDir'] = XROOTD_INSTALL_ROOT;

  debug('/software/components/xrootd/options = '+to_string(SELF));
  SELF;
};


#############################
# Configure Xrootd services #
#############################

include { 'components/xrootd/config' };
'/software/components/xrootd/dependencies/pre' = push('filecopy','dirperm','dpmlfc');
'/software/components/xrootd/hosts' = {
  SELF[FULL_HOSTNAME] = nlist('roles', XROOTD_SERVER_ROLES);
  SELF;
};
'/software/components/xrootd/options' = {
  foreach (i;role;XROOTD_SERVER_ROLES) {
    foreach (instance;params;XROOTD_XROOTD_INSTANCES) {
      if ( params['type'] == role ) {
        SELF['xrootdInstances'][instance] = params;
      };
    };
  };
  SELF;
};


##########################
# Creating various files #
##########################

'/software/components/filecopy/dependencies/post' = push('xrootd');
'/software/components/dirperm/dependencies/post' = push('xrootd');
'/software/components/dirperm/dependencies/pre' = push('filecopy');
'/software/components/filecopy/services' = {
  if( index('disk',XROOTD_SERVER_ROLES) >= 0 ) {
    # Host cert readable by xrootd
    SELF[escape(XROOTD_HOST_CERT_DIR+'/dpmkey.pem')] = nlist('source', SITE_DEF_HOST_KEY,
                                                             'owner', DPM_USER+':'+DPM_GROUP,
                                                             'perms', '0400',
                                                            );
    
    SELF[escape(XROOTD_HOST_CERT_DIR+'/dpmcert.pem')] = nlist('source', SITE_DEF_HOST_CERT,
                                                              'owner', DPM_USER+':'+DPM_GROUP,
                                                              'perms', '0644',
                                                             );
    # Template configuration file for disk server
    if ( is_defined(XROOTD_DISK_CONFIG_NAME) ) {
      config_template_path = XROOTD_CONFIG_DIR + '/' + XROOTD_DISK_CONFIG_NAME + XROOTD_QUATTOR_TEMPL_EXT;
      config_file_path = XROOTD_CONFIG_DIR + '/' + XROOTD_DISK_CONFIG_NAME;
      config_template_src = 'glite/xrootd/templates/disk_config';
      src = create(config_template_src);
      SELF[escape(config_template_path)] = nlist('config', src['content'],
                                                 'owner', 'root:root',
                                                 'perms', '0644',
                                                 'restart', 'cp '+config_template_path+' '+config_file_path,
                                                );
    };
  };

  if( index('redir',XROOTD_SERVER_ROLES) >= 0 ) {
    # Template configuration file for local redirector
    if ( is_defined(XROOTD_REDIR_CONFIG_NAME) ) {
      config_template_path = XROOTD_CONFIG_DIR + '/' + XROOTD_REDIR_CONFIG_NAME + XROOTD_QUATTOR_TEMPL_EXT;
      config_file_path = XROOTD_CONFIG_DIR + '/' + XROOTD_REDIR_CONFIG_NAME;
      config_template_src = 'glite/xrootd/templates/redir_config';
      src = create(config_template_src);
      SELF[escape(config_template_path)] = nlist('config', src['content'],
                                                 'owner', 'root:root',
                                                 'perms', '0644',
                                                 'restart', 'cp '+config_template_path+' '+config_file_path,
                                                );
    };
  };

  SELF;
};

include { 'components/dirperm/config' };
'/software/components/dirperm/paths' = 
  push(nlist('path',XROOTD_INSTALL_LOG,
             'owner',DPM_USER+':'+DPM_GROUP,
             'perm','0755',
             'type','d'
       )
  );

'/software/components/dirperm/paths' = 
  push(nlist('path',XROOTD_SPOOL_DIR,
             'owner',DPM_USER+':'+DPM_GROUP,
             'perm','0755',
             'type','d'
       )
  );

'/software/components/dirperm/paths' = 
  push(nlist('path',XROOTD_HOST_CERT_DIR,
             'owner',DPM_USER+':'+DPM_GROUP,
             'perm','0750',
             'type','d'
       )
  );


# Enable xrootd service

include { 'components/chkconfig/config' };
'/software/components/chkconfig/dependencies/pre' = push('xrootd');
'/software/components/chkconfig/service' = {
  SELF[XROOTD_MAIN_SERVICE] = nlist('on', '345',
                                    'startstop', true
                                   );
  SELF;
};

# Configure Xrootd federation if enabled
variable XROOTD_FEDERATION_ENABLED = if ( is_defined(XROOTD_FEDERATION_LIST) &&
                                          (length(XROOTD_FEDERATION_LIST) > 0) &&
                                          (index('redir',XROOTD_SERVER_ROLES) >= 0) ) {
                                       true;
                                     } else {
                                       false;
                                     };
include { if ( XROOTD_FEDERATION_ENABLED ) 'glite/xrootd/config_federation' };

# Configure Xrootd monitoring.
# Must be done last.
include { 'glite/xrootd/monitoring' };

