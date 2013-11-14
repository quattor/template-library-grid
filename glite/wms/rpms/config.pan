unique template glite/wms/rpms/config;

# RPMS for WMS 
include  { 'glite/wms/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/config' };

# OS specific dependencies
include { 'config/emi/' + EMI_VERSION + '/wms' };
