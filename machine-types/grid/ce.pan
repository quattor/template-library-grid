############################################################
#
# object template machine-types/grid/cream_ce
#
# Defines a CREAM CE, with an optional LRMS
#
############################################################

template machine-types/grid/ce;

#TO_BE_FIXED: defined variables here... maybe not the best place
variable EMI_LOCATION ?= "";
variable EMI_LOCATION_LOG ?= "/var/log/emi";
variable EMI_LOCATION_VAR ?= "/var/emi";
variable EMI_LOCATION_TMP ?= "/var/spool/emi";



# If defined, use CE_TORQUE_CONFIG_SITE for backward compatibility
variable CE_CONFIG_SITE ?= if ( exists(CE_TORQUE_CONFIG_SITE) && is_defined(CE_TORQUE_CONFIG_SITE) ) {
                             return(CE_TORQUE_CONFIG_SITE);
                           } else {
                             return(null);
                           };


# Do actual NFS configuration after gLite configuration instead of during the OS
variable OS_POSTPONE_NFS_CONFIG ?= true;

# Virtual organization configuration options.
# Must be done before calling machine-types/grid/base
# Home directories for pool accounts are created only if a shared filesystem
# is not used or if the NFS server for the filesystem is the current node.
#
variable CONFIGURE_VOS = true;
variable CREATE_HOME ?= undef;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= true;
variable NODE_VO_INFO_DIR = true;


#
# Configure NFS-served file systems in WN_SHARED_AREAS, if any
#
variable NFS_CLIENT_ENABLED ?= undef;


# Include base configuration of a gLite node
#
include { 'machine-types/grid/base' };


#
# CREAM CE configuration
# If CE uses Torque, do Torque configuration too
#
include { 'personality/cream_ce/service' };


# Add local customization to standard configuration, if any
include { return(CE_CONFIG_SITE) };


#
# Configure NFS if necessary
#
include { if ( NFS_SERVER_ENABLED ) 'features/nfs/server/config' };
include { if ( NFS_CLIENT_ENABLED ) 'features/nfs/client/config' };


#
#lemon monitoring specific for CEs
#
variable LEMON_AGENT_NODE_SPECIFIC = if ( LEMON_CONFIGURE_AGENT ) {
                         return("monitoring/lemon/client/ce/config");
                       } else {
                         return(null);
                       };
include { LEMON_AGENT_NODE_SPECIFIC };

#
# middleware updates
#
include { if_exists('update/config') };

# Do any final configuration needed for some reasons (e.g. : run gLite 3.0 on SL4)
# Should be done at the very end of machine configuration
#
include { if_exists(GLITE_OS_POSTCONFIG) };
