###########################################################
#
# object template machine-types/nfs
#
# Defines a NFS server
#
# RESPONSIBLE: Michel Jouvin
#
############################################################

template machine-types/nfs;

# CREATE_HOME must be defined as undef
variable CREATE_HOME ?= undef;

# Only create VO accounts, disable all other parts of VO configuration
variable NODE_VO_ACCOUNTS ?= true;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= false;
variable NODE_VO_WLCONFIG ?= false;
variable NODE_VO_VOMSCLIENT ?= false;
variable NODE_VO_INFO_DIR ?= false;
variable NODE_VO_PROFILE_ENV ?= false;


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


#
# gLite updates
#
include { 'update/config' };


# Do any final configuration needed for some reasons (e.g. : run gLite 3.0 on SL4)
# Should be done at the very end of machine configuration
#
include { return(GLITE_OS_POSTCONFIG) };

