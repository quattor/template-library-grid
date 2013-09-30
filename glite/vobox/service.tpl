unique template glite/vobox/service;

# Include RPMs for VOBOX
include { 'glite/vobox/rpms/config' };

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# Include standard environmental variables.
include { 'common/glite/env' };
#cd include { 'common/lcg/env' }; # existe pas
include { 'common/globus/env' };

# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
#cd include { 'common/security/crl' }; # existe pas
#cd+
include { 'features/fetch-crl/config' };


# Authorization via grid mapfile. 
include { 'common/mkgridmap/standard' };

# Configure resource BDII.
include { 'glite/bdii/service' };


# Configure classads library
include { 'common/classads/config' };

# GridFTP is needed for experiments to publish
# their run time tags. 
#cd include { 'common/globus/base' };
#cd include { 'common/globus/sysconfig' };

# Configure R-GMA.
#cd include { 'common/java/config' };

# Configure WMS environment variables and clients
include { 'common/wms/client' };

# Configuration for LCMAPS.
include { 'common/lcmaps/base' };

# Configuration for LCAS.
include { 'common/lcas/base' };

# Configure FTS client.
include { 'common/fts/client/config' };

# Configure gsissh client and server
include { 'common/gsissh/client/config' };
include { 'common/gsissh/server/config' };

# Configure MPI.
include { 'common/mpi/config' };

# Configure LRMS
variable LRMS_CLIENT_INCLUDE = {
  if ( exists(CE_BATCH_NAME) && is_defined(CE_BATCH_NAME) ) {
    "common/"+CE_BATCH_NAME+"/client/client-only";
  } else {
    null;
  };
};
include { LRMS_CLIENT_INCLUDE };

# Configure VOBOX specific services
include { 'glite/vobox/config' };
