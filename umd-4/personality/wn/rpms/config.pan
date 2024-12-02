unique template personality/wn/rpms/config;

# Atlas Worker Node metapackage
variable ATLAS_SUPPORT ?= true;

# Packages
"/software/packages" = {
    SELF['{wn}'] = dict();

    if ( ATLAS_SUPPORT ) {
        SELF[{'xrootd-client'}]    = dict();
        SELF[{'ganglia-gmond'}]    = dict();
        SELF[{'condor'}]           = dict();
    };
    SELF;
};

