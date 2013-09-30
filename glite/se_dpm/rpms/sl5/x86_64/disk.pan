unique template glite/se_dpm/rpms/sl5/x86_64/disk;

include { 'glite/se_dpm/variables' };

# RFIO server
'/software/packages' = pkg_repl("dpm-rfio-server",DPM_RFIO_VERSION,"x86_64");


# gridftp server
"/software/packages"=pkg_repl("globus-authz","0.7-4.el5","x86_64");
"/software/packages"=pkg_repl("globus-authz-callout-error","0.5-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-callout","0.7-8.el5","x86_64");
"/software/packages"=pkg_repl("globus-common","14.7-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-ftp-control","2.11-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-gfork","0.2-6.el5","x86_64");
"/software/packages"=pkg_repl('globus-gridftp-server','3.28-3.el5',PKG_ARCH_GLITE);
"/software/packages"=pkg_repl("globus-gridftp-server-control","0.45-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gridftp-server-progs","3.28-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-callback","2.8-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-cert-utils","6.7-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-credential","3.5-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-openssl-error","0.14-8.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-core","4.7-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-ssl","2.3-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-sysconfig","3.1-4.el5","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-error","2.5-7.el5","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-gsi","7.6-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gss-assist","5.9-4.el5","x86_64");
"/software/packages"=pkg_repl("globus-io","6.3-6.el5","x86_64");
"/software/packages"=pkg_repl("globus-libtool","1.2-4.el5","x86_64");
"/software/packages"=pkg_repl("globus-openssl","5.1-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-openssl-module","1.3-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-usage","1.4-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-xio","2.8-4.el5","x86_64");
"/software/packages"=pkg_repl('globus-xio-gsi-driver','0.6-7.el5',PKG_ARCH_GLITE);
"/software/packages"=pkg_repl("globus-xio-pipe-driver","0.1-3.el5","x86_64");

include { if ( XROOT_ENABLED ) 'glite/se_dpm/rpms/sl5/'+PKG_ARCH_GLITE+'/xrootd' };
include { if (DPM_DAV_ENABLED) 'glite/se_dpm/rpms/sl5/'+PKG_ARCH_GLITE+'/dav' };
