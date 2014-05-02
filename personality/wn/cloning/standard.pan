# Equivalent of the machine-types/xxx.tpl for other machine types.
# Used when the node is not cloned from a reference node.

template personality/wn/cloning/standard;

variable WN_CONFIG_SITE ?= null;
variable WN_CONFIG_NODE ?= null;

# Use i386 architecture by default if not explicitly defined for backward compatibility
variable PKG_ARCH_GLITE ?= 'x86_64';

# Do actual NFS configuration after gLite configuration instead of during the OS
variable OS_POSTPONE_NFS_CONFIG ?= true;

# Variable to define a template included after standard gLite updates.
# This can be used for configuration specific to this machine type.
# Template must reside in update/nn directory, where nn is the current update.
# If the template doesn't exist in current update, it is ignored.
variable GLITE_UPDATE_POSTCONFIG ?= 'wn';

#
# Virtual organization configuration options.
# Must be done before calling machine-types/grid/base
# Home directories for pool accounts are created only if a shared filesystem
# is not used or if the NFS server for the filesystem is the current node.
#
variable CONFIGURE_VOS = true;
variable CREATE_HOME ?= undef;
variable NODE_VO_PROFILE_ENV = true;

#
# Configure NFS-served file systems in WN_SHARED_AREAS, if any
#
variable NFS_CLIENT_ENABLED ?= undef;

#
# Include base configuration of a gLite node
#
include { 'machine-types/grid/base' };


# Include WN components
include { 'personality/wn/service' };

#
# Add site specific configuration, if any
include { return(WN_CONFIG_SITE) };

# Add node-specific configuration, if any
include { WN_CONFIG_NODE };

#
# Configure NFS if necessary
#
include { if ( NFS_SERVER_ENABLED ) 'features/nfs/server/config' };
include { if ( NFS_CLIENT_ENABLED ) 'features/nfs/client/config' };

#
# middleware updates
#
include { if_exists('update/config') };

#
#lemon monitoring specific for WNs
#
variable LEMON_AGENT_NODE_SPECIFIC = if ( LEMON_CONFIGURE_AGENT ) {
                         return("monitoring/lemon/client/wn/config");
                       } else {
                         return(null);
                       };
include { LEMON_AGENT_NODE_SPECIFIC };


# Do any final configuration needed for some reasons (e.g. : run gLite3.0 on SL4)
# Should be done at the very end of machine configuration
#
include { if_exists(GLITE_OS_POSTCONFIG) };
