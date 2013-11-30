
unique template glite/lb/service;

variable CONDOR_VERSION ?= "6.8.4";
variable GLITE_VO_STYLE = true;
variable LCMAPS_FLAVOR = 'glite';


# Add site specific configuration, if any
variable LB_CONFIG_SITE ?= if ( exists(WMS_CONFIG_SITE) && is_defined(WMS_CONFIG_SITE) ) {
                             return(WMS_CONFIG_SITE);
                           } else {
                             return(null);
                           };
include { return(LB_CONFIG_SITE) };


# Include gLite LB rpms
include { 'glite/lb/rpms/config' };

# Add glite user
include { 'users/glite' };

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# gLite, and Globus sysconfig and environment variables. 
include { 'common/globus/sysconfig' };
include { 'common/globus/env' };
include { 'common/glite/sysconfig' };
include { 'common/glite/env' };

# globuscfg
include { 'common/globus/base' };


# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

variable NODE_USE_RESOURCE_BDII = true;
# Configure BDII
include { 'glite/bdii/service' };

# Configure basic permissions for gLite
include { 'common/glite/dirperms' };

# Authorization via grid mapfile. 
include { 'common/mkgridmap/standard' };

# Configure the information provider.
include { 'common/gip/base' };
include { 'common/gip/lb' };

# Configure R-GMA client.
include { 'common/java/config' };
#include { 'common/rgma/client' };

# Configuration for LCMAPS.
#include { 'common/security/lcmaps' };
include { 'common/lcmaps/base' };

# Configuration for LCAS.
#include { 'common/security/lcas' };
include { 'common/lcas/base' };

# Configure the FMON agent and gridice.
#include { 'common/gridice/base' };
#include { 'common/fmon/agent' };

# Configure WMS environment variables. 
include { 'common/wms/client' };

# Configure mysql.
include { 'common/mysql/server' };

# Add WMSLB server configuration
include { 'glite/lb/config' };

