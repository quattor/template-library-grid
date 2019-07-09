template features/arc-ce/rpms;

# NorduGrid
'/software/packages' = pkg_repl('nordugrid-arc-ldap-infosys', ARC_VERSION, 'noarch');
'/software/packages' = pkg_repl('nordugrid-arc-plugins-xrootd', ARC_VERSION, 'x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-plugins-needed', ARC_VERSION, 'x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-gridftpd', ARC_VERSION, 'x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-arex', ARC_VERSION, 'x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-plugins-globus', ARC_VERSION, 'x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-hed', ARC_VERSION, 'x86_64');
#'/software/packages' = pkg_repl('nordugrid-arc-python', ARC_VERSION, 'x86_64');
'/software/packages' = pkg_repl('python2-nordugrid-arc', ARC_VERSION, 'x86_64');
'/software/packages' = pkg_repl('nordugrid-arc', ARC_VERSION, 'x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-aris', ARC_VERSION, 'noarch');

# maybe to create an arc-giis feature ??
#'/software/packages' = if ( is_defined(IS_UK_GIIS) ) {
'/software/packages' = if ( IS_UK_GIIS ) {
    pkg_repl('nordugrid-arc-egiis', ARC_VERSION, 'x86_64');
    } else {
    return(SELF);
};


# GLOBUS
#'/software/packages' = pkg_repl('globus-callout', '2.4-2.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-common', '14.10-2.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-ftp-client', '7.6-1.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-ftp-control', '4.7-1.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gsi-callback', '4.6-2.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gsi-cert-utils', '8.6-2.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gsi-credential', '6.0-2.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gsi-openssl-error', '2.1-10.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gsi-proxy-core', '6.2-9.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gsi-proxy-ssl', '4.1-10.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gsi-sysconfig', '5.3-8.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gssapi-error', '4.1-10.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gssapi-gsi', '10.10-2.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-gss-assist', '9.0-1.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-io', '9.5-1.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-openssl-module', '3.3-2.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-xio', '3.6-2.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-xio-gsi-driver', '2.4-1.el6', 'x86_64');
#'/software/packages' = pkg_repl('globus-xio-popen-driver', '2.3-1.el6', 'x86_64');

'/software/packages' = pkg_repl('globus-callout');
'/software/packages' = pkg_repl('globus-common');
'/software/packages' = pkg_repl('globus-ftp-client');
'/software/packages' = pkg_repl('globus-ftp-control');
'/software/packages' = pkg_repl('globus-gsi-callback');
'/software/packages' = pkg_repl('globus-gsi-cert-utils');
'/software/packages' = pkg_repl('globus-gsi-credential');
'/software/packages' = pkg_repl('globus-gsi-openssl-error');
'/software/packages' = pkg_repl('globus-gsi-proxy-core');
'/software/packages' = pkg_repl('globus-gsi-proxy-ssl');
'/software/packages' = pkg_repl('globus-gsi-sysconfig');
'/software/packages' = pkg_repl('globus-gssapi-error');
'/software/packages' = pkg_repl('globus-gssapi-gsi');
'/software/packages' = pkg_repl('globus-gss-assist');
'/software/packages' = pkg_repl('globus-io');
'/software/packages' = pkg_repl('globus-openssl-module');
'/software/packages' = pkg_repl('globus-xio');
'/software/packages' = pkg_repl('globus-xio-gsi-driver');
'/software/packages' = pkg_repl('globus-xio-popen-driver');

# LCAS
'/software/packages' = pkg_repl('lcas');
'/software/packages' = pkg_repl('lcas-plugins-basic');
'/software/packages' = pkg_repl('lcas-plugins-voms');

# LCMAPS
'/software/packages' = pkg_repl('lcmaps');
'/software/packages' = pkg_repl('lcmaps-plugins-basic');
'/software/packages' = pkg_repl('lcmaps-plugins-c-pep');
'/software/packages' = pkg_repl('lcmaps-plugins-voms');
'/software/packages' = pkg_repl('lcmaps-plugins-verify-proxy');

# Dependencies
'/software/packages' = pkg_repl('bdii');
'/software/packages' = pkg_repl('lcgdm-libs');
'/software/packages' = pkg_repl('voms');
'/software/packages' = pkg_repl('glue-schema');
'/software/packages' = pkg_repl('argus-pep-api-c');
'/software/packages' = pkg_repl('python-zope-filesystem');
'/software/packages' = pkg_repl('gridsite-libs');
### ???
'/software/packages' = pkg_repl('lfc-libs');

# pepcli to test argus
'/software/packages' = pkg_repl('argus-pepcli');

# xrootd dependencies
'/software/packages' = pkg_repl('xrootd4-libs');
'/software/packages' = pkg_repl('xrootd4-client-libs');

# OSG lsc files
'/software/packages' = pkg_repl('tier1-osg-voms');

# Needed for JURA
'/software/packages' = pkg_repl('python-dirq');

# Needed for LHCb logs to S3 uploader
'/software/packages' = pkg_repl('python2-boto');
'/software/packages' = pkg_repl('python-pyasn1');
'/software/packages' = pkg_repl('python-setuptools');
'/software/packages' = pkg_repl('python2-rsa');


#'/software/packages' = pkg_repl('');
#'/software/packages' = pkg_repl('');
#'/software/packages' = pkg_repl('');
#'/software/packages' = pkg_repl('');
#'/software/packages' = pkg_repl('');
#'/software/packages' = pkg_repl('');
#'/software/packages' = pkg_repl('');


