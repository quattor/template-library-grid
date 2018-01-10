
template machine-types/grid/lb;

variable LB_CONFIG_SITE ?= null;

# Force i386 architecture until x86_64 distribution is ready
variable PKG_ARCH_GLITE = 'x86_64';

# Variable to define a template included after standard gLite updates.
# This can be used for configuration specific to this machine type.
# Template must reside in update/nn directory, where nn is the current update.
# If the template doesn't exist in current update, it is ignored.
variable GLITE_UPDATE_POSTCONFIG ?= 'wmslb';

#
# Virtual organization configuration options.
# Must be done before calling machine-types/grid/base
#
variable CONFIGURE_VOS = true;
variable NODE_VO_ACCOUNTS =true;
variable CREATE_HOME = false;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= true;

#
# Include base configuration of a grid node
#
include { 'machine-types/grid/base' };


#
# Configure as a LB server
#
include { 'personality/lb/service' };


#
# middleware updates
#
include { if_exists('update/config') };


# Do any final configuration needed for some reasons
# Should be done at the very end of machine configuration
#
include { if_exists(GLITE_OS_POSTCONFIG) };
