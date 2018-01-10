
unique template personality/lb/service;

variable CONDOR_VERSION ?= "6.8.4";
variable GLITE_VO_STYLE = true;
variable LCMAPS_FLAVOR = 'glite';


# Add site specific configuration, if any
variable WMS_CONFIG_SITE ?= null;
variable LB_CONFIG_SITE ?= WMS_CONFIG_SITE;
include LB_CONFIG_SITE;


# Include gLite LB rpms
include 'personality/lb/rpms/config';

# Add glite user
include 'users/glite';

# Ensure that the host certificates have the correct permissions.
include 'features/security/host_certs';

# Modify the loadable library path.
include 'features/ldconf/config';

# gLite, and Globus sysconfig and environment variables.
include 'features/globus/sysconfig';
include 'features/globus/env';
include 'features/grid/sysconfig';
include 'features/grid/env';

# globuscfg
include 'features/globus/base';


# Add accepted CAs
include 'security/cas';

# Update the certificate revocation lists.
include 'features/fetch-crl/config';

variable NODE_USE_RESOURCE_BDII = true;
# Configure BDII
include 'personality/bdii/service';

# Configure basic permissions for gLite
include 'features/grid/dirperms';

# Authorization via grid mapfile.
include 'features/mkgridmap/standard';

# Configure the information provider.
include 'features/gip/base';
include 'features/gip/lb';

# Configure R-GMA client.
include 'features/java/config';
#include 'features/rgma/client';

# Configuration for LCMAPS.
#include 'features/security/lcmaps';
include 'features/lcmaps/base';

# Configuration for LCAS.
#include 'features/security/lcas';
include 'features/lcas/base';

# Configure the FMON agent and gridice.
#include 'features/gridice/base';
#include 'features/fmon/agent';

# Configure WMS environment variables.
include 'features/wms/client';

# Configure mysql.
include 'features/mysql/server';

# Add WMSLB server configuration
include 'personality/lb/config';

