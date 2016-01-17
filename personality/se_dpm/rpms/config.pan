unique template personality/se_dpm/rpms/config;

# Metapackages cannot be used with EPEL testing (requirements with strict versions)
variable SEDPM_USE_METAPACKAGES ?= if ( is_defined(REPOSITORY_EPEL_TESTING_ENABLED) && REPOSITORY_EPEL_TESTING_ENABLED ) {
                                     false;
                                   } else {
                                     true;
                                   };
variable DMLITE_MEMCACHE_ENABLED ?= false;

'/software/packages/' = {
  if ( SEDPM_USE_METAPACKAGES ) {
    if ( SEDPM_IS_HEAD_NODE ) {
      pkg_repl('emi-dpm_mysql');
      pkg_repl('argus-pep-api-c');
      pkg_repl('dpm-contrib-admintools');
    } else {
      pkg_repl('emi-dpm_disk');
    };

  } else {
    # This section explicitly includes in the configuration
    # everything required by the DPM metapackage. It is mainly used
    # to allow testing of new version of DPM, as the metapackage has
    # requirement for explicit versions.

    pkg_repl('dpm');
    pkg_repl('dpm-devel');
    pkg_repl('dpm-dsi');
    pkg_repl('dpm-perl');
    pkg_repl('dpm-python');
    pkg_repl('dpm-rfio-server');
    pkg_repl('dpm-yaim');
    pkg_repl('dmlite-plugins-adapter');
    pkg_repl('edg-mkgridmap');
    pkg_repl('emi-version');
    pkg_repl('finger');
    pkg_repl('lcgdm-dav');
    pkg_repl('lcgdm-dav-server');
    pkg_repl('lcg-expiregridmapdir');
  
    if ( SEDPM_IS_HEAD_NODE ) {
      pkg_repl('bdii');
      pkg_repl('dpm-copy-server-mysql');
      pkg_repl('dpm-name-server-mysql');
      pkg_repl('dpm-server-mysql');
      pkg_repl('dpm-srm-server-mysql');
      pkg_repl('dmlite-plugins-mysql');
      pkg_repl('glite-info-provider-service');
      pkg_repl('dpm-contrib-admintools');
      pkg_repl('argus-pep-api-c');
    };

    if ( DMLITE_MEMCACHE_ENABLED ) {
      pkg_repl('dmlite-plugins-memcache');
    };

  };

  SELF;
};

include if (XROOT_ENABLED) 'personality/se_dpm/rpms/xrootd';
include if (HTTPS_ENABLED) 'personality/se_dpm/rpms/dav';

include if (SEDPM_IS_HEAD_NODE && SEDPM_MONITORING_ENABLED) 'personality/se_dpm/rpms/monitoring';
