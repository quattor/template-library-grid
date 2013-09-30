############################################################
#
# object template pro_bdii_top
#
# RESPONSIBLE: Michel Jouvin
#
############################################################

template machine-types/bdii;

variable BDII_CONFIG_SITE ?= null;

#
# Include base configuration of a gLite node
#
include { 'machine-types/base' };


# Include the BDII RPMs and service configuration.
include { 'glite/bdii/service' };


#
# Add site specific configuration, if any
include { return(BDII_CONFIG_SITE) };


#
# gLite updates
#
include { 'update/config' };


# Do any final configuration needed for some reasons (e.g. : run gLite 3.0 on SL4)
# Should be done at the very end of machine configuration
#
include { return(GLITE_OS_POSTCONFIG) };

