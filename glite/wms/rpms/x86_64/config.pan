unique template glite/wms/rpms/x86_64/config;

# Add required RPMs provided by the OS
include { "config/emi/" + EMI_VERSION + "/wms" };

# EMI
'/software/packages'=pkg_repl('activemq-cpp-library','3.2.5-1.sl5','x86_64');
'/software/packages'=pkg_repl('condor-emi','7.8.0-2','x86_64');
'/software/packages'=pkg_repl('emi-lb','1.0.2-2.el5','x86_64');
'/software/packages'=pkg_repl('emi-trustmanager','3.1.4-1.sl5','noarch');
'/software/packages'=pkg_repl('emi-trustmanager-axis','2.0.2-1.sl5','noarch');
'/software/packages'=pkg_repl('emi-version','3.0.0-1.sl5','x86_64');
'/software/packages'=pkg_repl('emi-wms','1.0.2-5.sl5','x86_64');
#'/software/packages'=pkg_repl('kill-stale-ftp','1.0.1-1.sl5','noarch');

# GLITE
'/software/packages'=pkg_repl('glite-ce-cream-client-api-c','1.15.1-2.sl5','x86_64');
'/software/packages'=pkg_repl('glite-info-provider-service','1.12.0-1.el5','noarch');
'/software/packages'=pkg_repl('glite-initscript-globus-gridftp','1.0.4-1.sl5','noarch');
'/software/packages'=pkg_repl('glite-jdl-api-cpp','3.4.1-2.sl5','x86_64');
'/software/packages'=pkg_repl('glite-jobid-api-c','2.2.7-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-jobid-api-java','1.3.4-1.el5','noarch');
'/software/packages'=pkg_repl('glite-lb-client','6.0.5-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-client-java','2.0.2-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-client-progs','6.0.5-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-common','9.0.5-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-doc','1.4.11-1.el5','noarch');
'/software/packages'=pkg_repl('glite-lb-harvester','1.3.8-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-db','3.2.6-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-gsoap-plugin','3.2.7-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-gss','3.2.11-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-jp-interface','2.3.6-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-log','1.3.6-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-maildir','2.3.6-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-server-bones','2.3.6-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-trio','2.3.8-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-logger','2.4.15-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-logger-msg','1.2.8-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-server','3.0.7-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-state-machine','2.0.4-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-utils','2.3.6-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-ws-interface','4.0.4-1.el5','noarch');
'/software/packages'=pkg_repl('glite-lb-ws-test','1.4.6-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-lb-yaim','4.5.8-1.el5','noarch');
'/software/packages'=pkg_repl('glite-px-proxyrenewal','1.3.31-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-px-proxyrenewal-devel','1.3.31-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-px-proxyrenewal-libs','1.3.31-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-px-proxyrenewal-progs','1.3.31-1.el5','x86_64');
'/software/packages'=pkg_repl('glite-wms-broker','3.4.0-4.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-brokerinfo','3.4.0-5.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-classad_plugin','3.4.0-4.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-common','3.5.0-3.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-configuration','3.4.0-5.sl5','noarch');
'/software/packages'=pkg_repl('glite-wms-helper','3.4.0-5.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-ice','3.5.0-4.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-ism','3.4.0-7.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-jobsubmission','3.5.0-3.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-jobsubmission-lib','3.5.0-3.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-manager','3.4.0-6.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-matchmaking','3.4.0-6.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-purger','3.5.0-3.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-utils-classad','3.4.1-1.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-utils-exception','3.4.1-1.sl5','x86_64');
'/software/packages'=pkg_repl('glite-wms-wmproxy','3.4.0-7.sl5','x86_64');
#'/software/packages'=pkg_repl('glite-yaim-bdii','4.3.13-1.el5','noarch');
#'/software/packages'=pkg_repl('glite-yaim-core','5.1.1-1.sl5','noarch');
'/software/packages'=pkg_repl('glite-yaim-wms','4.2.0-6.sl5','noarch');

