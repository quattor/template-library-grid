# RPMs common to all flavor of LFC

unique template glite/lfc/rpms/x86_64/base;

# Add OS RPMs specific to LFC
include { 'config/emi/'+EMI_VERSION+'/dpmlfc-common' };

'/software/packages' = pkg_repl('lfc-devel',"1.8.3.1-1.el5",'x86_64');
'/software/packages' = pkg_repl('lfc-libs',"1.8.3.1-1.el5",'x86_64');
'/software/packages' = pkg_repl('dpm-libs',"1.8.3.1-1.el5",'x86_64');
'/software/packages' = pkg_repl('lfc-perl',"1.8.3.1-1.el5",'x86_64');
'/software/packages' = pkg_repl('lfc-python',"1.8.3.1-1.el5",'x86_64');
'/software/packages' = pkg_repl("lfc-yaim","4.2.4-1.el5","noarch");
'/software/packages' = pkg_repl('lcgdm-libs',"1.8.3.1-1.el5",'x86_64');
'/software/packages' = pkg_repl('lcgdm-devel',"1.8.3.1-1.el5",'x86_64');
'/software/packages' = pkg_repl("lcgdm-dav","0.8.0-1.el5","x86_64");
'/software/packages' = pkg_repl("lcgdm-dav-libs","0.8.0-1.el5","x86_64");
'/software/packages' = pkg_repl("lcgdm-dav-server","0.8.0-1.el5","x86_64");
'/software/packages' = pkg_repl('lfc',"1.8.3.1-1.el5",'x86_64');
'/software/packages' = pkg_repl("lfc-dli","1.8.3.1-1.el5","x86_64");
#'/software/packages' = pkg_repl('CGSI_gSOAP_2.7', '1.23.2-2.sl5', PKG_ARCH_GLITE);     #ANDREA: I cannot find these packages in emi-2 and epel
#'/software/packages' = pkg_repl('CGSI_gSOAP_2.7-voms', '1.23.2-2.sl5', PKG_ARCH_GLITE);
'/software/packages' = pkg_repl('edg-mkgridmap', '3.0.0-1', 'noarch');
#'/software/packages' = pkg_repl('glite-info-generic', '2.0.2-3', 'noarch');            #ANDREA: not found
'/software/packages' = pkg_repl("glite-info-templates","1.0.0-12","noarch");
#'/software/packages' = pkg_repl('glite-security-voms-api', '1.8.9-2.sl5', PKG_ARCH_GLITE);    #ANDREA: not found
#'/software/packages' = pkg_repl('glite-security-voms-api-c', '1.8.9-2.sl5', PKG_ARCH_GLITE);
#'/software/packages' = pkg_repl('glite-security-voms-api-cpp','1.8.12-1.sl5',PKG_ARCH_GLITE);
'/software/packages' = pkg_repl('emi-version',"2.3.0-1.sl5","x86_64");
'/software/packages' = pkg_repl("glite-yaim-core","5.1.0-1.sl5","noarch");

'/software/packages' = pkg_repl("gridsite-libs","1.7.21-4.el5","x86_64");
'/software/packages' = pkg_repl("gridsite","1.7.21-4.el5","x86_64");
'/software/packages' =  pkg_repl("gsoap","2.7.13-3.el5","x86_64");
'/software/packages' =  pkg_repl("voms","2.0.8-1.el5","x86_64");
'/software/packages' =  pkg_repl("json-c","0.9-1.el5","x86_64");

# Globus dependencies
"/software/packages"=pkg_repl("globus-authz","0.7-4.el5","x86_64");
"/software/packages"=pkg_repl("globus-authz-callout-error","0.5-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-callout","0.7-8.el5","x86_64");
"/software/packages"=pkg_repl("globus-common","14.7-1.el5","x86_64");
#"/software/packages"=pkg_repl("globus-ftp-client","6.0-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-ftp-control","2.11-3.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gass-copy","5.10-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gass-transfer","4.3-3.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gfork","0.2-6.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gridftp-server","3.28-3.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gridftp-server-control","0.45-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gridftp-server-progs","3.28-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-callback","2.8-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-cert-utils","6.7-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-credential","3.5-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-openssl-error","0.14-8.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-core","4.7-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-ssl","2.3-3.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-sysconfig","3.1-4.el5","x86_64");
"/software/packages"=pkg_repl("globus-gss-assist","5.9-4.el5","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-error","2.5-7.el5","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-gsi","7.6-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-io","6.3-6.el5","x86_64");
"/software/packages"=pkg_repl("globus-libtool","1.2-4.el5","x86_64");
"/software/packages"=pkg_repl("globus-openssl","5.1-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-openssl-module","1.3-3.el5","x86_64");
#"/software/packages"=pkg_repl("globus-usage","1.4-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-xio","2.8-4.el5","x86_64");
#"/software/packages"=pkg_repl("globus-xio-gsi-driver","0.6-7.el5","x86_64");
#"/software/packages"=pkg_repl("globus-xio-pipe-driver","0.1-3.el5","x86_64");
#"/software/packages"=pkg_repl("globus-xio-popen-driver","0.9-3.el5","x86_64");



# Not an official dependency but required by ncm-globuscfg
##'/software/packages' = pkg_repl('gpt', '3.2autotools2004_NMI_9.0_x86_64_rhap_5-1', PKG_ARCH_GLITE); #ANDREA: not found


'/software/packages'= {
  if ( EMI_UPDATE_VERSION >= '08' ) {
    # Some RPMs need to be deleted
    pkg_del('gridsite-apache');

    # Some RPMs need to be installed
    pkg_repl('dmlite-libs',  '0.4.2-1.el5','x86_64');
    pkg_repl('dmlite-plugins-adapter','0.4.0-1.el5','x86_64');
    pkg_repl('dmlite-plugins-mysql','0.4.1-1.el5','x86_64');
    pkg_repl('gridsite',     '1.7.25-1.emi2.el5','x86_64');
    pkg_repl('gridsite-libs','1.7.25-1.emi2.el5','x86_64');
  };
  SELF;
};

