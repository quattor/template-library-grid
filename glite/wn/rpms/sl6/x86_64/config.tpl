unique template glite/wn/rpms/sl6/x86_64/config;

#EMI WN
"/software/packages"=pkg_repl("emi-wn","2.0.0-1.sl6","x86_64");

"/software/packages"=pkg_repl("emi-version","2.0.0-1.sl6","x86_64");
"/software/packages"=pkg_repl("emi.amga.amga-cli","2.3.0-1.sl6","x86_64");

#SAGA STUFF
"/software/packages"=pkg_repl("emi.saga-adapter.context-cpp","1.0.2-3.sl6","x86_64");
"/software/packages"=pkg_repl("emi.saga-adapter.isn-common","1.0.1-3.sl6","noarch");
"/software/packages"=pkg_repl("emi.saga-adapter.sd-cpp","1.0.4-1.sl6","x86_64");
"/software/packages"=pkg_repl("emi.saga-adapter.isn-cpp","1.0.3-1.sl6","x86_64");
"/software/packages"=pkg_repl("SAGA.lsu-cpp.engine","1.6.0-1.sl6","x86_64");

#LCG UTILS
"/software/packages"=pkg_repl("lcg-util","1.13.9-0.el6","x86_64");
"/software/packages"=pkg_repl("lcg-util-libs","1.13.9-0.el6","x86_64");
"/software/packages"=pkg_repl("lcg-util-libs","1.13.9-0.el6","i386");
"/software/packages"=pkg_repl("lcg-util-python","1.13.9-0.el6","x86_64");
#NOTFOUND "/software/packages"=pkg_repl("lcg-util-python26","1.13.9-0.el6","x86_64"); #Andrea: indeed I do not see it in sl6
"/software/packages"=pkg_repl("lcg-info","1.12.2-1.el6","noarch");
"/software/packages"=pkg_repl("lcg-infosites","3.1.0-3.el6","noarch");
"/software/packages"=pkg_repl("lcg-ManageVOTag","4.0.0-1","noarch");
"/software/packages"=pkg_repl("lcg-tags","0.4.0-2","noarch");
"/software/packages"=pkg_repl("lcgdm-libs","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("lcgdm-libs","1.8.6-1.el6","i386");
"/software/packages"=pkg_repl("lcgdm-devel","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("lcgdm-devel","1.8.6-1.el6","i386");

#GRID STUFF
"/software/packages"=pkg_repl("a1_grid_env","3.0.2-1.sl6","x86_64");
"/software/packages"=pkg_repl("cleanup-grid-accounts","2.0.0-1","noarch");
"/software/packages"=pkg_repl("gridsite-libs","1.7.21-2.el6","x86_64");
"/software/packages"=pkg_repl("delegation-api-c","2.1.2-7.el6","x86_64");
"/software/packages"=pkg_repl("srm-ifce","1.12.3-1.el6","x86_64");
"/software/packages"=pkg_repl("srm-ifce","1.14.0-1.el6","i386");
"/software/packages"=pkg_repl("gridftp-ifce","2.1.4-2.el6","x86_64");
"/software/packages"=pkg_repl("gridftp-ifce","2.3.0-0.el6","i386");
"/software/packages"=pkg_repl("is-interface","1.12.2-2.el6","x86_64");
"/software/packages"=pkg_repl("is-interface","1.14.0-0.el6","i386");



#CGSI
"/software/packages"=pkg_repl("CGSI-gSOAP","1.3.5-2.el6","x86_64");
"/software/packages"=pkg_repl("CGSI-gSOAP","1.3.5-2.el6","i386");
"/software/packages"=pkg_repl("gsoap","2.7.16-4.el6","x86_64");
"/software/packages"=pkg_repl("gsoap","2.7.16-4.el6","i686");

#GFAL/DPM/LFC
"/software/packages"=pkg_repl("gfal","1.14.0-1.el6","x86_64");
"/software/packages"=pkg_repl("gfal","1.14.0-1.el6","i386");
"/software/packages"=pkg_repl("gfal-python","1.14.0-1.el6","x86_64");
#NOTFOUND "/software/packages"=pkg_repl("gfal-python26","1.13.19-0.el6","x86_64");  #Andrea: indeed I do not see it in sl6
"/software/packages"=pkg_repl("gfalFS","1.0.0-2beta1.el6","x86_64");

"/software/packages"=pkg_repl("gfal2","2.0.0-0.6.beta.el6","x86_64");
"/software/packages"=pkg_repl("gfal2-core","2.0.0-0.6.beta.el6","x86_64");
"/software/packages"=pkg_repl("gfal2-all","2.0.0-0.6.beta.el6","x86_64");
"/software/packages"=pkg_repl("gfal2-transfer","2.0.0-0.6.beta.el6","x86_64");
"/software/packages"=pkg_repl("gfal2-python","1.0.0-5beta1","x86_64");
"/software/packages"=pkg_repl("gfal2-plugin-dcap","2.0.0-0.6.beta.el6","x86_64");
"/software/packages"=pkg_repl("gfal2-plugin-gridftp","2.0.0-0.6.beta.el6","x86_64");
"/software/packages"=pkg_repl("gfal2-plugin-lfc","2.0.0-0.6.beta.el6","x86_64");
"/software/packages"=pkg_repl("gfal2-plugin-rfio","2.0.0-0.6.beta.el6","x86_64");
"/software/packages"=pkg_repl("gfal2-plugin-srm","2.0.0-0.6.beta.el6","x86_64");

"/software/packages"=pkg_repl("dpm","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dpm-devel","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dpm-perl","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dpm-python","1.8.6-1.el6","x86_64");
#NOTFOUND "/software/packages"=pkg_repl("dpm-python26","1.8.4-1.el6","x86_64");  #Andrea: indeed I do not see it in sl6
"/software/packages"=pkg_repl("dpm-libs","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dpm-libs","1.8.6-1.el6","i386");

"/software/packages"=pkg_repl("lfc","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("lfc-libs","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("lfc-libs","1.8.6-1.el6","i386");
"/software/packages"=pkg_repl("lfc-devel","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("lfc-perl","1.8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("lfc-python","1.8.6-1.el6","x86_64");
#NOTFOUND "/software/packages"=pkg_repl("lfc-python26","1.8.4-1.el6","x86_64");  #Andrea: indeed I do not see it in sl6

#DCACHE/DCAP
"/software/packages"=pkg_repl("dcache-srmclient","2.1.1-1.el6","x86_64");
"/software/packages"=pkg_repl("dcap","2.47.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dcap-libs","2.47.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dcap-libs","2.47.6-1.el6","i686");
"/software/packages"=pkg_repl("dcap-tunnel-telnet","2.47.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dcap-devel","2.47.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dcap-tunnel-ssl","2.47.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dcap-tunnel-krb","2.47.6-1.el6","x86_64");
"/software/packages"=pkg_repl("dcap-tunnel-gsi","2.47.6-1.el6","x86_64");

#VOMS
"/software/packages"=pkg_repl("voms","2.0.9-1.el6","x86_64");
#"/software/packages"=pkg_repl("vomsjapi","2.0.2-1.el6","x86_64");
"/software/packages"=pkg_repl("voms-clients","2.0.9-1.el6","x86_64");
"/software/packages"=pkg_repl("voms-devel","2.0.9-1.el6","x86_64");
"/software/packages"=pkg_repl("voms","2.0.9-1.el6","i386");

#PBS STUFF
"/software/packages"=pkg_repl("lcg-pbs-utils","2.0.0-1.sl6","x86_64");

#GLITE
"/software/packages"=pkg_repl("glite-lb-client","5.1.4-2.el6","x86_64");
"/software/packages"=pkg_repl("glite-lb-client-progs","5.1.4-2.el6","x86_64");
"/software/packages"=pkg_repl("glite-lb-common","8.1.3-3.el6","x86_64");
"/software/packages"=pkg_repl("glite-lbjp-common-gsoap-plugin","3.1.2-2.el6","x86_64");
"/software/packages"=pkg_repl("glite-lbjp-common-trio","2.2.2-3.el6","x86_64");
"/software/packages"=pkg_repl("glite-lbjp-common-gss","3.1.3-2.el6","x86_64");
"/software/packages"=pkg_repl("glite-wms-brokerinfo-access","3.4.0-4.sl6","x86_64");
"/software/packages"=pkg_repl("glite-wms-brokerinfo-access-lib","3.4.0-4.sl6","x86_64");
"/software/packages"=pkg_repl("glite-wms-utils-exception","3.3.0-2.sl6","x86_64");
"/software/packages"=pkg_repl("glite-yaim-clients","5.0.1-2.sl6","noarch");
"/software/packages"=pkg_repl("glite-yaim-core","5.1.0-1.sl6","noarch");
"/software/packages"=pkg_repl("glite-yaim-torque-client","5.1.0-1.sl6","noarch");
"/software/packages"=pkg_repl("glite-yaim-torque-utils","5.1.0-2.sl6","noarch");
"/software/packages"=pkg_repl("glite-jobid-api-c","2.1.2-2.el6","x86_64");
"/software/packages"=pkg_repl("glite-jobid-api-cpp-devel","1.2.0-7.el6","x86_64");

"/software/packages"=pkg_repl("glite-wn-info","1.0.3-2.sl6","noarch");
"/software/packages"=pkg_repl("glite-service-discovery-api-c","2.2.3-1.sl6","x86_64");


#MYPROXY
"/software/packages"=pkg_repl("myproxy","5.8-1.el6","x86_64");
"/software/packages"=pkg_repl("myproxy-libs","5.8-1.el6","x86_64");

#UBERFTP
"/software/packages"=pkg_repl("uberftp","2.6-4.el6","x86_64");

#GLOBUS i386 packages which are now i686
"/software/packages"=pkg_repl("globus-gridmap-callout-error","1.2-2.el6","i686");
"/software/packages"=pkg_repl("globus-gridftp-server","6.14-1.el6","i686");
"/software/packages"=pkg_repl("globus-authz","2.2-1.el6","i686");
"/software/packages"=pkg_repl("globus-authz","2.2-1.el6","i686");
"/software/packages"=pkg_repl("globus-gfork","3.2-1.el6","i686");
"/software/packages"=pkg_repl("globus-gridftp-server-control","2.7-1.el6","i686");
"/software/packages"=pkg_repl("globus-authz-callout-error","2.2-1.el6","i686");
"/software/packages"=pkg_repl("globus-usage","3.1-2.el6","i686");
"/software/packages"=pkg_repl("globus-common","14.7-1.el6","i686");
"/software/packages"=pkg_repl("globus-ftp-client","7.4-1.el6","i686");
"/software/packages"=pkg_repl("globus-gass-copy","8.6-1.el6","i686");
"/software/packages"=pkg_repl("globus-gass-transfer","7.2-1.el6","i686");
"/software/packages"=pkg_repl("globus-gsi-sysconfig","5.3-1.el6","i686");
"/software/packages"=pkg_repl("globus-gssapi-error","4.1-2.el6","i686");
"/software/packages"=pkg_repl("globus-gssapi-gsi","10.7-1.el6","i686");
"/software/packages"=pkg_repl("globus-io","9.3-1.el6","i686");
"/software/packages"=pkg_repl("globus-xio-popen-driver","2.3-1.el6","i686");
"/software/packages"=pkg_repl("globus-ftp-control","4.4-1.el6","i686");
"/software/packages"=pkg_repl("globus-gsi-callback","4.3-1.el6","i686");
"/software/packages"=pkg_repl("globus-gsi-cert-utils","8.3-1.el6","i686");
"/software/packages"=pkg_repl("globus-gsi-credential","5.3-1.el6","i686");
"/software/packages"=pkg_repl("globus-gsi-openssl-error","2.1-2.el6","i686");
"/software/packages"=pkg_repl("globus-gsi-proxy-core","6.2-1.el6","i686");
"/software/packages"=pkg_repl("globus-gss-assist","8.6-1.el6","i686");
"/software/packages"=pkg_repl("globus-openssl-module","3.2-1.el6","i686");
"/software/packages"=pkg_repl("globus-xio","3.3-1.el6","i686");
"/software/packages"=pkg_repl("globus-xio-gsi-driver","2.3-1.el6","i686");
"/software/packages"=pkg_repl("globus-callout","2.2-1.el6","i686");
"/software/packages"=pkg_repl("globus-gsi-proxy-ssl","4.1-2.el6","i686");


"/software/packages"=pkg_repl("globus-proxy-utils","5.0-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-gridftp-server-progs","6.14-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gridmap-callout-error","1.2-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-openssl","5.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-libtool","1.2-4.el6","x86_64");
"/software/packages"=pkg_repl("globus-gridftp-server","6.14-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-authz","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-authz","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gfork","3.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gridftp-server-control","2.7-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-authz-callout-error","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-usage","3.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-gass-copy-progs","8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-common","14.7-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-ftp-client","7.4-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gass-copy","8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gass-transfer","7.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-sysconfig","5.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-error","4.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-gsi","10.7-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-io","9.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio-popen-driver","2.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-ftp-control","4.4-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-callback","4.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-cert-utils","8.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-credential","5.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-openssl-error","2.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-core","6.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gss-assist","8.6-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-openssl-module","3.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio","3.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio-gsi-driver","2.3-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-callout","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-ssl","4.1-2.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio-pipe-driver","2.2-1.el6","x86_64");
"/software/packages"=pkg_repl("globus-xio-pipe-driver","2.2-1.el6","i686");

#TORQUE
#"/software/packages"=pkg_repl("torque","2.5.7-7.el6","x86_64");
#"/software/packages"=pkg_repl("torque-client","2.5.7-7.el6","x86_64");
#"/software/packages"=pkg_repl("torque-mom","2.5.7-7.el6","x86_64");
#"/software/packages"=pkg_repl("libtorque","2.5.7-7.el6","x86_64");

#TRANSFER
"/software/packages"=pkg_repl("transfer-interface","3.7.2-1.el6","noarch");
#"/software/packages"=pkg_repl("transfer-cli","4.0.3-1.el6","x86_64"); #ANDREA: depends on gridsite-shared which is not available

#MUNGE
"/software/packages"=pkg_repl("munge","0.5.10-1.el6","x86_64");
"/software/packages"=pkg_repl("munge-libs","0.5.10-1.el6","x86_64");



#OTHERS (TO_BE_FIXED: some are to be doublechecked strange)
"/software/packages"=pkg_repl("c-ares","1.7.0-5.el6","x86_64");
#"/software/packages"=pkg_repl("util-c","1.3.2-1_HEAD.el6","x86_64"); #ANDREA: depends on gridsite-shared which is not available
"/software/packages"=pkg_repl("bouncycastle","1.46-1.el6","noarch");
"/software/packages"=pkg_repl("classads","1.0.8-1.el6","x86_64");
"/software/packages"=pkg_repl("xerces-c","3.0.1-0.20.1.el6","x86_64");
"/software/packages"=pkg_repl("editline","2.9-1.sl6","x86_64");
"/software/packages"=pkg_repl("java-1.6.0-openjdk","1.6.0.0-1.48.1.11.3.el6_2","x86_64");
#NOTFOUND "/software/packages"=pkg_repl("java-1.4.2-gcj-compat","1.4.2.0-40jpp.115","x86_64"); #Andrea: indeed I do not see it in sl6
#NOTFOUND "/software/packages"=pkg_repl("gjdoc","0.7.7-12.el6","x86_64");                      #
"/software/packages"=pkg_repl("glib2-devel","2.22.5-7.el6","x86_64");
"/software/packages"=pkg_repl("jakarta-commons-cli","1.1-5.el6","x86_64");
"/software/packages"=pkg_repl("jakarta-commons-lang","2.4-1.1.el6","noarch");
"/software/packages"=pkg_repl("jakarta-commons-logging","1.0.4-10.el6","noarch");
"/software/packages"=pkg_repl("log4j","1.2.14-6.4.el6","x86_64");
"/software/packages"=pkg_repl("openssl-devel","1.0.0-20.el6_2.5","x86_64");
"/software/packages"=pkg_repl("antlr","2.7.7-6.5.el6","x86_64");
"/software/packages"=pkg_repl("krb5-devel","1.9-33.el6","x86_64");
"/software/packages"=pkg_repl("e2fsprogs-devel","1.41.12-12.el6","x86_64");
"/software/packages"=pkg_repl("keyutils-libs-devel","1.4-4.el6","x86_64");
"/software/packages"=pkg_repl("libselinux-devel","2.0.94-5.3.el6","x86_64");
"/software/packages"=pkg_repl("libsepol-devel","2.0.41-4.el6","x86_64");
"/software/packages"=pkg_repl("java-1.5.0-gcj-devel",     "1.5.0.0-29.1.el6","x86_64");
"/software/packages"=pkg_repl("libgcj-src","4.4.6-4.el6","x86_64");
"/software/packages"=pkg_repl("redhat-lsb","4.0-3.el6","x86_64");
"/software/packages"=pkg_repl("redhat-lsb-graphics","4.0-3.el6","x86_64");
"/software/packages"=pkg_repl("redhat-lsb-printing","4.0-3.el6","x86_64");

