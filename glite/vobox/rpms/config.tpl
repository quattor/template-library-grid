unique template glite/vobox/rpms/config;

# VOBOX specific RPMS
include  { 'glite/vobox/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/config' };

# OS RPMs required by VOBOX
include { 'config/emi/' + EMI_VERSION + '/vobox' };
