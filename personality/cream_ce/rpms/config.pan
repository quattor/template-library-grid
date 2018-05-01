unique template personality/cream_ce/rpms/config;

'/software/packages' = {
    if (OS_VERSION_PARAMS['major'] == 'sl6') {
        pkg_repl('emi-cream-ce');
    } else {
        pkg_repl('argus-gsi-pep-callout');
        pkg_repl('canl-java-tomcat');
        pkg_repl('cleanup-grid-accounts');
        pkg_repl('dynsched-generic');
        pkg_repl('glexec');
        pkg_repl('apel-parsers');
        pkg_repl('glite-ce-ce-plugin');
        pkg_repl('glite-ce-cream-es');
        pkg_repl('glite-ce-job-plugin');
        pkg_repl('glite-lb-logger');
        pkg_repl('tomcat');
        pkg_repl('tomcat-native');
    };
};

