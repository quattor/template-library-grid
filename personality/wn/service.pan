# Template defining all the MW components required to run a WN

unique template personality/wn/service;

include { 'components/filecopy/config' };

# TO_BE_FIXED: workaround by Fred for globuscfg component failure in EMI (some features are now useless)
variable GLOBUSCFG_FIX = "#!/bin/bash\n";
variable GLOBUSCFG_FIX = GLOBUSCFG_FIX + "mkdir -p ${GLOBUS_LOCATION:=/usr}/setup/globus\n";
variable GLOBUSCFG_FIX = GLOBUSCFG_FIX + "for i in setup-tmpdirs setup-globus-common; do\n";
variable GLOBUSCFG_FIX = GLOBUSCFG_FIX + "exe=${GLOBUS_LOCATION}/setup/globus/$i\n";
variable GLOBUSCFG_FIX = GLOBUSCFG_FIX + "if [ ! -f $exe ]; then\n";
variable GLOBUSCFG_FIX = GLOBUSCFG_FIX + "echo '#!/bin/bash' > $exe\n";
variable GLOBUSCFG_FIX = GLOBUSCFG_FIX + "echo 'exit 0' >> $exe\n";
variable GLOBUSCFG_FIX = GLOBUSCFG_FIX + "chmod 755 $exe\n";
variable GLOBUSCFG_FIX = GLOBUSCFG_FIX + "fi\n";
variable GLOBUSCFG_FIX = GLOBUSCFG_FIX + "done\n";


variable GLOBUSCFG_FIX_EXE ?= "/usr/sbin/globuscfg_fix";
"/software/components/filecopy/services" =
  npush(escape(GLOBUSCFG_FIX_EXE),
        nlist("config",GLOBUSCFG_FIX,
              "owner","root",
              "perms","0755",
              "restart", GLOBUSCFG_FIX_EXE,
        )
  );

#TO_BE_FIXED:END



##############################################################################################

#
# gLite WN configuration
#
include { 'personality/wn/rpms/config' };

variable LRMS_CLIENT_INCLUDE = {
  if ( exists(CE_BATCH_NAME) && is_defined(CE_BATCH_NAME) ) {
    return("feature/"+CE_BATCH_NAME+"/client/service");
  } else {
    return(null);
  };
};
include { LRMS_CLIENT_INCLUDE };

variable GLEXEC_WN_INCLUDE = {
  if ( exists(GLEXEC_WN_ENABLED) && GLEXEC_WN_ENABLED ) {
    "feature/glexec/wn/service";
  } else {
    null;
  };
};
include { GLEXEC_WN_INCLUDE };

# WN specific configuration
include { 'personality/wn/config' };

# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# Include standard environmental variables.
include { 'feature/grid/env' };
include { 'feature/globus/env' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# MPI-CH configuration.
include { 'feature/mpi/config' };

# General globus configuration.
include { 'feature/globus/base' };

# Configure R-GMA client.
include { 'feature/java/config' };
#include { 'feature/rgma/client' };

# Configure FTS client.
include { 'feature/fts/client/config' };

# Configure gsisshclient.
include { 'feature/gsissh/client/config' };

# Configure classads library
include { 'feature/classads/config' };

# Configure MatLab if MATLAB_INSTALL_DIR is defined
variable MATLAB_CONFIG_INCLUDE = if ( is_defined(MATLAB_INSTALL_DIR) ) {
                                   'feature/matlab/config';
                                 } else {
                                   undef;
                                 };
include { MATLAB_CONFIG_INCLUDE };

# Configure CUDA if CUDA_INSTALL_DIR is defined
variable CUDA_CONFIG_INCLUDE = if ( is_defined(CUDA_INSTALL_DIR) ) {
                                   'feature/cuda/config';
                                 } else {
                                   undef;
                                 };
include { CUDA_CONFIG_INCLUDE };
