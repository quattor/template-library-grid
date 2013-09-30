unique template glite/xrootd/rpms/x86_64/client;

variable XROOTD_VERSION ?= {
    if (EMI_UPDATE_VERSION < '13') {
        this = '3.2.7-1';
    } else {
        this = '3.3.2-1';
    };
    if (match(OS_VERSION_PARAMS['major'], '[es]l6')) {
        this = this + '.el6';
    } else {
        this = this + '.el5';
    };
    this;
};

'/software/packages' = pkg_repl('xrootd-client', XROOTD_VERSION, PKG_ARCH_GLITE);
'/software/packages' = {
    if (EMI_UPDATE_VERSION < '13') {
        pkg_repl('xrootd-client-admin-java', XROOTD_VERSION, PKG_ARCH_GLITE);
    } else {
        pkg_repl('xrootd-client-libs', XROOTD_VERSION, PKG_ARCH_GLITE);
    };
};
'/software/packages' = pkg_repl('xrootd-devel', XROOTD_VERSION, PKG_ARCH_GLITE);
'/software/packages' = {
    if ( OS_VERSION_PARAMS['major'] == 'sl5' ) {
        pkg_repl('xrootd-doc', XROOTD_VERSION, PKG_ARCH_GLITE);
    } else {
        SELF;
    };
};
'/software/packages' = pkg_repl('xrootd-libs', XROOTD_VERSION, PKG_ARCH_GLITE);
