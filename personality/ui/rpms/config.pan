unique template personality/ui/rpms/config;

# EMI UI
"/software/packages/{emi-ui}" ?= nlist();

# HEP dependencies
variable HEP_OSLIBS ?= true;
"/software/packages" = {
    if (is_boolean(HEP_OSLIBS) && HEP_OSLIBS) {
        if (OS_VERSION_PARAMS['major'] == 'sl5') {
            SELF[escape('HEP_OSlibs_SL5')] = nlist();
        } else {
            SELF[escape('HEP_OSlibs_SL6')] = nlist();
        };
    };
    SELF;
};
