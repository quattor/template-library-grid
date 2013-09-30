# Template defining all the MW components required to run a WN

unique template glite/wn/service;

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
include { 'glite/wn/rpms/config' };

variable LRMS_CLIENT_INCLUDE = {
  if ( exists(CE_BATCH_NAME) && is_defined(CE_BATCH_NAME) ) {
    return("common/"+CE_BATCH_NAME+"/client/service");
  } else {
    return(null);
  };
};
include { LRMS_CLIENT_INCLUDE };

variable GLEXEC_WN_INCLUDE = {
  if ( exists(GLEXEC_WN_ENABLED) && GLEXEC_WN_ENABLED ) {
    "common/glexec/wn/service";
  } else {
    null;
  };
};
include { GLEXEC_WN_INCLUDE };

# WN specific configuration
include { 'glite/wn/config' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# Include standard environmental variables.
include { 'common/glite/env' };
include { 'common/globus/env' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# MPI-CH configuration.
include { 'common/mpi/config' };

# General globus configuration.
include { 'common/globus/base' };

# Configure R-GMA client.
include { 'common/java/config' };
#include { 'common/rgma/client' };

# Configure FTS client.
include { 'common/fts/client/config' };

# Configure gsisshclient.
include { 'common/gsissh/client/config' };

# Configure classads library
include { 'common/classads/config' };

# Configure MatLab if MATLAB_INSTALL_DIR is defined
variable MATLAB_CONFIG_INCLUDE = if ( is_defined(MATLAB_INSTALL_DIR) ) {
                                   'common/matlab/config';
                                 } else {
                                   undef;
                                 };
include { MATLAB_CONFIG_INCLUDE };

# Configure CUDA if CUDA_INSTALL_DIR is defined
variable CUDA_CONFIG_INCLUDE = if ( is_defined(CUDA_INSTALL_DIR) ) {
                                   'common/cuda/config';
                                 } else {
                                   undef;
                                 };
include { CUDA_CONFIG_INCLUDE };


