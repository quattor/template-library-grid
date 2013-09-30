unique template glite/xrootd/rpms/x86_64/server;

include { 'glite/xrootd/rpms/x86_64/client' };

# Normally defined by client RPMs template
variable XROOTD_VERSION ?= error('XROOTD_VERSION undefined');

'/software/packages' = pkg_repl('xrootd', XROOTD_VERSION, PKG_ARCH_GLITE);
'/software/packages' = pkg_repl('xrootd-fuse', XROOTD_VERSION, PKG_ARCH_GLITE);
'/software/packages' = pkg_repl('xrootd-server-libs', XROOTD_VERSION, PKG_ARCH_GLITE);

#alice auth
'/software/packages' = {
    if ( XROOTD_AUTH_USE_TOKEN ) {
        pkg_repl('tokenauthz', '1.1.7-1', PKG_ARCH_GLITE);
        pkg_repl('tokenauthz-debuginfo', '1.1.7-1', PKG_ARCH_GLITE);
        pkg_repl('xrootd-alicetokenacc', '1.2.2-1', PKG_ARCH_GLITE);
    } else {
        SELF;
    };
};
