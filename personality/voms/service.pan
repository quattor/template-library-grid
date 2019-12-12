unique template personality/voms/service;

variable VOMS_CONFIG_SITE ?= null;
variable NODE_USE_RESOURCE_BDII = true;

# Database server used by VOMS (default: local node)
variable VOMS_DB_SERVER ?= FULL_HOSTNAME;

# Include VOMS rpms.
'/software/packages' = pkg_repl('emi-voms-mysql');

# Add site specific configuration (mandatory)
variable VOMS_CONFIG_SITE ?= error("VOMS_CONFIG_SITE must be defined (VOMS server configuration)");
include VOMS_CONFIG_SITE;

# Add glite user
include 'users/glite';

# Modify the loadable library path.
include 'features/ldconf/config';

# Include standard environmental variables.
include 'features/grid/env';
include 'features/globus/env';

# Ensure that the host certificates have the correct permissions.
include 'features/security/host_certs';

# Configure basic permissions for gLite
include 'features/grid/dirperms';

# Add accepted CAs certificates
include 'security/cas';

# Update the certificate revocation lists.
include 'features/fetch-crl/config';

# Configure paths for java.
include 'features/java/config';

# General globus configuration.
include 'features/globus/base';

# Configure the information provider.
include 'features/gip/base';
include 'features/gip/voms';

# Include VOMS service base configuration
include 'personality/voms/config';
