unique template glite/lb/rpms/config;

# RPMS for LB
include  { 'glite/lb/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/config' };

# OS specific dependencies
include { 'config/emi/' + EMI_VERSION + '/lb' };
