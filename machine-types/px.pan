template machine-types/px;

variable PX_CONFIG_SITE ?= null;

# Base configuration
include { 'machine-types/base' };

# MyProxy configuration
include { 'glite/px/service' };

# Add site specific configuration, if any
include { PX_CONFIG_SITE };

# Updates
include { 'update/config' };

# Do final configuration
# Should be done at the very end of machine configuration
include { GLITE_OS_POSTCONFIG };
