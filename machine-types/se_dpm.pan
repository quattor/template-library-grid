############################################################
#
# template machine-types/se_dpm
#
# Configure any type of DPM service node
#
# RESPONSIBLE: Michel Jouvin
#
############################################################

template machine-types/se_dpm;

variable SEDPM_SRM_SERVER ?= false;
variable SEDPM_DB_SERVER ?= SEDPM_SRM_SERVER;
variable SEDPM_DB_TYPE ?= "mysql";

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


# Include DPM server configuration
include { 'glite/se_dpm/service' };


#
# gLite updates
#
include { 'update/config' };


# Do any final configuration needed for some reasons (e.g. : run gLite3 on SL4)
# Should be done at the very end of machine configuration
#
include { return(GLITE_OS_POSTCONFIG) };

