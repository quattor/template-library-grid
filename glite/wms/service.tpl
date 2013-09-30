
unique template glite/wms/service;

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
include { 'glite/wms/rpms/config' };

# Condor is now installed in the standard path
variable CONDOR_INSTALL_PATH ?= "/usr"; 
variable CONDOR_CONFIG_FILE ?= "/etc/condor/condor_config";

# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# gLite and Globus sysconfig and environment variables.
include { 'common/glite/sysconfig' };
include { 'common/glite/env' };
include { 'common/globus/sysconfig' };
include { 'common/globus/env' };

# Configure glite user
include { 'users/glite' };

# Configure EDG users
include { 'users/edguser' };
include { 'users/edginfo' };


# Modify the loadable library path. 
include { 'common/ldconf/config' };

# LCMAPS : we need a different lcmaps config file for WMS and GridFTP...
include { 'common/lcmaps/wms' }; 

# Configuration for LCAS.
include { 'common/lcas/base' };

#*** 11
# Configure gridftp server
# Must be done after configuring GIP provider
#
# AND after lcmaps, because config is now the same (?).
# problem is that gridftp/service #includes lcmaps config before we have a chnace to change it.

include { 'common/gridftp/service' };


# LCG installation directory
# see : https://ggus.eu/tech/ticket_show.php?ticket=79626
'/software/components/profile/env/LCG_LOCATION' = '/opt/lcg';

variable NODE_USE_RESOURCE_BDII = true;
variable BDII_TYPE ?= "resource";

# Configure BDII 
include { 'glite/bdii/service' };

# Add MySQL server.
include { 'common/mysql/server' };

# Configure basic permissions for gLite
include { 'common/glite/dirperms' };

# Authorization via grid mapfile. 
include { 'common/mkgridmap/standard' };

# Configure the information provider.
include { 'common/gip/base' };
include { 'common/gip/wms' };

# Configure java
include { 'common/java/config' };

# Configure Condor
include { 'common/condor/config' };

# Configure WMS environment variables. 
include { 'common/wms/client' };

# Add WMS server configuration
include { 'glite/wms/config' };

