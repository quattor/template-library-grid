unique template glite/lb/rpms/config;

# RPMS for LB
include  { 'glite/lb/rpms/' + PKG_ARCH_GLITE + '/config' };

# Add OS RPMs specific to LB
#include { 'config/glite/'+GLITE_VERSION+'/lb' };


