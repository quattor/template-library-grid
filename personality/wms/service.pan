
unique template personality/wms/service;

variable EMI_USER ?= "glite";
variable EMI_GROUP ?= "glite";

variable EMI_VO_STYLE = true;
variable LCMAPS_FLAVOR = 'glite';

# Use Google TCMalloc instead of standard Malloc in WM.
# Default is true as with standard malloc WM easily reach the 4 GB VSZ limit.
variable WMS_WM_USE_TCMALLOC ?= true;

variable MKGRIDMAP_CONFDIR ?= EMI_LOCATION_ETC;
variable MKGRIDMAP_LCMAPS_DIR = MKGRIDMAP_CONFDIR + '/lcmaps/';

# Add site specific configuration, if any
variable WMS_CONFIG_SITE ?= null;
include WMS_CONFIG_SITE;


# Include WMS rpms
include 'personality/wms/rpms/config';

# Add accepted CAs
include 'security/cas';

# Update the certificate revocation lists.
include 'features/fetch-crl/config';

# Ensure that the host certificates have the correct permissions.
include 'features/security/host_certs';

# gLite and Globus sysconfig and environment variables.
include 'features/grid/sysconfig';
include 'features/grid/env';
include 'features/globus/sysconfig';
include 'features/globus/env';

# Configure glite user
include 'users/glite';

# Configure EDG users
include 'users/edguser';
include 'users/edginfo';


# Modify the loadable library path.
include 'features/ldconf/config';

# LCMAPS : we need a different lcmaps config file for WMS and GridFTP...
include 'features/lcmaps/wms';

# Configuration for LCAS.
include 'features/lcas/base';

#*** 11
# Configure gridftp server
# Must be done after configuring GIP provider
#
# AND after lcmaps, because config is now the same (?).
# problem is that gridftp/service #includes lcmaps config before we have a chnace to change it.

include 'features/gridftp/service';


# LCG installation directory
# see : https://ggus.eu/tech/ticket_show.php?ticket=79626
'/software/components/profile/env/LCG_LOCATION' = '/opt/lcg';

variable NODE_USE_RESOURCE_BDII = true;
variable BDII_TYPE ?= "resource";

# Configure BDII
include 'personality/bdii/service';

# Add MySQL server.
include 'features/mysql/server';

# Configure basic permissions for gLite
include 'features/grid/dirperms';

# Authorization via grid mapfile.
include 'features/mkgridmap/standard';

# Configure the information provider.
include 'features/gip/base';
include 'features/gip/wms';

# Configure java
include 'features/java/config';

# Configure Condor
include 'features/condor/config';

# Configure WMS environment variables.
include 'features/wms/client';

# Add WMS server configuration
include 'personality/wms/config';

