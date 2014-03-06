
unique template personality/wms/service;

variable EMI_USER ?= "glite";
variable EMI_GROUP ?= "glite";

variable EMI_VO_STYLE = true;
variable LCMAPS_FLAVOR = 'glite';
variable WMS_FLAVOR = 'glite';

# Use Google TCMalloc instead of standard Malloc in WM.
# Default is true as with standard malloc WM easily reach the 4 GB VSZ limit.
variable WMS_WM_USE_TCMALLOC ?= true;

variable MKGRIDMAP_CONFDIR ?= EMI_LOCATION_ETC;
variable MKGRIDMAP_LCMAPS_DIR = MKGRIDMAP_CONFDIR + '/lcmaps/';

# Add site specific configuration, if any
variable WMS_CONFIG_SITE ?= null;
include { return(WMS_CONFIG_SITE) };


# Include gLite WMS rpms
include { 'personality/wms/rpms/config' };

# Condor is now installed in the standard path
variable CONDOR_INSTALL_PATH ?= "/usr"; 
variable CONDOR_CONFIG_FILE ?= "/etc/condor/condor_config";

# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# gLite and Globus sysconfig and environment variables.
include { 'feature/grid/sysconfig' };
include { 'feature/grid/env' };
include { 'feature/globus/sysconfig' };
include { 'feature/globus/env' };

# Configure glite user
include { 'users/glite' };

# Configure EDG users
include { 'users/edguser' };
include { 'users/edginfo' };


# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# LCMAPS : we need a different lcmaps config file for WMS and GridFTP...
include { 'feature/lcmaps/wms' }; 

# Configuration for LCAS.
include { 'feature/lcas/base' };

#*** 11
# Configure gridftp server
# Must be done after configuring GIP provider
#
# AND after lcmaps, because config is now the same (?).
# problem is that gridftp/service #includes lcmaps config before we have a chnace to change it.

include { 'feature/gridftp/service' };


# LCG installation directory
# see : https://ggus.eu/tech/ticket_show.php?ticket=79626
'/software/components/profile/env/LCG_LOCATION' = '/opt/lcg';

variable NODE_USE_RESOURCE_BDII = true;
variable BDII_TYPE ?= "resource";

# Configure BDII 
include { 'personality/bdii/service' };

# Add MySQL server.
include { 'feature/mysql/server' };

# Configure basic permissions for gLite
include { 'feature/grid/dirperms' };

# Authorization via grid mapfile. 
include { 'feature/mkgridmap/standard' };

# Configure the information provider.
include { 'feature/gip/base' };
include { 'feature/gip/wms' };

# Configure java
include { 'feature/java/config' };

# Configure Condor
include { 'feature/condor/config' };

# Configure WMS environment variables. 
include { 'feature/wms/client' };

# Add WMS server configuration
include { 'personality/wms/config' };

