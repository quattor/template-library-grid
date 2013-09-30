unique template update/09/rpms_epel_sl5_x86_64-fix;

'/software/packages' = {
    pkg_ronly('globus-authz', '2.2-1.el5', 'x86_64');
    pkg_ronly('globus-ftp-control', '4.4-1.el5', 'x86_64');
    pkg_ronly('globus-gfork', '3.2-1.el5', 'x86_64');
    pkg_ronly('globus-usage', '3.1-2.el5', 'x86_64');
    pkg_ronly('globus-xio', '3.3-1.el5', 'x86_64');
    pkg_ronly('globus-xio-gsi-driver', '2.3-1.el5', 'x86_64');
    pkg_ronly('globus-xio-pipe-driver', '2.2-1.el5', 'x86_64');
    pkg_ronly('globus-gsi-cert-utils', '8.3-1.el5', 'x86_64');
    pkg_ronly('globus-gsi-openssl-error', '2.1-2.el5', 'x86_64');
    pkg_ronly('globus-gsi-proxy-ssl', '4.1-2.el5', 'x86_64');
    pkg_ronly('globus-gsi-sysconfig', '5.3-1.el5', 'x86_64');
    pkg_ronly('globus-authz-callout-error', '2.2-1.el5', 'x86_64');
    pkg_ronly('globus-callout', '2.2-1.el5', 'x86_64');
    pkg_ronly('globus-gssapi-gsi', '10.2-2.el5', 'x86_64');
    pkg_ronly('globus-gss-assist', '8.6-1.el5', 'x86_64');
    pkg_ronly('globus-gssapi-error', '4.1-2.el5', 'x86_64');
    pkg_ronly('globus-io', '9.3-1.el5', 'x86_64');
    pkg_ronly('globus-openssl-module', '3.2-1.el5', 'x86_64');
    pkg_ronly('globus-gsi-credential', '5.3-1.el5', 'x86_64');
    pkg_ronly('globus-gsi-proxy-core', '6.2-1.el5', 'x86_64');
};

##############################
# DMLite need boost141-regex #
##############################
'/software/packages' = if ( exists(SELF[escape('dmlite-libs')]) ) {
    pkg_repl('boost141-regex', '1.41.0-2.el5', 'x86_64');
} else {
    SELF;
};
