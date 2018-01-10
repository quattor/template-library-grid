# This template does the actual cloning. This involves:
#  - Copying the reference profile into this node profile (nothing must
#    have been done before or this will be lost).
#  - Do the node specific configuration by mimicing some wn/base.tpl steps

template personality/wn/cloning/clone;

# The real magic... MUST BE DONE FIRST.
# Copy the reference profile into the current node profile and delete
# the things that are really node specific:
#    /aii
#    /system/hardware
#    /system/network
#    /system/filesystems
#    /system/blockdevices

"/"= {
  path = value(PROFILE_PREFIX+PROFILE_CLONING_REFERENCE_NODE+':/');
  path["system"]["hardware"] = null;
  path["system"]["aii"] = null;
  path["system"]["network"] = null;
  path["system"]["filesystems"] = null;
  path["system"]["blockdevices"] = null;
  path;
};


# Ensure appropriate defaults for some standard variables.
variable WN_CONFIG_SITE ?= null;
variable WN_CONFIG_NODE ?= null;
variable PROFILE_CLONING_CLONED_NODE_POSTCONFIG ?= null;

# VO configuration-related variables
variable CONFIGURE_VOS = true;
variable CREATE_HOME ?= undef;
variable NODE_VO_PROFILE_ENV = true;

#
# Variables refering to site-specific templates.
# Implement backward compatibility with legacy name: the new names are
# consistent with what is used in base.tpl.
#

variable SITE_DATABASES ?= 'site/databases';
variable SITE_DB_TEMPLATE ?= SITE_DATABASES;
variable GLOBAL_VARIABLES ?= 'site/global_variables';
variable SITE_GLOBAL_VARS_TEMPLATE ?= GLOBAL_VARIABLES;
variable SITE_FUNCTION ?= 'site/functions';
variable SITE_FUNCTIONS_TEMPLATE ?= SITE_FUNCTION;
variable CLUSTER_INFO_TEMPLATE ?= if_exists('pro_site_cluster_info');
variable CLUSTER_INFO_TEMPLATE ?= 'site/cluster_info';
variable SITE_CONFIG ?= 'site/config';
variable SITE_CONFIG_TEMPLATE ?= SITE_CONFIG;

variable FILESYSTEM_CONFIG_SITE ?= "filesystem/config";
variable FILESYSTEM_LAYOUT_CONFIG_SITE ?= "site/filesystems/glite";


# Include machine/IP databases and define site global variables.
include { SITE_DB_TEMPLATE };
include { SITE_GLOBAL_VARS_TEMPLATE };

# Define site-specific functions and SPMA-related functions.
include { 'pan/functions' };
include { SITE_FUNCTIONS_TEMPLATE };
include { 'components/spma/functions' };


# Load the profile schema
include { 'quattor/profile_base' };


# Include node-specific HW configuration
"/hardware" = if ( exists(DB_MACHINE[escape(FULL_HOSTNAME)]) ) {
                  create(DB_MACHINE[escape(FULL_HOSTNAME)]);
              } else {
                  error(FULL_HOSTNAME + " : hardware not found in machine database");
              };


# Cluster specific configuration
include { CLUSTER_INFO_TEMPLATE };

# Reapply the site base configuration
include { SITE_CONFIG_TEMPLATE };

# Load gLite version information
include { 'defaults/grid/version' };


# Define OS-dependent load path.
# Note that this has no effect on the OS version actually installed,
# inherited from reference node. This is only to define the appropriate
# loadpath for some templates include later.
include { 'os/version' };
include { 'os/kernel_version_arch' };

# Redo network configuration
include { 'site/config/network' };

# variable indicating if namespaces must be used to access OS templates.
# Always true with gLite >= 3.1, defined for backward compatibility.
variable OS_TEMPLATE_NAMESPACE = true;
variable OS_NS_CONFIG = 'config/';
variable OS_NS_OS = OS_NS_CONFIG + 'os/';
variable OS_NS_CONFIG_GLITE = OS_NS_CONFIG + GRID_MIDDLEWARE_NAME + '/' + GRID_MIDDLEWARE_VERSION + '/';
variable OS_NS_QUATTOR = OS_NS_CONFIG + 'quattor/';
variable OS_NS_RPMLIST = 'rpms/';
variable OS_NS_REPOSITORY = 'repository/';


# Configure filesystem layout
include { FILESYSTEM_CONFIG_SITE };


# Quattor client software
# just set the profile, everything else is already included from exact node
"/software/components/ccm/profile" = QUATTOR_PROFILE_URL+"/"+OBJECT+".xml";


# Check if NFS server and/or client should be configured on the current system.
# This template defines variables NFS_xxx_ENABLED used by other templates.
include { 'features/nfs/init' };


#
# Configure VOs if needed. Some options in VO configuration
# depend on NFS configuration (a NFS server requires VO accounts to be created).
# If there is no VO configuration required, load standard base information
# for VOs needed by some components
#
variable CONFIGURE_VOS = if ( NFS_SERVER_ENABLED ) {
                           return(true);
                         } else {
                           return(SELF);
                         };
variable NODE_VO_ACCOUNTS = if ( NFS_SERVER_ENABLED ) {
                                  return(true);
                            } else {
                              if ( exists(NODE_VO_ACCOUNTS) ) {
                                return(SELF);
                              } else {
                                return(null);
                              };
                            };


#
# Reconfigure NFS if necessary
#
include { if ( NFS_SERVER_ENABLED ) 'features/nfs/server/config' };
include { if ( NFS_CLIENT_ENABLED ) 'features/nfs/client/config' };


#
# AII component must be included after much of the other setup.
#
include { OS_NS_QUATTOR + 'aii' };


# Undefine PKG_REPOSITORY_CONFIG to avoid rebuilding repository
# information already present (cloned from reference node)
variable PKG_REPOSITORY_CONFIG = null;


# Add WN-specific configuration, if any
include { WN_CONFIG_NODE };


# Postconfig if defined
include { PROFILE_CLONING_CLONED_NODE_POSTCONFIG };

