unique template glite/se_dpm/rpms/sl6/x86_64/head;

# Globus dependencies
"/software/packages"=pkg_repl("globus-authz","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-authz-callout-error","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-callout","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-common","14.7-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-ftp-client","7.4-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-ftp-control","4.4-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gass-copy","8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gass-transfer","7.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gfork","3.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gridftp-server","6.14-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gridftp-server-control","2.7-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gridftp-server-progs","6.14-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-callback","4.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-cert-utils","8.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-credential","5.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-openssl-error","2.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-core","6.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-ssl","4.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-sysconfig","5.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gss-assist","8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-error","4.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-gsi","7.8-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-io","9.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-libtool","1.2-4.el6","x86_64");
"/software/packages"=pkg_repl("globus-openssl","5.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-openssl-module","3.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-usage","3.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio","3.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio-gsi-driver","2.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio-pipe-driver","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio-popen-driver","2.3-1.el6","x86_64");

# Argus client
"/software/packages"=pkg_repl("argus-pep-api-c","2.1.0-3.sl6","x86_64");

# RPMS specific to this node type
# (be sure to define variables according to service node type to register the
# proper information into Information System)
variable SEDPM_FLAVOR_RPMS = if ( SEDPM_DB_TYPE == 'mysql' ) {
                               'glite/se_dpm/rpms/sl6/'+PKG_ARCH_GLITE+'/mysql';
                             } else {
                               'glite/se_dpm/rpms/sl6/'+PKG_ARCH_GLITE+'/oracle';
                             };
include { return(SEDPM_FLAVOR_RPMS) };

include { if ( XROOT_ENABLED ) 'glite/se_dpm/rpms/sl6/'+PKG_ARCH_GLITE+'/xrootd' };

# DPM monitoring if enabled
include { if ( SEDPM_MONITORING_ENABLED ) 'glite/se_dpm/rpms/sl6/'+PKG_ARCH_GLITE+'/monitoring' };

include { if (DPM_DAV_ENABLED) 'glite/se_dpm/rpms/sl6/'+PKG_ARCH_GLITE+'/dav' };

# Admin tools and their dependencies
"/software/packages"=pkg_repl("dpm-contrib-admintools","0.2.1-1.el6","x86_64");
"/software/packages"=pkg_repl("python-paramiko","1.7.5-2.1.el6","noarch");
"/software/packages"=pkg_repl("python-crypto","2.0.1-22.el6","x86_64");

