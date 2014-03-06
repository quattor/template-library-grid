template machine-types/grid/argus;

variable ARGUS_CONFIG_SITE ?= null;

#
# Virtual organization configuration options.
# Must be done before calling machine-types/grid/base
#
variable CONFIGURE_VOS = true;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= true;

#
# Include base configuration of a gLite node
#
include { 'machine-types/grid/base' };

#
# ARGUS configuration
#
include { 'personality/argus/service' };

#
# Add site specific configuration, if any
include { return(ARGUS_CONFIG_SITE) };

#
# middleware updates
#
include { if_exists('update/config') };

# Do any final configuration needed for some reasons (e.g. : run gLite3 on SL4)
# Should be done at the very end of machine configuration
#
include { if_exists(GLITE_OS_POSTCONFIG) };
