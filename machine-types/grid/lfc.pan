############################################################
#
# template machine-types/grid/lfc
#
# Defines configuration of a LFC server
#
# RESPONSIBLE: Michel Jouvin
#
############################################################

template machine-types/grid/lfc;

variable LFC_CONFIG_SITE ?= null;
variable LFC_SERVER_MYSQL ?= true;
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
# Configure as a LFC server
#
include { 'personality/lfc/service' };


#
# middleware updates
#
include { if_exists('update/config') };


# Do any final configuration needed for some reasons (e.g. : run gLite4 on SL4)
# Should be done at the very end of machine configuration
#
include { if_exists(GLITE_OS_POSTCONFIG) };
