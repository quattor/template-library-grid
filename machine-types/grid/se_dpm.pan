############################################################
#
# template machine-types/grid/se_dpm
#
# Configure any type of DPM service node
#
# RESPONSIBLE: Michel Jouvin
#
############################################################

template machine-types/grid/se_dpm;

variable SEDPM_SRM_SERVER ?= false;
variable SEDPM_DB_SERVER ?= SEDPM_SRM_SERVER;
variable SEDPM_DB_TYPE ?= "mysql";

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


# Include DPM server configuration
include { 'personality/se_dpm/service' };


#
# middleware updates
#
include { if_exists('update/config') };


# Do any final configuration needed for some reasons (e.g. : run gLite3 on SL4)
# Should be done at the very end of machine configuration
#
include { if_exists(GLITE_OS_POSTCONFIG) };
