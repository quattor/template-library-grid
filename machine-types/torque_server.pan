template machine-types/torque_server;

variable TORQUE_SERVER_CONFIG_SITE ?= undef;



# CREATE_HOME must be defined as undef
variable CREATE_HOME ?= undef;

# Only create VO accounts for SW managers, disable all other parts of VO configuration
# Used to update VO tags.
variable CONFIGURE_VOS ?= true;
variable NODE_VO_ACCOUNTS ?= true;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= true;
variable NODE_VO_WLCONFIG ?= false;
variable NODE_VO_VOMSCLIENT ?= true;
variable NODE_VO_INFO_DIR ?= true;
variable NODE_VO_PROFILE_ENV ?= false;
variable VO_GRIDMAPFILE_MAP_VOMS_ROLES ?= true;
#variable VO_VOMS_FQAN_FILTER = nlist('DEFAULT', 'SW manager');



# Virtual organization configuration options.
# Must be done before calling machine-types/base
# Home directories for pool accounts are created only if a shared filesystem
# is not used or if the NFS server for the filesystem is the current node.
#
#
# Include base configuration of a gLite node.
# This includes configure NFS service.
#
include { 'machine-types/base' };


# Configure Torque/MAUI server and associated services
include { 'glite/torque_server/service' };


#
# Configure NFS if necessary
#
include { if ( NFS_SERVER_ENABLED ) 'common/nfs/server/config' };
include { if ( NFS_CLIENT_ENABLED ) 'common/nfs/client/config' };



#
# Add site specific configuration, if any
include { return(TORQUE_SERVER_CONFIG_SITE) };

#
# gLite updates
#
include { 'update/config' };


# Do any final configuration needed for some reasons (e.g. : run gLite 3.0 on SL4)
# Should be done at the very end of machine configuration
#
include { return(GLITE_OS_POSTCONFIG) };

