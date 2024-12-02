template machine-types/grid/apel;

variable APEL_CONFIG_SITE ?= null;

#
# Include base configuration of a gLite node
#
include { 'machine-types/grid/base' };


#
# APEL configuration
#
include { 'personality/apel/service' };


#
# Add site specific configuration, if any
include { return(APEL_CONFIG_SITE) };


# Do any final configuration needed for some reasons (e.g. : run gLite3 on SL4)
# Should be done at the very end of machine configuration
#
include { return(GLITE_OS_POSTCONFIG) };

