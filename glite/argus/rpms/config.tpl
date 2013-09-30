unique template glite/argus/rpms/config;

# RPMS for ARGUS 
include  { 'glite/argus/rpms/' + PKG_ARCH_GLITE + '/config' };

# Add OS RPMs specific to ARGUS
include { 'config/emi/'+EMI_VERSION+'/argus' };

