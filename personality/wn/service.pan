# Template defining all the MW components required to run a WN

unique template personality/wn/service;

# This is a requirement at WLCG sites and they are the main users of Quattor...
# Sites not interested can define the variable to false
variable GLEXEC_WN_ENABLED ?= true;

include { 'components/filecopy/config' };


##############################################################################################

# Add some RPMs from the OS
include { 'rpms/scientific-libraries' };

# Configure WLCG-related libraries and packages
include { 'features/wlcg/config' };

#
# gLite WN configuration
#
include { 'personality/wn/rpms/config' };

variable LRMS_CLIENT_INCLUDE = {
  if ( exists(CE_BATCH_NAME) && is_defined(CE_BATCH_NAME) ) {
    if(CE_BATCH_NAME == 'condor'){
    	return("features/htcondor/client/service");
    };
    return("features/"+CE_BATCH_NAME+"/client/service");
  } else {
    return(null);
  };
};
include { LRMS_CLIENT_INCLUDE };

# Configure glexec if needed
include { if ( GLEXEC_WN_ENABLED ) "features/glexec/wn/service" };

# WN specific configuration
include { 'personality/wn/config' };

# Modify the loadable library path. 
include { 'features/ldconf/config' };

# Include standard environmental variables.
include { 'features/grid/env' };
include { 'features/globus/env' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# MPI-CH configuration.
include { 'features/mpi/config' };

# General globus configuration.
include { 'features/globus/base' };

# Configure R-GMA client.
include { 'features/java/config' };
#include { 'features/rgma/client' };

# Configure FTS client.
include { 'features/fts/client/config' };

# Configure gsisshclient.
include { 'features/gsissh/client/config' };

# Configure classads library
include { 'features/classads/config' };

# Configure MatLab if MATLAB_INSTALL_DIR is defined
variable MATLAB_CONFIG_INCLUDE = if ( is_defined(MATLAB_INSTALL_DIR) ) {
                                   'features/matlab/config';
                                 } else {
                                   undef;
                                 };
include { MATLAB_CONFIG_INCLUDE };

# Configure CUDA if CUDA_INSTALL_DIR is defined
variable CUDA_CONFIG_INCLUDE = if ( is_defined(CUDA_INSTALL_DIR) ) {
                                   'features/cuda/config';
                                 } else {
                                   undef;
                                 };
include { CUDA_CONFIG_INCLUDE };
