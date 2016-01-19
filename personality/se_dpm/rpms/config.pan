unique template personality/se_dpm/rpms/config;

# As of Dec. 2015, it was decided that the metapackage will no longer be built
# 1.8.10 metapackage has been the last one. Live without it by default!
variable SEDPM_USE_METAPACKAGES ?= false;

variable DMLITE_MEMCACHE_ENABLED ?= false;

'/software/packages/' = {
  # Backward compatibility: keep metapackage in the config if SEDPM_USE_METAPACKAGES=true.
  # This is necessary to workaround a problem with YUM that uninstall all the RPMs required
  # by the metapackage when uninstalling the metapackage.
  # To switch from using the matapackage to not using it, be sure to remove the metapackage
  # manually BEFORE deploying the configuration change to workaround the YUM problem.
  if ( SEDPM_USE_METAPACKAGES ) {
    if ( SEDPM_IS_HEAD_NODE ) {
      pkg_repl('emi-dpm_mysql');
    } else {
      pkg_repl('emi-dpm_disk');
    };
  };

  # Always include the main packages required by the metapackage to
  # prevent YUM from removing these packages when the metapackage is removed.

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
    # memcache is useless on disk servers
    if ( DMLITE_MEMCACHE_ENABLED ) {
      pkg_repl('dmlite-plugins-memcache');
    };
  };

  SELF;
};

include if (XROOT_ENABLED) 'personality/se_dpm/rpms/xrootd';
include if (HTTPS_ENABLED) 'personality/se_dpm/rpms/dav';

include if (SEDPM_IS_HEAD_NODE && SEDPM_MONITORING_ENABLED) 'personality/se_dpm/rpms/monitoring';
