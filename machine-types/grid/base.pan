# Define base configuration of any type of gLite node.
# Can be included several times.
#
# This template is included one. As it does VO initialization
# the VO list and parameters cannot be redefined if included twice.

unique template machine-types/grid/base;

variable CONFIGURE_VOS ?= false;

# When true, only the initial part of NFS configuration is done during base OS configuration.
variable OS_POSTPONE_NFS_CONFIG ?= false;

# Do not configure filesystems and blockdevices during the OS  configuration
variable OS_POSTPONE_FILESYSTEM_CONFIG ?= true;

# File system configuration.
# filesystem/config is new generic approach for configuring file systems : use if it is present. It requires
# a site configuration template passed in FILESYSTEM_LAYOUT_CONFIG_SITE (same name as previous template
# but not the same contents).
variable FILESYSTEM_CONFIG_SITE ?= if_exists("filesystem/config");
variable FILESYSTEM_LAYOUT_CONFIG_SITE ?= "site/filesystems/glite";
variable FILESYSTEM_CONFIG_SITE ?= "site/filesystems/glite";


# Core initialisation of machine type
include 'machine-types/core-init';


# Load gLite version information
include 'defaults/grid/version';


# Inclure the standard core machine type
include 'machine-types/core';


# Default middleware architecture
#
variable PKG_ARCH_GLITE ?= PKG_ARCH_DEFAULT;


# Include site configuration for gLite software
# Must be done before loading the cluster information (part of the OS configuration)
variable GLITE_SITE_PARAMS ?= "site/glite/config";
variable DEBUG = debug('GLITE_SITE_PARAMS=%s', to_string(GLITE_SITE_PARAMS));
include GLITE_SITE_PARAMS;


# Include default gLite parameters (prevent absent variable in site parameter)
include 'defaults/grid/config';


# Check if NFS server and/or client should be configured on the current system.
# This template defines variables NFS_xxx_ENABLED used by other templates.
# Also include NFS-related packages
include 'features/nfs/init';
include if ( NFS_CLIENT_ENABLED ) 'rpms/nfs-client';


# Configure filesystem layout.
# Must be done after NFS initialisation as it may tweak some mount points.
include FILESYSTEM_CONFIG_SITE;


# Configure AII (must be done after the filesystem configuration)
include 'config/quattor/aii';


# Configure VOs if needed. Some options in VO configuration
# depend on NFS configuration (a NFS server requires VO accounts to be created).
# If there is no VO configuration required, load standard base information
# for VOs needed by some components
variable CONFIGURE_VOS = if ( NFS_SERVER_ENABLED ) {
    true;
} else {
    SELF;
};
variable NODE_VO_ACCOUNTS ?= if ( NFS_SERVER_ENABLED ) {
    true;
} else {
    if ( exists(NODE_VO_ACCOUNTS) ) {
        SELF;
    } else {
        null;
    };
};

include {
    if ( CONFIGURE_VOS ) {
        "vo/config";
    } else {
        "vo/init";
    };
};


# Configure NFS if necessary
include if ( NFS_SERVER_ENABLED && !OS_POSTPONE_NFS_CONFIG ) 'features/nfs/server/config';
include if ( NFS_CLIENT_ENABLED && !OS_POSTPONE_NFS_CONFIG ) 'features/nfs/client/config';


# Add Lemon client if requested
variable LEMON_CONFIGURE_AGENT ?= false;
variable LEMON_AGENT_INCLUDE = if ( LEMON_CONFIGURE_AGENT ) {
    "monitoring/lemon/client/base/service";
} else {
    null;
};
include LEMON_AGENT_INCLUDE;


# Site Monitoring
variable MONITORING_CONFIG_SITE ?= 'site/monitoring/config';
include if_exists(MONITORING_CONFIG_SITE);


# Add site specific configuration if any
variable GLITE_BASE_CONFIG_SITE ?= null;
variable DEBUG = debug('GLITE_BASE_CONFIG_SITE=%s', to_string(GLITE_BASE_CONFIG_SITE));
include GLITE_BASE_CONFIG_SITE;


# GLITE_OS_POSTCONFIG defines a template that must be executed at the very end of
# any gLite machine type.
# The template is called by machine-types templates.
variable GLITE_OS_POSTCONFIG ?= OS_NS_OS + 'postconfig';


# Default repository configuration template
variable PKG_REPOSITORY_CONFIG ?= 'repository/config';


# Configure Pakiti
variable PAKITI_ENABLED ?= false;
include if ( PAKITI_ENABLED) {
    'features/pakiti/config';
} else {
    null;
};
