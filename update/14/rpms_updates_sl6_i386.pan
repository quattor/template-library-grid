# Template to add update RPMs to base configuration

template update/14/rpms_updates_sl6_i386;

'/software/packages'=pkg_ronly('bdii','5.2.22-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('bdii-config-top','1.0.10-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-c','2.1.1-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-c','2.1.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-c-debuginfo','2.1.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-c-devel','2.1.1-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-c-devel','2.1.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-c-doc','2.1.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-c-examples','2.1.1-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-c-examples','2.1.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-java','1.2.0-0.sl6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('canl-java-javadoc','1.2.0-0.sl6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('dpm-yaim','4.2.20-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('emi-bdii-top','1.0.2-2.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('emi-lb','1.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('emi-lb-nagios-plugins','1.2.12-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('emi-px','1.0.3-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('emi-px','1.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('emi-version','3.2.0-1.sl6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('emi-version','3.7.1-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glexec','0.9.11-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-info-plugin-delayed-delete-status','1.0.1-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-info-provider-ldap','1.4.8-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-jobid-api-c','2.2.8-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-jobid-api-c','2.2.11-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-jobid-api-c-debuginfo','2.2.11-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-jobid-api-c-devel','2.2.8-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-jobid-api-c-devel','2.2.11-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-jobid-api-cpp-devel','1.3.8-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-jobid-api-cpp-devel','1.3.6-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-jobid-api-java','1.3.7-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-jobid-api-java-javadoc','1.3.7-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client','6.0.6-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client','6.0.8-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-debuginfo','6.0.8-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-devel','6.0.6-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-devel','6.0.8-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-java','2.0.3-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-java','2.0.5-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-java-axis','2.0.5-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-java-debuginfo','2.0.5-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-java-javadoc','2.0.5-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-progs','6.0.6-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-client-progs','6.0.8-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-common','9.0.6-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-common','9.0.8-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-common-debuginfo','9.0.8-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-common-devel','9.0.6-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-common-devel','9.0.8-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-doc','1.4.15-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-harvester','1.3.11-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-harvester','1.3.13-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-harvester-debuginfo','1.3.13-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-logger','2.4.19-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-logger','2.4.21-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-logger-debuginfo','2.4.21-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-logger-devel','2.4.19-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-logger-devel','2.4.21-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-logger-msg','1.2.9-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-logger-msg','1.2.11-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-logger-msg-debuginfo','1.2.11-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-server','3.0.13-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-server','3.0.16-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-server-debuginfo','3.0.16-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-state-machine','2.0.5-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-state-machine','2.0.7-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-state-machine-debuginfo','2.0.7-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-state-machine-devel','2.0.5-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-state-machine-devel','2.0.7-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-state-machine-plugins','2.0.5-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-state-machine-plugins','2.0.7-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-types','2.0.8-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-utils','2.3.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-utils','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-utils-debuginfo','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-ws-interface','4.0.7-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-ws-test','1.4.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-ws-test','1.4.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-ws-test-debuginfo','1.4.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lb-yaim','4.5.13-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-db','3.2.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-db','3.2.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-db-debuginfo','3.2.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-db-devel','3.2.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-db-devel','3.2.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gsoap-plugin','3.2.8-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gsoap-plugin','3.2.10-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gsoap-plugin-debuginfo','3.2.10-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gsoap-plugin-devel','3.2.8-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gsoap-plugin-devel','3.2.10-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gss','3.2.12-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gss','3.2.14-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gss-debuginfo','3.2.14-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gss-devel','3.2.12-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-gss-devel','3.2.14-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-jp-interface','2.3.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-jp-interface','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-jp-interface-debuginfo','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-jp-interface-devel','2.3.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-jp-interface-devel','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-log','1.3.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-log','1.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-log-debuginfo','1.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-log-devel','1.3.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-log-devel','1.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-maildir','2.3.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-maildir','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-maildir-debuginfo','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-maildir-devel','2.3.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-maildir-devel','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-server-bones','2.3.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-server-bones','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-server-bones-debuginfo','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-server-bones-devel','2.3.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-server-bones-devel','2.3.9-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-trio','2.3.9-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-trio','2.3.11-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-trio-debuginfo','2.3.11-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-trio-devel','2.3.9-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-lbjp-common-trio-devel','2.3.11-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-myproxy-yaim','4.1.15-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-proxyrenewal','1.3.32-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-proxyrenewal','1.3.35-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-proxyrenewal-debuginfo','1.3.35-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-proxyrenewal-devel','1.3.32-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-proxyrenewal-devel','1.3.35-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-proxyrenewal-libs','1.3.32-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-proxyrenewal-libs','1.3.35-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-proxyrenewal-progs','1.3.32-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-px-proxyrenewal-progs','1.3.35-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('glite-yaim-bdii','4.3.15-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glue-validator','2.0.20-0.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('glue-validator-cron','1.3.0-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('gridsite','2.2.2-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('gridsite-commands','2.2.2-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('gridsite-compat1.7','1.7.25-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('gridsite-compat1.7','1.7.29-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('gridsite-compat1.7-debuginfo','1.7.29-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('gridsite-debuginfo','2.2.2-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('gridsite-devel','2.2.2-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('gridsite-libs','2.2.2-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('gridsite-service-clients','2.2.2-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps','1.6.4-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-basic-interface','1.6.1-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-common-devel','1.6.4-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-devel','1.6.4-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-globus-interface','1.6.1-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-openssl-interface','1.6.1-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-plugins-basic','1.6.3-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-plugins-basic-ldap','1.6.3-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-plugins-c-pep','1.2.6-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-plugins-tracking-groupid','0.1.2-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-plugins-verify-proxy','1.5.6-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-plugins-voms','1.6.4-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-without-gsi','1.6.4-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcmaps-without-gsi-devel','1.6.4-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lfc-yaim','4.2.7-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('mkgltempdir','0.0.4-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc','3.0.1-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-acix-cache','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-acix-core','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-acix-index','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-arcproxyalt','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-arex','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-aris','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-ca-utils','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-cache-service','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-client','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-client-tools','1.0.7-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-compute-element','1.0.7-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-datadelivery-service','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-devel','3.0.1-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-devel','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-doc','1.3.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-doxygen','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-egiis','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-gridftpd','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-gridmap-utils','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-hed','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-information-index','1.0.7-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-java','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-ldap-infosys','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-ldap-monitor','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-misc-utils','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-nagios-plugins','1.6.0-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-nagios-plugins-doc','1.6.0-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-plugins-gfal','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-plugins-globus','3.0.1-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-plugins-globus','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-plugins-needed','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-plugins-xrootd','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-python','3.0.3-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('nordugrid-arc-ws-monitor','3.0.3-1.el6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('unicore-hila-emi-es','2.4.1-1.sl6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('unicore-hila-gridftp','2.4.1-1.sl6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('unicore-hila-shell','2.4.1-1.sl6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('unicore-hila-unicore6','2.4.1-1.sl6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('unicore-unicorex6','6.0.1-0.sl6','noarch', '', '', 'emi');
