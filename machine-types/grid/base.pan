############################################################
#
# template machine-types/grid/base
#
# Define base configuration of any type of gLite node.
# Can be included several times.
#
# This template is included one. As it does VO initialization
# the VO list and parameters cannot be redefined if included twice.
#
# RESPONSIBLE: Michel Jouvin
#
############################################################

unique template machine-types/grid/base;

variable CONFIGURE_VOS ?= false;


# Include static information and derived global variables.
variable SITE_DB_TEMPLATE ?= if_exists('pro_site_databases');
variable SITE_DB_TEMPLATE ?= 'site/databases';
include { SITE_DB_TEMPLATE };
variable SITE_GLOBAL_VARIABLES ?= if_exists('site/global_variables');
variable SITE_GLOBAL_VARIABLES ?= if_exists('pro_site_global_variables');
variable SITE_GLOBAL_VARIABLES ?= error('site/global_variables not found');
include { SITE_GLOBAL_VARIABLES };      # Default value for net params

# When true, only the initial part of NFS configuration is done during base OS configuration.
variable OS_POSTPONE_NFS_CONFIG ?= false;


#
# define site functions
#
variable SITE_FUNCTIONS_TEMPLATE ?= if_exists('pro_site_functions');
variable SITE_FUNCTIONS_TEMPLATE ?= 'site/functions';
include { SITE_FUNCTIONS_TEMPLATE };

#
# profile_base for profile structure
#
include { 'quattor/profile_base' };

#
# NCM core components
#
include { 'components/spma/config' };
include { 'components/grub/config' };


#
# hardware
#
include { 'hardware/functions' };
"/hardware" = if ( exists(DB_MACHINE[escape(FULL_HOSTNAME)]) ) {
                  create(DB_MACHINE[escape(FULL_HOSTNAME)]);
              } else {
                  error(FULL_HOSTNAME + " : hardware not found in machine database");
              };
variable MACHINE_PARAMS_CONFIG ?= undef;
include { MACHINE_PARAMS_CONFIG };
"/hardware" = if ( exists(MACHINE_PARAMS) && is_nlist(MACHINE_PARAMS) ) {
                update_hw_params();
              } else {
                SELF;
              };


# Cluster specific configuration
variable CLUSTER_INFO_TEMPLATE ?= if_exists('pro_site_cluster_info');
variable CLUSTER_INFO_TEMPLATE ?= 'site/cluster_info';
include { CLUSTER_INFO_TEMPLATE };


# common site machine configuration
variable SITE_CONFIG_TEMPLATE ?= if_exists('pro_site_config');
variable SITE_CONFIG_TEMPLATE ?= 'site/config';
include { SITE_CONFIG_TEMPLATE };


# File system configuration.
# pro_site_system_filesystems is legacy name and is used if present.
# filesystem/config is new generic approach for configuring file systems : use if it is present. It requires
# a site configuration template passed in FILESYSTEM_LAYOUT_CONFIG_SITE (same name as previous template
# but not the same contents).
variable FILESYSTEM_CONFIG_SITE ?= if_exists("pro_site_system_filesystems");
variable FILESYSTEM_CONFIG_SITE ?= if_exists("filesystem/config");
variable FILESYSTEM_LAYOUT_CONFIG_SITE ?= "site/filesystems/glite";
variable FILESYSTEM_CONFIG_SITE ?= "site/filesystems/glite";


# Define some other defaults if not defined in site/cluster configuration
# pro_site_system_filesystems is legacy name.
variable GLITE_BASE_CONFIG_SITE ?= null;
variable GLITE_SITE_PARAMS ?= if_exists("pro_lcg2_config_site");
variable GLITE_SITE_PARAMS ?= "site/glite/config";


# Select OS version based on machine name
include { 'os/version' };


# Load gLite version information
include { 'defaults/grid/version' };


# variable indicating if namespaces must be used to access OS templates.
# Always true with gLite >= 3.1, defined for backward compatibility.
variable OS_TEMPLATE_NAMESPACE = true;


