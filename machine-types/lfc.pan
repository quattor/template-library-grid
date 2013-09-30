############################################################
#
# template machine-types/lfc
#
# Defines configuration of a LFC server
#
# RESPONSIBLE: Michel Jouvin
#
############################################################

template machine-types/lfc;

variable LFC_CONFIG_SITE ?= null;
variable LFC_SERVER_MYSQL ?= true;
#
# Virtual organization configuration options.
# Must be done before calling machine-types/base
#
variable CONFIGURE_VOS = true;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= true;

#
# Include base configuration of a gLite node
#
include { 'machine-types/base' };


#
# Configure as a LFC server
#
include { 'glite/lfc/service' };


#
# gLite updates
#
include { 'update/config' };


# Do any final configuration needed for some reasons (e.g. : run gLite4 on SL4)
# Should be done at the very end of machine configuration
#
include { return(GLITE_OS_POSTCONFIG) };

