############################################################
#
# object template pro_bdii_top
#
# RESPONSIBLE: Michel Jouvin
#
############################################################

template machine-types/grid/bdii;

variable BDII_CONFIG_SITE ?= null;

#
# Include base configuration of a gLite node
#
include { 'machine-types/grid/base' };


# Include the BDII RPMs and service configuration.
include { 'personality/bdii/service' };


#
# Add site specific configuration, if any
include { return(BDII_CONFIG_SITE) };


#
# middleware updates
#
include { if_exists('update/config') };


# Do any final configuration needed for some reasons (e.g. : run gLite 3.0 on SL4)
# Should be done at the very end of machine configuration
#
include { if_exists(GLITE_OS_POSTCONFIG) };