# LCAS/LCMAPS
'/software/packages'=pkg_repl('lcas','1.3.19-2.el5','x86_64');
'/software/packages'=pkg_repl('lcas-lcmaps-gt4-interface','0.2.1-4.el5','x86_64');
'/software/packages'=pkg_repl('lcas-plugins-basic','1.3.6-2.el5','x86_64');
'/software/packages'=pkg_repl('lcas-plugins-voms','1.3.11-1.el5','x86_64');
'/software/packages'=pkg_repl('lcmaps','1.5.7-1.el5','x86_64');
'/software/packages'=pkg_repl('lcmaps-plugins-basic','1.5.1-2.el5','x86_64');
'/software/packages'=pkg_repl('lcmaps-plugins-voms','1.5.5-1.el5','x86_64');
'/software/packages'=pkg_repl('lcmaps-without-gsi','1.5.7-1.el5','x86_64');

# VOMS
#'/software/packages'=pkg_repl('voms','2.0.10-1.el5','x86_64');

# GLOBUS
'/software/packages'=pkg_repl('globus-authz','2.2-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-authz-callout-error','2.2-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-callout','2.2-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-common','14.7-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-ftp-control','4.4-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gfork','3.2-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gridftp-server','6.14-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gridftp-server-control','2.7-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gridftp-server-progs','6.14-1.el5','x86_64');
#'/software/packages'=pkg_repl('globus-gridmap-callout-error','1.2-2.el5','x86_64');
'/software/packages'=pkg_repl('globus-gsi-callback','4.3-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gsi-cert-utils','8.3-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gsi-credential','5.3-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gsi-openssl-error','2.1-2.el5','x86_64');
'/software/packages'=pkg_repl('globus-gsi-proxy-core','6.2-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gsi-proxy-ssl','4.1-2.el5','x86_64');
'/software/packages'=pkg_repl('globus-gsi-sysconfig','5.3-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gssapi-error','4.1-2.el5','x86_64');
'/software/packages'=pkg_repl('globus-gssapi-gsi','10.7-1.el5','x86_64');
#'/software/packages'=pkg_repl('globus-gssapi-gsi-devel','10.7-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-gss-assist','8.6-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-io','9.3-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-openssl-module','3.2-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-proxy-utils','5.0-2.el5','x86_64');
'/software/packages'=pkg_repl('globus-usage','3.1-2.el5','x86_64');
'/software/packages'=pkg_repl('globus-xio','3.3-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-xio-gsi-driver','2.3-1.el5','x86_64');
'/software/packages'=pkg_repl('globus-xio-pipe-driver','2.2-1.el5','x86_64');

# CONDOR
#'/software/packages'=pkg_repl('condor','7.4.2-1','x86_64');
#'/software/packages'=pkg_repl('condor-lcg','1.2.0-1','i386');

# BDII
'/software/packages'=pkg_repl('bdii','5.2.17-1.el5','noarch');
'/software/packages'=pkg_repl('glue-schema','2.0.10-1.el5','noarch');


# GRID STUFF
'/software/packages'=pkg_repl('fetch-crl','2.8.5-1.el5','noarch');
'/software/packages'=pkg_repl('lcg-expiregridmapdir','3.0.1-1','noarch');
'/software/packages'=pkg_repl('gridsite','2.0.4-1.el5','x86_64');
'/software/packages'=pkg_repl('gridsite-libs','2.0.4-1.el5','x86_64');

# EPEL 
'/software/packages'=pkg_repl('classads','1.0.8-1.el5','x86_64');
'/software/packages'=pkg_repl('fcgi','2.4.0-12.el5','x86_64');
'/software/packages'=pkg_repl('gsoap','2.7.13-4.el5','x86_64');
'/software/packages'=pkg_repl('jemalloc','3.1.0-1.el5','x86_64');
'/software/packages'=pkg_repl('libtar','1.2.11-13.el5','x86_64');
'/software/packages'=pkg_repl('log4c','1.2.1-7.el5','x86_64');
'/software/packages'=pkg_repl('mod_fcgid','2.2-11.el5','x86_64');
'/software/packages'=pkg_repl('myproxy-libs','5.9-2.el5','x86_64');

# ARGUS
'/software/packages'=pkg_repl('argus-gsi-pep-callout','1.3.0-1.el5','x86_64');
'/software/packages'=pkg_repl('argus-pep-api-c','2.2.0-1.el5','x86_64');
