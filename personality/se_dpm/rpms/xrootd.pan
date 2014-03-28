unique template personality/se_dpm/rpms/xrootd;

'/software/packages/{dpm-xrootd}' ?= nlist();
'/software/packages/{dpm-xrootd-devel}' ?= nlist();

variable VOMS_XROOTD_EXTENSION_ENABLED ?= true;
'/software/packages' = {
    if (is_boolean(VOMS_XROOTD_EXTENSION_ENABLED) && VOMS_XROOTD_EXTENSION_ENABLED) {
        SELF[escape('vomsxrd')] = nlist();
    };
    SELF;
};