# Define OS related namespaces
variable OS_NS_CONFIG = 'config/';
variable OS_NS_OS = OS_NS_CONFIG + 'core/';
variable OS_NS_QUATTOR = OS_NS_CONFIG + 'quattor/';
variable OS_NS_RPMLIST = 'rpms/';
variable OS_NS_REPOSITORY = 'repository/';


#
# software packages
#
include { 'pan/functions' };

#
# Configure Bind resolver
#
variable SITE_NAMED_CONFIG_TEMPLATE ?= if_exists('pro_site_named_config');
variable SITE_NAMED_CONFIG_TEMPLATE ?= 'site/named';
include { SITE_NAMED_CONFIG_TEMPLATE };


#
# Kernel version and CPU architecture
#
include { 'os/kernel_version_arch' };


#
# Default middleware architecture
#
variable PKG_ARCH_GLITE ?= PKG_ARCH_DEFAULT;


#
# Include OS version dependent RPMs
#
include { if_exists(OS_NS_OS + "base") };


#
# Quattor client software
#
include { 'quattor/client/config' };



#
# Include site configuration for gLite software
#
include { return(GLITE_SITE_PARAMS) };

#
# Include default gLite parameters (prevent absent variable in site parameter)
#


include { 'defaults/grid/config' };


# Check if NFS server and/or client should be configured on the current system.
# This template defines variables NFS_xxx_ENABLED used by other templates. 
# Also include NFS-related packages
include { 'features/nfs/init' };
include { if ( NFS_CLIENT_ENABLED ) 'rpms/nfs-client' };


# Configure filesystem layout.
# Must be done after NFS initialisation as it may tweak some mount points.
include { return(FILESYSTEM_CONFIG_SITE) };


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
variable NODE_VO_ACCOUNTS ?= if ( NFS_SERVER_ENABLED ) {
                                  return(true);
                            } else {
                              if ( exists(NODE_VO_ACCOUNTS) ) {
                                return(SELF);
                              } else {
                                return(null);
                              };
                            };

include { if ( CONFIGURE_VOS ) {
            return ("vo/config");
          } else {
            return ("vo/init");
          };
        };


#
# Configure NFS if necessary
#
include { if ( NFS_SERVER_ENABLED && !OS_POSTPONE_NFS_CONFIG ) 'features/nfs/server/config' };
include { if ( NFS_CLIENT_ENABLED && !OS_POSTPONE_NFS_CONFIG ) 'features/nfs/client/config' };


#
# Add Lemon client if requested
#
variable LEMON_CONFIGURE_AGENT ?= false;
variable LEMON_AGENT_INCLUDE = if ( LEMON_CONFIGURE_AGENT ) {
                         return("monitoring/lemon/client/base/service");
                       } else {
                         return(null);
                       };
include { LEMON_AGENT_INCLUDE };


#
# Site Monitoring
#
variable MONITORING_CONFIG_SITE ?= 'site/monitoring/config';
include { if_exists(MONITORING_CONFIG_SITE) };


#
# AII component must be included after much of the other setup. 
#
include { OS_NS_QUATTOR + 'aii' };


# 
# Add local users if some configured
#
variable USER_CONFIG_INCLUDE = if ( exists(USER_CONFIG_SITE) && is_defined(USER_CONFIG_SITE) ) {
                                 return('users/config');
                               } else {
                                 return(null);
                               };
include { USER_CONFIG_INCLUDE };


#
# Add site specific configuration if any
#
include { return(GLITE_BASE_CONFIG_SITE) };


# GLITE_OS_POSTCONFIG defines a template that must be executed at the very end of 
# any gLite machine type.
# The template is called by machine-types templates.
variable GLITE_OS_POSTCONFIG ?= OS_NS_OS + 'postconfig';

# Default repository configuration template 
variable PKG_REPOSITORY_CONFIG ?= 'repository/config';

variable PAKITI_ENABLED ?= false;
include {
	if ( PAKITI_ENABLED ) {
		'features/pakiti/config';
	} else {
		null;
	};
};
