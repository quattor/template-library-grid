unique template personality/se_dpm/service;

# SEDPM_CONFIG_SITE is the legacy name of the variable.
variable SEDPM_CONFIG_SITE ?= null;
variable DPM_CONFIG_SITE ?= SEDPM_CONFIG_SITE;


# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# EDG, LCG, and Globus sysconfig files and environment variables
include { 'feature/globus/sysconfig' };
include { 'feature/grid/env' };


# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };


# Authorization via grid mapfile. 
include { 'feature/mkgridmap/standard' };
include { 'feature/mkgridmap/lcgdm' };


# Configure DPM services.
# Must be done before doing specific configuration for the node type.
include { 'personality/se_dpm/config' };


# Add RPMs (needs variables defined by glite/se_dpm/config
include { 'personality/se_dpm/rpms/config' };


# DPM node type specific configuration
variable SEDPM_MACHINE_CONFIG = {
    if ( SEDPM_IS_HEAD_NODE ) {
        "personality/se_dpm/server/service";
    } else {
        "personality/se_dpm/disk/service";
    };
};
include { SEDPM_MACHINE_CONFIG };

# Configure Xrootd services if needed
# Must be done AFTER the DPM configuration is complete
include { if ( XROOT_ENABLED ) 'personality/xrootd/service' };
