unique template personality/bdii/rpms/config;

'/software/packages' = {
    if (BDII_TYPE == 'site' || BDII_TYPE == 'combined') {
        if (! is_defined(SELF[escape('emi-bdii-site')])) {
            SELF[escape('emi-bdii-site')] = nlist();
        };
    };
    if (BDII_TYPE == 'top') {
        if (! is_defined(SELF[escape('emi-bdii-top')])) {
            SELF[escape('emi-bdii-top')] = nlist();
        };
    };
    SELF;
};
