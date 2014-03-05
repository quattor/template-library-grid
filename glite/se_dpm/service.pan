unique template glite/se_dpm/service;

# SEDPM_CONFIG_SITE is the legacy name of the variable.
variable SEDPM_CONFIG_SITE ?= null;
variable DPM_CONFIG_SITE ?= SEDPM_CONFIG_SITE;


# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# EDG, LCG, and Globus sysconfig files and environment variables
include { 'common/globus/sysconfig' };
include { 'common/glite/env' };


# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };


# Authorization via grid mapfile. 
include { 'common/mkgridmap/standard' };
include { 'common/mkgridmap/lcgdm' };


# Configure DPM services.
# Must be done before doing specific configuration for the node type.
include { 'glite/se_dpm/config' };


# Add RPMs (needs variables defined by glite/se_dpm/config
include { 'glite/se_dpm/rpms/config' + RPMS_CONFIG_SUFFIX };


# Add http server for DPM 1.6.7 and later (gLite 3.1 update 9)
variable DPM_HTTPD_INCLUDE = if ( HTTPS_ENABLED ) {
                               OS_NS_CONFIG_EMI+'dpm-httpd' + RPMS_CONFIG_SUFFIX;
                             } else {
                               null;
                             };
include { DPM_HTTPD_INCLUDE };


# DPM node type specific configuration
variable SEDPM_MACHINE_CONFIG = if ( SEDPM_IS_HEAD_NODE ) {
                                  "glite/se_dpm/server/service";
                                } else {
                                  "glite/se_dpm/disk/service";
                                };
include { return(SEDPM_MACHINE_CONFIG) };

# Configure Xrootd services if needed
# Must be done AFTER the DPM configuration is complete
include { if ( XROOT_ENABLED ) 'glite/xrootd/service' };

