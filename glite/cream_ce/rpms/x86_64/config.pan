unique template glite/cream_ce/rpms/x86_64/config;

# Add required RPMs provided by the OS
include { "config/emi/" + EMI_VERSION + "/cream-ce" };

#EMI
"/software/packages"=pkg_repl("emi-cream-ce","1.1.0-4.sl5","x86_64");
"/software/packages"=pkg_repl("emi-trustmanager","3.1.3-1.sl5","noarch");
"/software/packages"=pkg_repl("emi-version","3.0.0-1.sl5","x86_64");
"/software/packages"=pkg_repl("emi-trustmanager-tomcat","3.0.1-1.sl5","noarch");
"/software/packages"=pkg_repl("emi-trustmanager-axis2","1.0.1-1.sl5","noarch");
"/software/packages"=pkg_repl("emi-trustmanager-axis","2.0.2-1.sl5","noarch");
"/software/packages"=pkg_repl("emi-delegation-java","2.2.0-2.sl5","noarch");

#GLITE
"/software/packages"=pkg_repl("glite-ce-blahp","1.18.0-4.sl5","x86_64");
"/software/packages"=pkg_repl("glite-ce-ce-plugin","1.14.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-ce-cream","1.14.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-ce-cream-api-java","1.14.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-ce-job-plugin","1.14.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-ce-monitor","1.14.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-ce-cream-es","1.14.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-ce-cream-core","1.14.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-ce-common-java","1.14.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-ce-monitor-api-java","1.14.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-jdl-api-java","3.3.1-2.sl5","noarch");
"/software/packages"=pkg_repl("glite-info-provider-service", "1.12.0-1.el5", "noarch");
"/software/packages"=pkg_repl("glite-info-site","0.4.0-1.el5","noarch");
"/software/packages"=pkg_repl("glite-info-static","0.2.0-1.el5","noarch");
"/software/packages"=pkg_repl("glite-initscript-globus-gridftp","1.0.4-1.sl5","noarch");
"/software/packages"=pkg_repl("glite-jobid-api-c","2.2.7-1.el5","x86_64");
##"/software/packages"=pkg_repl("glite-jobid-api-cpp","2.1.2-2.el5","x86_64");
"/software/packages"=pkg_repl("glite-lb-common","9.0.5-1.el5","x86_64");
"/software/packages"=pkg_repl("glite-lb-logger","2.4.15-1.el5","x86_64");
"/software/packages"=pkg_repl("glite-lbjp-common-trio","2.3.8-1.el5","x86_64");
"/software/packages"=pkg_repl("glite-lbjp-common-gsoap-plugin","3.2.7-1.el5","x86_64");
"/software/packages"=pkg_repl("glite-lbjp-common-gss","3.2.11-1.el5","x86_64");
"/software/packages"=pkg_repl("glite-lbjp-common-log","1.3.6-1.el5","x86_64");
"/software/packages"=pkg_repl("glite-security-util-java","2.8.0-1.el5","x86_64");
"/software/packages"=pkg_repl("glite-yaim-core", "5.1.1-1.sl5", "noarch");
"/software/packages"=pkg_repl("glite-ce-yaim-cream-ce","4.3.0-4.sl5","noarch");
"/software/packages"=pkg_repl("glite-ce-cream-utils","1.2.0-4.sl5","x86_64");
"/software/packages"=pkg_repl("glite-yaim-torque-client","5.1.0-1.sl5","noarch");



#LCAS/LCMAPS
"/software/packages"=pkg_repl("lcas","1.3.19-2.el5","x86_64");
"/software/packages"=pkg_repl("lcas-interface","1.3.19-2.el5","x86_64");
"/software/packages"=pkg_repl("lcas-lcmaps-gt4-interface","0.2.1-4.el5","x86_64");
"/software/packages"=pkg_repl("lcas-plugins-basic","1.3.6-2.el5","x86_64");
"/software/packages"=pkg_repl("lcas-plugins-check-executable","1.2.4-2.el5","x86_64");
"/software/packages"=pkg_repl("lcas-plugins-voms","1.3.11-1.el5","x86_64");
"/software/packages"=pkg_repl("lcmaps","1.5.7-1.el5","x86_64");
"/software/packages"=pkg_repl("lcmaps-plugins-basic","1.5.1-2.el5","x86_64");
"/software/packages"=pkg_repl("lcmaps-plugins-verify-proxy","1.5.4-1.el5","x86_64");
"/software/packages"=pkg_repl("lcmaps-plugins-voms","1.5.5-1.el5","x86_64");
"/software/packages"=pkg_repl("lcmaps-plugins-c-pep","1.2.3-1.el5","x86_64");

