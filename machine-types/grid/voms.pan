
template machine-types/grid/voms;

variable VOMS_CONFIG_SITE ?= null;

variable VOMS_DB_TYPE ?= "mysql";

# Force i386 architecture until x86_64 distribution is ready
variable PKG_ARCH_GLITE = 'x86_64';

#
# Virtual organization configuration options.
# Must be done before calling machine-types/grid/base
#
variable CONFIGURE_VOS = false;
variable NODE_VO_ACCOUNTS = false;
variable CREATE_HOME = false;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= false;
variable NODE_VO_CONFIG ?= "personality/voms/vos";

#
# Include base configuration of a gLite node
#
include { 'machine-types/grid/base' };


# Include VOMS service configuration.
include { 'personality/voms/service' };

#
# middleware updates
#
include { if_exists('update/config') };

# Do any final configuration needed for some reasons (e.g. : run gLite 3.0 on SL4)
# Should be done at the very end of machine configuration
#
include { if_exists(GLITE_OS_POSTCONFIG) };
