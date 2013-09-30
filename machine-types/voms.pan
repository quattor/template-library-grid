
template machine-types/voms;

variable VOMS_CONFIG_SITE ?= null;

variable VOMS_DB_TYPE ?= "mysql";

# Force i386 architecture until x86_64 distribution is ready
variable PKG_ARCH_GLITE = 'x86_64';

#
# Virtual organization configuration options.
# Must be done before calling machine-types/base
#
variable CONFIGURE_VOS = false;
variable NODE_VO_ACCOUNTS = false;
variable CREATE_HOME = false;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= false;
variable NODE_VO_CONFIG ?= "glite/voms/vos";

#
# Include base configuration of a gLite node
#
include { 'machine-types/base' };


# Include VOMS service configuration.
include { 'glite/voms/service' };

#
# gLite updates
#
include { 'update/config' };

# Do any final configuration needed for some reasons (e.g. : run gLite 3.0 on SL4)
# Should be done at the very end of machine configuration
#
include { return(GLITE_OS_POSTCONFIG) };