#VOMS
"/software/packages"=pkg_repl("voms","2.0.10-1.el5","x86_64");
"/software/packages"=pkg_repl("voms-clients","2.0.10-1.el5","x86_64");  
"/software/packages"=pkg_repl("voms-api-java","2.0.10-1.el5","noarch");

#LCG
"/software/packages"=pkg_repl("lcg-expiregridmapdir","3.0.1-1","noarch");
#"/software/packages"=pkg_repl("lcg-info-dynamic-scheduler-generic","2.3.5-1.sl5","noarch");
"/software/packages"=pkg_repl("lcg-info-dynamic-software","1.0.7-1.sl5","noarch");
"/software/packages"=pkg_repl("info-dynamic-pbs","3.0.0-1.sl5","noarch");

#GLOBUS
include { 'common/globus/rpms/config' };

#GSOAP
"/software/packages"=pkg_repl("gsoap","2.7.13-4.el5","x86_64");

#GLEXEC/ARGUS
"/software/packages"=pkg_repl("glexec","0.9.8-1.el5","x86_64");
"/software/packages"=pkg_repl("argus-gsi-pep-callout","1.3.0-1.el5","x86_64");
"/software/packages"=pkg_repl("argus-pep-api-c","2.2.0-1.el5","x86_64");
"/software/packages"=pkg_repl("argus-pep-common","2.3.0-1.el5","noarch");
"/software/packages"=pkg_repl("argus-pep-api-java","2.2.0-1.el5","noarch");

#BDII
"/software/packages"=pkg_repl("bdii", "5.2.17-1.el5", "noarch");
"/software/packages"=pkg_repl("glue-schema", "2.0.10-1.el5", "noarch");

#GRID STUFF
"/software/packages"=pkg_repl("cleanup-grid-accounts", "2.0.1-1", "noarch");
"/software/packages"=pkg_repl("edg-mkgridmap","4.0.0-1","noarch");
#"/software/packages"=pkg_repl("gridsite-shared","1.7.13-1.sl5","x86_64");
"/software/packages"=pkg_repl("kill-stale-ftp","1.0.1-1.sl5","noarch");
"/software/packages"=pkg_repl("gridsite-libs","2.0.4-1.el5","x86_64");

#OTHERS
"/software/packages"=pkg_repl("c-ares", "1.6.0-2.el5", "x86_64");
"/software/packages"=pkg_repl("mysql-connector-java", "5.1.12-2.el5", "x86_64");
##"/software/packages"=pkg_repl("geronimo-specs-poms","1.2-13.jpp5","noarch");
##"/software/packages"=pkg_repl("geronimo-jta-1.0.1B-api","1.2-13.jpp5","noarch");
##"/software/packages"=pkg_repl("jakarta-commons-modeler","2.0-5.jpp5","noarch");
"/software/packages"=pkg_repl("mm-mysql","3.1.8-2.sl5","noarch");
"/software/packages"=pkg_repl("classads","1.0.8-1.el5","x86_64");
"/software/packages"=pkg_repl("classpathx-jaf","1.0-9jpp.1","x86_64");
"/software/packages"=pkg_repl("log4c","1.2.1-7.el5","x86_64");
"/software/packages"=pkg_repl("jakarta-commons-cli","1.0-6jpp_10.el5","x86_64");
"/software/packages"=pkg_repl("jakarta-commons-lang","2.1-5jpp.1","x86_64"); # OS
"/software/packages"=pkg_repl("dynsched-generic","2.5.1-3.sl5","noarch");
"/software/packages"=pkg_repl("lrms-python-generic","2.2.1-2.sl5","noarch");
"/software/packages"=pkg_repl("axis2","1.6.1-1.emi","noarch");
#TO_BE_FIXED: does not look like a good place to have this rpm included
"/software/packages"=pkg_repl("java-1.6.0-openjdk","1.6.0.0-1.11.b16.el5","x86_64"); # OS
"/software/packages"=pkg_repl('geronimo-jta-1.1-api','1.2-13.jpp5','noarch');
"/software/packages"=pkg_repl("geronimo-specs-poms","1.2-13.jpp5","noarch");

#Must be removed
'/software/packages'=pkg_repl('glite-info-templates','1.0.0-12','noarch'); 

'/software/packages' = {
  if ( EMI_UPDATE_VERSION >= '08' ) {
    # From EPEL
    pkg_repl('glite-ce-wsdl','1.15.1-1.sl5','noarch', '', '', 'emi');
  };
  SELF;
};
