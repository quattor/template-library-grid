
template machine-types/emi/lb;

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
# Must be done before calling machine-types/base
#
variable CONFIGURE_VOS = true;
variable NODE_VO_ACCOUNTS =true;
variable CREATE_HOME = false;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= true;

#
# Include base configuration of a LCG2 node
#
include { 'machine-types/base' };


#
# Configure as a LB server
#
include { 'glite/lb/service' };


#
# gLite updates
#
include { 'update/config' };


# Do any final configuration needed for some reasons (e.g. : run gLite4 on SL4)
# Should be done at the very end of machine configuration
#
include { return(GLITE_OS_POSTCONFIG) };

