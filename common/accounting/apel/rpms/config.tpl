unique template common/accounting/apel/rpms/config;

include { 'common/accounting/apel/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/config' };

