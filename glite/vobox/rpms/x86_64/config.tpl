unique template glite/vobox/rpms/x86_64/config;
#
# WLCG-VOBOX
#
'/software/packages'=pkg_repl('wlcg-vobox','1.0.0-1.el6','noarch');
'/software/packages' = pkg_repl('lcg-vobox', '2.1.3-1', 'noarch');

#
#'/software/packages' = pkg_repl('CGSI_gSOAP_2.7', '1.3.3-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('CGSI_gSOAP_2.7-voms', '1.3.3-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('DPM-client', '1.7.2-5sec.sl5', 'x86_64');
#'/software/packages' = pkg_repl('DPM-interfaces', '1.7.2-5sec.sl5', 'x86_64');
#'/software/packages' = pkg_repl('DPM-interfaces2', '1.7.2-5sec.sl5', 'x86_64');
#'/software/packages' = pkg_repl('GFAL-client', '1.11.8-2.sl5', 'x86_64');
#'/software/packages' = pkg_repl('LFC-client', '1.7.2-5sec.sl5', 'x86_64');
#'/software/packages' = pkg_repl('LFC-interfaces', '1.7.2-5sec.sl5', 'x86_64');
#'/software/packages' = pkg_repl('LFC-interfaces2', '1.7.2-5sec.sl5', 'x86_64');
#'/software/packages' = pkg_repl('ZSI', '2.0-1.py2.4', 'noarch');
#'/software/packages' = pkg_repl('bouncycastle-glite', '1.42-3.jdk5', 'noarch');
#'/software/packages' = pkg_repl('c-ares', '1.3.0-4.sl5', 'x86_64');
#'/software/packages' = pkg_repl('dcache-dcap', '1.8.0-15p8', 'i586');
#'/software/packages' = pkg_repl('dcache-srmclient', '1.8.0-15p8', 'noarch');
#'/software/packages' = pkg_repl('edg-mkgridmap', '3.0.0-1', 'noarch');
#'/software/packages' = pkg_repl('fetch-crl', '2.7.0-2', 'noarch');
#'/software/packages' = pkg_repl('fpconst', '0.7.2-1.py2.4', 'noarch');
#'/software/packages' = pkg_repl('glite-VOBOX', '3.2.1-0', 'x86_64');
#'/software/packages' = pkg_repl('glite-amga-cli', '1.3.0-4', 'x86_64');
#'/software/packages' = pkg_repl('glite-ce-cream-cli', '1.11.1-3.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-ce-cream-client-api-c', '1.11.1-3.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-ce-monitor-client-api-c', '1.11.1-3.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-data-catalog-interface', '2.0.0-8', 'noarch');
#'/software/packages' = pkg_repl('glite-data-delegation-api-c', '2.0.0-5.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-data-delegation-cli', '2.0.0-5.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-data-hydra-cli', '3.1.2-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-data-transfer-cli', '3.6.2-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-data-transfer-interface', '3.6.0-1', 'noarch');
#'/software/packages' = pkg_repl('glite-data-util-c', '1.2.3-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-info-generic', '2.0.2-3', 'noarch');
#'/software/packages' = pkg_repl('glite-info-provider-service', '1.1.5-0', 'noarch');
#'/software/packages' = pkg_repl('glite-initscript-globus-gridftp', '1.0.2-1', 'noarch');
#'/software/packages' = pkg_repl('glite-jdl-api-cpp', '3.2.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-jobid-api-c', '1.0.0-2.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-jobid-api-cpp', '1.0.0-2.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-lb-client', '4.0.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-lb-common', '7.0.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-lbjp-common-trio', '1.0.0-4.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-security-delegation-java', '1.6.1-1', 'noarch');
#'/software/packages' = pkg_repl('glite-security-gsoap-plugin', '2.0.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-security-gss', '2.0.0-3.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-security-ssss', '1.0.0-3.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-security-trustmanager', '2.0.1-2', 'noarch');
#'/software/packages' = pkg_repl('glite-security-util-java', '2.0.1-1', 'noarch');
#'/software/packages' = pkg_repl('glite-security-voms-admin-client', '2.0.8-1', 'noarch');
#'/software/packages' = pkg_repl('glite-security-voms-admin-interface', '2.0.2-1', 'noarch');
#'/software/packages' = pkg_repl('glite-security-voms-api', '1.8.12-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-security-voms-api-c', '1.8.12-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-security-voms-api-cpp', '1.8.12-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-security-voms-clients', '1.8.12-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-service-discovery-api-c', '2.2.2-2.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-service-discovery-api-java', '2.0.2-2', 'noarch');
#'/software/packages' = pkg_repl('glite-service-discovery-bdii-c', '2.2.2-3.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-service-discovery-cli', '2.2.1-2.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-service-discovery-file-c', '2.1.2-2.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-version', '3.2.0-0.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-wms-ui-api-python', '3.3.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-wms-ui-commands', '3.3.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-wms-ui-configuration', '3.3.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-wms-utils-classad', '3.2.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-wms-utils-exception', '3.2.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-wms-wmproxy-api-cpp', '3.3.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-wms-wmproxy-api-java', '3.3.1-1', 'noarch');
#'/software/packages' = pkg_repl('glite-wms-wmproxy-api-python', '3.3.1-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('glite-yaim-clients', '4.0.9-2', 'noarch');
#'/software/packages' = pkg_repl('glite-yaim-core', '4.0.10-2', 'noarch');
#'/software/packages' = pkg_repl('gpt', '3.2autotools2004_NMI_9.0_x86_64_rhap_5-1', 'x86_64');
#'/software/packages' = pkg_repl('gridsite-commands', '1.5.10-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('gridsite-shared', '1.5.10-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('gsiopenssh', 'VDT1.10.1x86_64_rhap_5-4.3', 'x86_64');
#'/software/packages' = pkg_repl('lcg-dm-common', '1.7.2-5sec.sl5', 'x86_64');
#'/software/packages' = pkg_repl('lcg-info', '1.11.4-1', 'noarch');
#'/software/packages' = pkg_repl('lcg-infosites', '2.6.2-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('lcg-proxy-renew', '1.0.1-0', 'noarch');
#'/software/packages' = pkg_repl('lcg-tags', '0.4.0-1', 'noarch');
#'/software/packages' = pkg_repl('lcg-vobox', '1.0.4-4', 'noarch');
#'/software/packages' = pkg_repl('lcg_util', '1.7.6-1.sl5', 'x86_64');
#'/software/packages' = pkg_repl('myproxy', 'VDT1.10.1x86_64_rhap_5-4.2', 'x86_64');
#'/software/packages' = pkg_repl('uberftp-client', 'VDT1.10.1x86_64_rhap_5-1.27', 'x86_64');
#'/software/packages' = pkg_repl('vdt_globus_data_server', 'VDT1.10.1x86_64_rhap_5-3', 'x86_64');
#'/software/packages' = pkg_repl('vdt_globus_essentials', 'VDT1.10.1x86_64_rhap_5-3', 'x86_64');
#'/software/packages' = pkg_repl('vdt_globus_rm_client', 'VDT1.10.1x86_64_rhap_5-3', 'x86_64');
#'/software/packages' = pkg_repl('vdt_globus_rm_essentials', 'VDT1.10.1x86_64_rhap_5-3', 'x86_64');
#'/software/packages' = pkg_repl('vdt_globus_rm_server', 'VDT1.10.1x86_64_rhap_5-3', 'x86_64');
#'/software/packages' = pkg_repl('vdt_globus_sdk', 'VDT1.10.1x86_64_rhap_5-3', 'x86_64');
#'/software/packages' = pkg_repl('libtar', '1.2.11-2.2.el5.rf', 'x86_64');
#'/software/packages' = pkg_repl('log4cpp', '1.0-1.el5.rf', 'x86_64');
#
## Required dependencies missing in official RPM list (from JPackages 5.0)
#'/software/packages' = pkg_repl('log4j','1.2.14-15.jpp5','noarch');
#'/software/packages' = pkg_repl('bcel','5.1-16.jpp5','noarch');
#'/software/packages' = pkg_repl('geronimo-jaf-1.0.2-api','1.2-13.jpp5','noarch');
#'/software/packages' = pkg_repl('geronimo-javamail-1.3.1-api','1.2-13.jpp5','noarch');
#'/software/packages' = pkg_repl('geronimo-jms-1.1-api','1.2-13.jpp5','noarch');
#'/software/packages' = pkg_repl('geronimo-specs-poms','1.2-13.jpp5','noarch');
#'/software/packages' = pkg_repl('jakarta-commons-logging','1.1-8.jpp5','noarch');
#'/software/packages' = pkg_repl('mx4j','3.0.1-9.jpp5','noarch');
#'/software/packages' = pkg_repl('regexp','1.5-1.jpp5','noarch');
#'/software/packages' = pkg_repl('sun-jaf','1.1-3jpp','noarch');
#'/software/packages' = pkg_repl('sun-mail','1.4-2jpp','noarch');
#'/software/packages' = pkg_repl('xml-commons','1.3.04-5.jpp5','noarch');
#'/software/packages' = pkg_repl('xml-commons-jaxp-1.3-apis','1.3.04-5.jpp5','noarch');
#'/software/packages' = pkg_repl('xml-commons-resolver12','1.3.04-5.jpp5','noarch');
#
#
## Required by update 05
#'/software/packages' = if ( GLITE_UPDATE_VERSION >= '05' ) {
#                         pkg_del('lcg-infosites');
#                         pkg_repl("lcg-infosites","2.6.8-2","noarch");
#                        } else {
#                          SELF;
#                        };
#
## Required by update 07
#'/software/packages' = if ( GLITE_UPDATE_VERSION >= '07' ) {
#                         pkg_repl("vdt_globus_data_server","VDT1.10.1x86_64_rhap_5-4","x86_64");
#                        } else {
#                          SELF;
#                        };
#
## Required by update 08
#'/software/packages' = if ( GLITE_UPDATE_VERSION >= '08' ) {
#                         pkg_repl("dcache-srmclient-deps-sl5","0.0.1-0","noarch");
#                         pkg_repl("libdcap-tunnel-gsi","1.9.3-6","x86_64");
#                         pkg_repl("libdcap-tunnel-gsi","1.9.3-6","i386");
#                         pkg_repl("libdcap-tunnel-telnet","1.9.3-6","x86_64");
#                         pkg_repl("libdcap-tunnel-telnet","1.9.3-6","i386");
#                         pkg_repl("libdcap-tunnel-krb","1.9.3-6","x86_64");
#                         pkg_repl("libdcap-tunnel-krb","1.9.3-6","i386");
#                         pkg_repl("libdcap","1.9.3-6","x86_64");
#                         pkg_repl("libdcap","1.9.3-6","i386");
#                         pkg_repl("libdcap-devel","1.9.3-3","x86_64");
#                         pkg_repl("libdcap-devel","1.9.3-3","i386");
#                         pkg_repl("dcap","1.9.3-6","x86_64");
#                         pkg_repl("vdt_globus_essentials","VDT1.10.1x86_rhap_5-4","i386");
#                         pkg_del('dcache-dcap');
#                       } else {
#                         SELF;
#                       };
#
## Required by update 16
#'/software/packages' = if ( GLITE_UPDATE_VERSION >= '16' ) {
#                         pkg_del('dcache-srmclient-deps');
#                         pkg_del('DPM-client');
#                         pkg_del('DPM-interfaces2');
#                         pkg_del('DPM-interfaces');
#                         pkg_del('LFC-client');
#                         pkg_del('LFC-interfaces2');
#                         pkg_del('LFC-interfaces');
#                         pkg_del('glite-info-provider-release');
#                         pkg_del('lcg-dm-common');
#
#                         pkg_repl('bdii','5.0.8-1','noarch');
#                         pkg_repl('dpm-devel','1.7.4-7sec.sl5','x86_64');
#                         pkg_repl('dpm-libs','1.7.4-7sec.sl5','x86_64');
#                         pkg_repl('dpm','1.7.4-7sec.sl5','x86_64');
#                         pkg_repl('glite-info-templates','1.0.0-11','noarch');
#                         pkg_repl('glue-schema','2.0.3-1','noarch');
#                         pkg_repl("lcgdm-devel","1.7.4-7sec.sl5","x86_64");
#                         pkg_repl("lcgdm-libs","1.7.4-7sec.sl5","x86_64");
#                         pkg_repl("libdcap-devel","2.47.2-0","x86_64");
#                         pkg_repl("libdcap-tunnel-ssl","2.47.2-0","x86_64");
#                         pkg_repl("lcg-ManageVOTag","2.2.1-4","noarch");
#                         pkg_repl("lfc-devel","1.7.4-7sec.sl5","x86_64");
#                         pkg_repl("lfc-libs","1.7.4-7sec.sl5","x86_64");
#                         pkg_repl("lfc","1.7.4-7sec.sl5","x86_64");
#                         pkg_repl("perl-dpm","1.7.4-7sec.sl5","x86_64");
#                         pkg_repl("perl-lfc","1.7.4-7sec.sl5","x86_64");
#                         pkg_repl("python-dpm","1.7.4-7sec.sl5","x86_64");
#                         pkg_repl("python-lfc","1.7.4-7sec.sl5","x86_64");
#                       } else {
#                         SELF;
#                       };
#
## Update 24 : resolve deps
#'/software/packages' = if ( GLITE_UPDATE_VERSION >= '24' ) {
#                         pkg_repl("glite-lbjp-common-gss","2.1.5-1.sl5","x86_64"); #needed by glite-lb-common/client
#                       } else {
#                         SELF;
#                       };
#                       
## Update 28
#'/software/packages' = if ( GLITE_UPDATE_VERSION >= '28' ) {
#                         pkg_del('glite-amga-cli');
#                         pkg_del('glite-data-hydra-cli');
#                         pkg_del('glite-info-generic');
#                         pkg_del('glite-info-templates');
#                         pkg_del('glite-security-gss');
#
#                         pkg_repl("gpt","3.2_4.0.8p1_x86_64_rhap_5-1","x86_64");
#                         pkg_repl('GFAL-client-py25','1.11.16-2.sl5','x86_64');
#                         pkg_repl('GFAL-client-py26','1.11.16-2.sl5','x86_64');
#                         pkg_repl("glite-lbjp-common-gss","2.1.5-4.sl5","x86_64");
#                         pkg_repl('glite-wms-brokerinfo-access','3.3.1-1.sl5','x86_64');
#                         pkg_repl('lcg_util-py25','1.11.16-2.sl5','x86_64');
#                         pkg_repl('lcg_util-py26','1.11.16-2.sl5','x86_64');
#                         pkg_repl('python25-dpm','1.8.0-1sec.sl5','x86_64');
#                         pkg_repl('python25-lfc','1.8.0-1sec.sl5','x86_64');
#                         pkg_repl('python26-dpm','1.8.0-1sec.sl5','x86_64');
#                         pkg_repl('python26-lfc','1.8.0-1sec.sl5','x86_64');
#                       } else {
#                         SELF;
#                       };
#
