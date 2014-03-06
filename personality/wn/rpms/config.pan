unique template personality/wn/rpms/config;

# EMI WN
"/software/packages/{emi-wn}" ?= nlist();

# HEP dependencies
variable HEP_OSLIBS ?= true;
"/software/packages" = {
    if (is_boolean(HEP_OSLIBS) && HEP_OSLIBS) {
        SELF[escape('HEP_OSlibs_SL6')] = nlist();
    };
    SELF;
};
