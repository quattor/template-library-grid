unique template personality/se_dpm/rpms/xrootd;

'/software/packages' = pkg_repl('dpm-xrootd');
'/software/packages' = pkg_repl('dpm-xrootd-devel');

variable VOMS_XROOTD_EXTENSION_ENABLED ?= true;
'/software/packages' = {
    if (is_boolean(VOMS_XROOTD_EXTENSION_ENABLED) && VOMS_XROOTD_EXTENSION_ENABLED) {
        pkg_repl('vomsxrd');
    };
    SELF;
};
