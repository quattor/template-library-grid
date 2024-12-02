unique template personality/xrootd/rpms/config;

include { 'personality/xrootd/rpms/client' };

'/software/packages/{xrootd}' ?= nlist();
'/software/packages/{xrootd-fuse}' ?= nlist();
'/software/packages/{xrootd-server-libs}' ?= nlist();

# ALICE auth
'/software/packages' = {
    if ( XROOTD_AUTH_USE_TOKEN ) {
        SELF[escape('tokenauthz')] = nlist();
        SELF[escape('tokenauthz-debuginfo')] = nlist();
        SELF[escape('xrootd-alicetokenacc')] = nlist();
    };
    SELF;
};
