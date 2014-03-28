unique template feature/gridftp/service;

# Include RPMs
include { 'feature/gridftp/rpms/config' };

# Modify the loadable library path.
include { 'feature/ldconf/config' };

# Configuration for LCMAPS.
include { 'feature/lcmaps/base' };

# Configuration for LCAS.
include { 'feature/lcas/base' };

# Configure gridftp service
include { 'feature/gridftp/config' };


##TO_BE_FIXED: not compiling. I've just commented it
# Configure minimal Globus environment as it is required by 'lcg-tags --ce'
#variable GRIDFTP_EDG_SYSCONFIG_TEMPLATE = if ( is_defined(GIP_CLUSTER_PUBLISHER_HOST) && (GIP_CLUSTER_PUBLISHER_HOST == FULL_HOSTNAME) ) {
#                                            debug(FULL_HOSTNAME+' is the GIP_CLUSTER_PUBLISHER_HOST: defining EDG sysconfig.');
#                                            'feature/edg/sysconfig';
#                                          } else {
#                                            debug(FULL_HOSTNAME+' is not the GIP_CLUSTER_PUBLISHER_HOST ('+to_string(GIP_CLUSTER_PUBLISHER_HOST)+'). EDG sysconfig not defined.');
#                                            null;
#                                          };
#include { GRIDFTP_EDG_SYSCONFIG_TEMPLATE };

