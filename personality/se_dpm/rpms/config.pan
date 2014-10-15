unique template personality/se_dpm/rpms/config;

# Metapackages cannot be used with EPEL testing (requirements with strict versions)
variable SEDPM_USE_METAPACKAGES ?= if ( is_defined(REPOSITORY_EPEL_TESTING_ENABLED) && REPOSITORY_EPEL_TESTING_ENABLED ) {
                                     false;
                                   } else {
                                     true;
                                   };

'/software/packages/' = {
  if ( SEDPM_USE_METAPACKAGES ) {
    if ( SEDPM_IS_HEAD_NODE ) {
      SELF[escape('emi-dpm_mysql')] = nlist();
      SELF[escape('argus-pep-api-c')] = nlist();
      SELF[escape('dpm-contrib-admintools')] = nlist();
    } else {
      SELF[escape('emi-dpm_disk')] = nlist();
    };

  } else {
    # This section explicitly includes in the configuration
    # everything required by the DPM metapackage. It is mainly used
    # to allow testing of new version of DPM, as the metapackage has
    # requirement for explicit versions.

    SELF[escape('dpm')] = nlist();
    SELF[escape('dpm-devel')] = nlist();
    SELF[escape('dpm-dsi')] = nlist();
    SELF[escape('dpm-perl')] = nlist();
    SELF[escape('dpm-python')] = nlist();
    SELF[escape('dpm-rfio-server')] = nlist();
    SELF[escape('dpm-yaim')] = nlist();
    SELF[escape('dmlite-plugins-adapter')] = nlist();
    SELF[escape('edg-mkgridmap')] = nlist();
    SELF[escape('emi-version')] = nlist();
    SELF[escape('fetch-crl')] = nlist();
    SELF[escape('finger')] = nlist();
    SELF[escape('lcgdm-dav')] = nlist();
    SELF[escape('lcgdm-dav-server')] = nlist();
    SELF[escape('lcg-expiregridmapdir')] = nlist();
  
    if ( SEDPM_IS_HEAD_NODE ) {
      SELF[escape('bdii')] = nlist();
      SELF[escape('dpm-copy-server-mysql')] = nlist();
      SELF[escape('dpm-name-server-mysql')] = nlist();
      SELF[escape('dpm-server-mysql')] = nlist();
      SELF[escape('dpm-srm-server-mysql')] = nlist();
      SELF[escape('dmlite-plugins-mysql')] = nlist();
      SELF[escape('glite-info-provider-service')] = nlist();
    };

  };

  SELF;
};

include { if (XROOT_ENABLED) 'personality/se_dpm/rpms/xrootd' };
include { if (HTTPS_ENABLED) 'personality/se_dpm/rpms/dav' };

include { if (SEDPM_IS_HEAD_NODE && SEDPM_MONITORING_ENABLED) 'personality/se_dpm/rpms/monitoring' };
