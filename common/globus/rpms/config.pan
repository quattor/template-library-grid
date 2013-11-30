unique template common/globus/rpms/config;

include { 'common/globus/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/config' };

# OS specific dependencies
include { 'config/emi/' + EMI_VERSION + '/wms' };
