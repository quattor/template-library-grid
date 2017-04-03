unique template personality/se_dpm/rpms/xrootd;

variable VOMS_XROOTD_EXTENSION_ENABLED ?= true;
'/software/packages' = {
     pkg_repl('dpm-xrootd');
     pkg_repl('dpm-xrootd-devel');
    if (is_boolean(VOMS_XROOTD_EXTENSION_ENABLED) && VOMS_XROOTD_EXTENSION_ENABLED) {
        pkg_repl('vomsxrd');
    };
    SELF;
};
