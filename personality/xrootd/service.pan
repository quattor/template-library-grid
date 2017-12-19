unique template personality/xrootd/service;

variable XROOTD_CONFIG_SITE ?= null;

# Ensure that the host certificates have the correct permissions.
include { 'features/security/host_certs' };

# Modify the loadable library path. 
include { 'features/ldconf/config' };

# Globus sysconfig files and environment variables
include { 'features/globus/sysconfig' };


# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };


# Authorization via grid mapfile. 
include { 'features/mkgridmap/standard' };


# Configure Xrootd services.
# Must be done before doing specific configuration for the node type.
include { 'personality/xrootd/config' };


# Add RPMs (needs variables defined by grid/xrootd/config
include { 'personality/xrootd/rpms/config' };
