
unique template personality/voms/service;

variable VOMS_CONFIG_SITE ?= null;
variable NODE_USE_RESOURCE_BDII = true;

# Database server used by VOMS (default: local node)
variable VOMS_DB_SERVER ?= FULL_HOSTNAME;


# Include VOMS rpms.
include { 'personality/voms/rpms/config' };

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
include { 'feature/ldconf/config' };

# Include standard environmental variables.
include { 'feature/grid/env' };
include { 'feature/globus/env' };

# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Configure basic permissions for gLite
include { 'feature/grid/dirperms' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Configure paths for java.
include { 'feature/java/config' };

# General globus configuration.
include { 'feature/globus/base' };

# Configure the information provider.
include { 'feature/gip/base' };
include { 'feature/gip/voms' };

#
# Include VOMS service base configuration
#
include { 'personality/voms/config' };
