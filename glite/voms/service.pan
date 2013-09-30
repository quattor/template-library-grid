
unique template glite/voms/service;

variable VOMS_CONFIG_SITE ?= null;
variable NODE_USE_RESOURCE_BDII = true;

# Database server used by VOMS (default: local node)
variable VOMS_DB_SERVER ?= FULL_HOSTNAME;


# Include VOMS rpms.
include { 'glite/voms/rpms/config' };

# Add site specific configuration (mandatory)
variable VOMS_CONFIG_SITE = if ( exists(VOMS_CONFIG_SITE) && is_defined(VOMS_CONFIG_SITE) ) {
                              SELF;
                            } else {
                              error("VOMS_CONFIG_SITE must be defined (VOMS server configuration)");
                            };
include { VOMS_CONFIG_SITE };


# Add glite user
include { 'users/glite' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# Include standard environmental variables.
include { 'common/glite/env' };
include { 'common/globus/env' };

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Configure basic permissions for gLite
include { 'common/glite/dirperms' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Configure paths for java.
include { 'common/java/config' };

# General globus configuration.
include { 'common/globus/base' };

# Configure the information provider.
include { 'common/gip/base' };
include { 'common/gip/voms' };

#
# Include VOMS service base configuration
#
include { 'glite/voms/config' };
