unique template glite/argus/rpms/config;

# RPMS for ARGUS 
include  { 'glite/argus/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/config' };

# OS specific dependencies
include { 'config/emi/' + EMI_VERSION + '/argus' };

