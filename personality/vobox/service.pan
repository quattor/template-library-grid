# Reference configuration information for WLCG VOBOX can be found at
# https://twiki.cern.ch/twiki/bin/view/LCG/WLCGvoboxDeployment

unique template personality/vobox/service;

# Include RPMs for VOBOX
include { 'personality/vobox/rpms/config' };

# Ensure that the host certificates have the correct permissions.
include { 'features/security/host_certs' };

# Modify the loadable library path. 
include { 'features/ldconf/config' };

# Include standard environmental variables.
include { 'features/grid/env' };
include { 'features/globus/env' };

# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };


# Authorization via grid mapfile. 
include { 'features/mkgridmap/standard' };

# Configure classads library
include { 'features/classads/config' };

# Configure WMS environment variables and clients
include { 'features/wms/client' };

# Configuration for LCMAPS.
include { 'features/lcmaps/base' };

# Configuration for LCAS.
include { 'features/lcas/base' };

# Configure FTS client.
include { 'features/fts/client/config' };

# Configure gsissh client and server
include { 'features/gsissh/client/config' };
include { 'features/gsissh/server/config' };

# Configure MPI.
include { 'features/mpi/config' };

# Configure LRMS
variable LRMS_CLIENT_INCLUDE = {
  if ( exists(CE_BATCH_NAME) && is_defined(CE_BATCH_NAME) ) {
    format('features/%s/client/client-only',CE_BATCH_NAME);
  } else {
    null;
  };
};
include { LRMS_CLIENT_INCLUDE };

# Configure VOBOX specific services
include { 'personality/vobox/config' };
