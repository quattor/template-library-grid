unique template glite/lb/rpms/i386/config;

include { 'config/glite/' + GLITE_VERSION + '/lb' };

'/software/packages' = pkg_repl('bdii', '5.2.17-1.el5', 'noarch');
'/software/packages' = pkg_repl('c-ares', '1.3.0-4.slc4', 'i686');
'/software/packages' = pkg_repl('classads', '0.9.8-2.slc4', 'i686');
'/software/packages' = pkg_repl('edg-mkgridmap', '4.0.0-1', 'noarch');
'/software/packages' = pkg_repl('glite-LB', '3.1.1-0', 'i386');
'/software/packages' = pkg_repl('glite-info-generic', '2.0.2-3', 'noarch');
'/software/packages' = pkg_repl('glite-info-templates', '1.0.0-8', 'noarch');
'/software/packages' = pkg_repl('glite-lb-client', '3.1.5-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-lb-client-interface', '3.1.1-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-lb-common', '6.1.1-2.slc4', 'i386');
'/software/packages' = pkg_repl('glite-lb-logger', '1.4.9-2.slc4', 'i386');
'/software/packages' = pkg_repl('glite-lb-proxy', '1.5.2-2.slc4', 'i386');
'/software/packages' = pkg_repl('glite-lb-server', '1.8.3-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-lb-server-bones', '2.2.6-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-lb-ws-interface', '2.4.0-3.slc4', 'i386');
'/software/packages' = pkg_repl('glite-rgma-api-python', '5.0.12-3', 'noarch');
'/software/packages' = pkg_repl('glite-rgma-base', '5.0.7-1', 'noarch');
'/software/packages' = pkg_repl('glite-security-gsoap-plugin', '1.5.2-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-security-voms-api-c', '1.8.3-3.slc4', 'i386');
'/software/packages' = pkg_repl('glite-security-voms-api-cpp', '1.8.3-3.slc4', 'i386');
'/software/packages' = pkg_repl('glite-version', '3.1.0-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-wms-utils-exception', '3.1.3-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-wms-utils-jobid', '3.1.3-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-yaim-core', '5.1.1-1.sl5', 'noarch');
'/software/packages' = pkg_repl('glite-yaim-lb', '4.0.1-3', 'noarch');
'/software/packages' = pkg_repl('glue-schema', '2.0.10-1.el5', 'noarch');
'/software/packages' = pkg_repl('gpt', 'VDT1.6.0x86_rhas_4-1', 'i386');
'/software/packages' = pkg_repl('gridsite-shared', '1.1.18.1-1', 'i386');
'/software/packages' = pkg_repl('lcg-mon-job-status', '2.0.8-1', 'noarch');
'/software/packages' = pkg_repl('lcg-mon-logfile-common', '1.0.6-2', 'noarch');
'/software/packages' = pkg_repl('lcg-service-proxy', '1.0.3-2', 'noarch');
'/software/packages' = pkg_repl('python-logging', '0.4.6-1', 'noarch');
'/software/packages' = pkg_repl('vdt_globus_essentials', 'VDT1.6.1x86_rhas_4-6', 'i386');

# Not strictly required but used by QWG
'/software/packages'= if ( GLITE_UPDATE_VERSION >= '32' ) {
                        pkg_repl('glite-info-provider-service','1.12.0-1.el5', 'noarch');
                      } else {
                        SELF;
                      };

# Required by update 35
'/software/packages' = if ( GLITE_UPDATE_VERSION >= '35' ) {
                         pkg_repl('glite-security-voms-api-noglobus','1.8.8-2.slc4','i386');
                      } else {
                        return(SELF);
                      };

# Required by update 53
'/software/packages'= if ( GLITE_UPDATE_VERSION >= '53' ) {
                        pkg_repl('glite-lb-utils','1.3.0-1.slc4','i386');
                        pkg_repl('glite-jp-common','1.3.0-3.slc4','i386');
                      } else {
                        return(SELF);
                      };

# Required by update 54
'/software/packages'= if ( GLITE_UPDATE_VERSION >= '54' ) {
                        pkg_repl('glite-info-provider-release','1.0.0-5','noarch');
                      } else {
                        return(SELF);
                      };
'/software/packages'= if ( GLITE_UPDATE_VERSION >= '62' ) {
                         pkg_repl('glite-lb-notif-logger','1.0.0-3.slc4','i386');
                        } else {
                         return(SELF);
                        };

'/software/packages'= if ( GLITE_UPDATE_VERSION >= '69' ) {
                         pkg_repl('glite-lb-harvester','1.0.4-2_nodb.slc4','i386');
                         pkg_repl('msg-publish-simple','0.11.2-1.el4','noarch');
                         pkg_repl('msg-publish-simple-config-EGEE','0.11.2-1.el4','noarch');
                        } else {
                         return(SELF);
                        };
