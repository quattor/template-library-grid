unique template glite/se_dpm/rpms/sl6/x86_64/disk;

include { 'glite/se_dpm/variables' };

# RFIO server
'/software/packages' = pkg_repl("dpm-rfio-server",DPM_RFIO_VERSION,"x86_64");


# gridftp server
"/software/packages"=pkg_repl("globus-authz","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-authz-callout-error","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-callout","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-common","14.7-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-ftp-control","4.4-1.el6","x86_64");
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
"/software/packages"=pkg_repl("globus-gssapi-error","4.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-gsi","10.7-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gss-assist","8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-io","9.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-libtool","1.2-4.el6","x86_64");
"/software/packages"=pkg_repl("globus-openssl","5.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-openssl-module","3.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-usage","3.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio","3.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio-gsi-driver","2.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio-pipe-driver","2.2-1.el6","x86_64");

include { if ( XROOT_ENABLED ) 'glite/se_dpm/rpms/sl6/'+PKG_ARCH_GLITE+'/xrootd' };
include { if (DPM_DAV_ENABLED) 'glite/se_dpm/rpms/sl6/'+PKG_ARCH_GLITE+'/dav' };
