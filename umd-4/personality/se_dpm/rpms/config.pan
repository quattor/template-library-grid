unique template personality/se_dpm/rpms/config;

variable DMLITE_MEMCACHE_ENABLED ?= false;

'/software/packages' = {
    # Always include the main packages required by the metapackage to
    # prevent YUM from removing these packages when the metapackage is removed.

    pkg_repl('dpm');
    pkg_repl('dpm-devel');
    pkg_repl('dpm-perl');
    pkg_repl('dpm-rfio-server');
    pkg_repl('dmlite-shell');
    pkg_repl('dmlite-plugins-adapter');
    pkg_repl('edg-mkgridmap');
    pkg_repl('finger');

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

    if ((is_defined(DOME_FLAVOUR) && DOME_FLAVOUR) || (is_defined(DOME_ENABLED) && DOME_ENABLED)) {
        if ( SEDPM_IS_HEAD_NODE ) {
            pkg_repl('dmlite-dpmhead');
        }else{
            pkg_repl('dmlite-dpmdisk');
        };
    };

    if (pkg_compare_version(DPM_VERSION, '1.12.0') == PKG_VERSION_LESS) {
        pkg_repl('dpm-python');
    } else {
        pkg_repl('python2-dpm');
    };

    if (pkg_compare_version(DPM_VERSION, '1.13.0') == PKG_VERSION_LESS) {
        pkg_repl('dpm-dsi');
    } else {
        pkg_repl('dmlite-dpm-dsi');
    };
    SELF;
};

include if (XROOT_ENABLED) 'personality/se_dpm/rpms/xrootd';
include if (HTTPS_ENABLED) 'personality/se_dpm/rpms/dav';

include if (SEDPM_IS_HEAD_NODE && SEDPM_MONITORING_ENABLED) 'personality/se_dpm/rpms/monitoring';

