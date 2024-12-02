unique template personality/se_dpm/rpms/xrootd;

variable VOMS_XROOTD_EXTENSION_ENABLED ?= true;
'/software/packages' = {
    if (pkg_compare_version(DPM_VERSION, '1.11.0') == PKG_VERSION_LESS) {
        pkg_repl('dpm-xrootd');
        pkg_repl('dpm-xrootd-devel');
    } else {
        pkg_repl('dmlite-dpm-xrootd');
    };
    if (is_boolean(VOMS_XROOTD_EXTENSION_ENABLED) && VOMS_XROOTD_EXTENSION_ENABLED) {
        pkg_repl('vomsxrd');
    };
    SELF;
};
