template machine-types/grid/px;

variable PX_CONFIG_SITE ?= null;

# Base configuration
include { 'machine-types/grid/base' };

# MyProxy configuration
include { 'personality/px/service' };

# Add site specific configuration, if any
include { PX_CONFIG_SITE };

# middleware updates
include { if_exists('update/config') };

# Do final configuration
# Should be done at the very end of machine configuration
include { if_exists(GLITE_OS_POSTCONFIG) };
