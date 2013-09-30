unique template update/15/rpms_epel_sl5_x86_64-fix;

'/software/packages' = {
    pkg_ronly('globus-authz', '2.2-1.el5', 'x86_64');
    pkg_ronly('globus-authz-callout-error', '2.2-1.el5', 'x86_64');
    pkg_ronly('globus-callout', '2.2-1.el5', 'x86_64');
    pkg_ronly('globus-ftp-control', '4.4-1.el5', 'x86_64');
    pkg_ronly('globus-gfork', '3.2-1.el5', 'x86_64');
    pkg_ronly('globus-gsi-cert-utils', '8.3-1.el5', 'x86_64');
    pkg_ronly('globus-gsi-credential', '5.3-1.el5', 'x86_64');
    pkg_ronly('globus-gsi-openssl-error', '2.1-2.el5', 'x86_64');
    pkg_ronly('globus-gsi-proxy-core', '6.2-1.el5', 'x86_64');
    pkg_ronly('globus-gsi-proxy-ssl', '4.1-2.el5', 'x86_64');
    pkg_ronly('globus-gsi-sysconfig', '5.3-1.el5', 'x86_64');
    pkg_ronly('globus-gssapi-error', '4.1-2.el5', 'x86_64');
    pkg_ronly('globus-gssapi-gsi', '10.2-2.el5', 'i386');
    pkg_ronly('globus-gssapi-gsi', '10.2-2.el5', 'x86_64');
    pkg_ronly('globus-gss-assist', '8.6-1.el5', 'x86_64');
    pkg_ronly('globus-io', '9.3-1.el5', 'x86_64');
    pkg_ronly('globus-openssl-module', '3.2-1.el5', 'x86_64');
    pkg_ronly('globus-usage', '3.1-2.el5', 'x86_64');
    pkg_ronly('globus-xio', '3.3-1.el5', 'x86_64');
    pkg_ronly('globus-xio-gsi-driver', '2.3-1.el5', 'x86_64');
    pkg_ronly('globus-xio-pipe-driver', '2.2-1.el5', 'x86_64');
};

variable XROOTD_VERSION ?= '3.3.2-1.el5';
'/software/packages' = {
    pkg_ronly('xrootd', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-client', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-client-admin-java', '3.0.5-1.el5', 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-client-admin-perl', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-client-devel', XROOTD_VERSION, 'i386', '', '', 'epel');
    pkg_ronly('xrootd-client-devel', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-client-libs', XROOTD_VERSION, 'i386', '', '', 'epel');
    pkg_ronly('xrootd-client-libs', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-devel', XROOTD_VERSION, 'i386', '', '', 'epel');
    pkg_ronly('xrootd-devel', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-doc', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-fuse', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-libs', XROOTD_VERSION, 'i386', '', '', 'epel');
    pkg_ronly('xrootd-libs', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-private-devel', XROOTD_VERSION, 'i386', '', '', 'epel');
    pkg_ronly('xrootd-private-devel', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-server-devel', XROOTD_VERSION, 'i386', '', '', 'epel');
    pkg_ronly('xrootd-server-devel', XROOTD_VERSION, 'x86_64', '', '', 'epel');
    pkg_ronly('xrootd-server-libs', XROOTD_VERSION, 'i386', '', '', 'epel');
    pkg_ronly('xrootd-server-libs', XROOTD_VERSION, 'x86_64', '', '', 'epel');
};

##############################
# DMLite need boost141-regex #
##############################
'/software/packages' = if ( exists(SELF[escape('dmlite-libs')]) ) {
    pkg_repl('boost141-regex', '1.41.0-2.el5', 'x86_64');
} else {
    SELF;
};
