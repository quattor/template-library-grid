unique template glite/xrootd/rpms/x86_64/client;

variable XROOTD_VERSION ?= {
    if(OS_VERSION_PARAMS['major'] == 'sl5') {
        '3.3.2-1.el5';
    } else { 
        '3.3.2-1.el6';
    };
};

'/software/packages' = pkg_repl('xrootd-client', XROOTD_VERSION, PKG_ARCH_GLITE);
'/software/packages' = pkg_repl('xrootd-client-libs', XROOTD_VERSION, PKG_ARCH_GLITE);
'/software/packages' = pkg_repl('xrootd-devel', XROOTD_VERSION, PKG_ARCH_GLITE);
'/software/packages' = {
    if ( OS_VERSION_PARAMS['major'] == 'sl5' ) {
        pkg_repl('xrootd-doc', XROOTD_VERSION, PKG_ARCH_GLITE);
    } else {
        SELF;
    };
};
'/software/packages' = pkg_repl('xrootd-libs', XROOTD_VERSION, PKG_ARCH_GLITE);
