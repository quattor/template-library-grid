unique template glite/lb/rpms/x86_64/config;

include { 'config/emi/' + EMI_VERSION + '/lb' };

'/software/packages'= {
  pkg_repl('emi-lb','1.0.1-1.el5','x86_64');
  pkg_repl('emi-version','2.4.0-1.sl5','x86_64');
  pkg_repl('glite-jobid-api-c','2.1.2-2.el5','x86_64'); 
#  pkg_repl('glite-jobid-api-cpp','1.1.2-6.sl5','x86_64'); 
  pkg_repl('glite-jobid-api-java','1.2.0-5.el5','noarch'); 
  pkg_repl('glite-lb-client','5.1.4-2.el5','x86_64'); 
  pkg_repl('glite-lb-client-java','1.2.2-1.el5','x86_64'); 
  pkg_repl('glite-lb-client-progs','5.1.4-2.el5','x86_64');
  pkg_repl('glite-lb-common','8.1.3-3.el5','x86_64'); 
  pkg_repl('glite-lb-doc','1.3.4-1.el5','noarch'); 
  pkg_repl('glite-lb-harvester','1.2.3-2.el5','x86_64'); 
  pkg_repl('glite-lb-logger','2.3.4-2.el5','x86_64'); 
  pkg_repl('glite-lb-logger-msg','1.1.3-3.el5','x86_64'); 
  pkg_repl('glite-lb-server','2.3.5-1.el5','x86_64'); 
  pkg_repl('glite-lb-state-machine','1.3.2-3.el5','x86_64'); 
  pkg_repl('glite-lb-types','1.3.1-4.el5','noarch'); 
  pkg_repl('glite-lb-utils','2.2.1-4.el5','x86_64'); 
  pkg_repl('glite-lb-ws-interface','3.3.1-4.el5','noarch'); 
  pkg_repl('glite-lb-ws-test','1.3.0-5.el5','x86_64'); 
  pkg_repl('glite-lb-yaim','4.4.3-2.el5','noarch'); 
  pkg_repl('glite-lbjp-common-db','3.1.2-2.el5','x86_64'); 
  pkg_repl('glite-lbjp-common-gsoap-plugin','3.1.2-2.el5','x86_64'); 
  pkg_repl('glite-lbjp-common-gss','3.1.3-2.el5','x86_64'); 
  pkg_repl('glite-lbjp-common-jp-interface','2.2.1-2.el5','x86_64'); 
  pkg_repl('glite-lbjp-common-log','1.2.0-5.el5','x86_64'); 
  pkg_repl('glite-lbjp-common-maildir','2.2.1-4.el5','x86_64'); 
  pkg_repl('glite-lbjp-common-server-bones','2.2.2-2.el5','x86_64'); 
  pkg_repl('glite-lbjp-common-trio','2.2.2-3.el5','x86_64'); 
};

'/software/packages'={
  pkg_repl('emi-trustmanager','3.1.3-1.sl5','noarch');
  pkg_repl('emi-trustmanager-axis','2.0.2-1.sl5','noarch');
  pkg_repl('activemq-cpp-library','3.2.5-1.sl5','x86_64');
  pkg_repl('gridsite-libs','1.7.21-2.el5','x86_64');
  pkg_repl('lcas','1.3.18-2.el5','x86_64');
  pkg_repl('voms','2.0.8-1.el5','x86_64');
  pkg_repl('axis1.4','1.4-1.sl5','noarch');
  pkg_repl('axis','1.2.1-2jpp.6','x86_64');
};

# Provided by EPEL
'/software/packages'={
  pkg_repl('classads','1.0.8-1.el5','x86_64');
  pkg_repl('c-ares','1.6.0-2.el5','x86_64');
  pkg_repl('gsoap','2.7.13-4.el5','x86_64');
  pkg_repl('log4c','1.2.1-7.el5','x86_64');
  pkg_repl('globus-callout','2.2-1.el5','x86_64');
  pkg_repl('globus-common','14.7-1.el5','x86_64');
  pkg_repl('globus-gsi-callback','4.3-1.el5','x86_64');
  pkg_repl('globus-gsi-cert-utils','8.3-1.el5','x86_64');
  pkg_repl('globus-gsi-credential','5.3-1.el5','x86_64');
  pkg_repl('globus-gsi-openssl-error','2.1-2.el5','x86_64');
  pkg_repl('globus-gsi-proxy-core','6.2-1.el5','x86_64');
  pkg_repl('globus-gsi-proxy-ssl','4.1-2.el5','x86_64');
  pkg_repl('globus-gss-assist','8.6-1.el5','x86_64');
  pkg_repl('globus-gsi-sysconfig','5.3-1.el5','x86_64');
  pkg_repl('globus-gssapi-gsi','10.7-1.el5','x86_64');
#  pkg_repl('globus-libtool','1.2-4.el5','x86_64');
  pkg_repl('globus-openssl-module','3.2-1.el5','x86_64');
  pkg_repl('globus-proxy-utils','5.0-2.el5','x86_64');
};

# Provided by OS
'/software/packages'={
  pkg_repl('jakarta-commons-discovery','0.3-4jpp.1','x86_64');
  pkg_repl('jakarta-commons-httpclient','3.0-7jpp.1','x86_64');
  pkg_repl('jakarta-commons-logging','1.0.4-6jpp.1','x86_64');
  pkg_repl('classpathx-jaf','1.0-9jpp.1','x86_64');
  pkg_repl('classpathx-mail','1.1.1-4jpp.2','x86_64');
  pkg_repl('wsdl4j','1.5.2-4jpp.1','x86_64');
};

