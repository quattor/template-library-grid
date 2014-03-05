unique template glite/xrootd/service;

variable XROOTD_CONFIG_SITE ?= null;

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# Globus sysconfig files and environment variables
include { 'common/globus/sysconfig' };


# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };


# Authorization via grid mapfile. 
include { 'common/mkgridmap/standard' };


# Configure Xrootd services.
# Must be done before doing specific configuration for the node type.
include { 'glite/xrootd/config' };


# Add RPMs (needs variables defined by glite/xrootd/config
include { 'glite/xrootd/rpms/config' + RPMS_CONFIG_SUFFIX };


