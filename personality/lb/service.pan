
unique template personality/lb/service;

variable CONDOR_VERSION ?= "6.8.4";
variable GLITE_VO_STYLE = true;
variable LCMAPS_FLAVOR = 'glite';
variable WMS_FLAVOR = 'glite';


# Add site specific configuration, if any
variable LB_CONFIG_SITE ?= if ( exists(WMS_CONFIG_SITE) && is_defined(WMS_CONFIG_SITE) ) {
                             return(WMS_CONFIG_SITE);
                           } else {
                             return(null);
                           };
include { return(LB_CONFIG_SITE) };


# Include gLite LB rpms
include { 'personality/lb/rpms/config' };

# Add glite user
include { 'users/glite' };

# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# gLite, and Globus sysconfig and environment variables. 
include { 'feature/globus/sysconfig' };
include { 'feature/globus/env' };
include { 'feature/grid/sysconfig' };
include { 'feature/grid/env' };

# globuscfg
include { 'feature/globus/base' };


# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

variable NODE_USE_RESOURCE_BDII = true;
# Configure BDII
include { 'personality/bdii/service' };

# Configure basic permissions for gLite
include { 'feature/grid/dirperms' };

# Authorization via grid mapfile. 
include { 'feature/mkgridmap/standard' };

# Configure the information provider.
include { 'feature/gip/base' };
include { 'feature/gip/lb' };

# Configure R-GMA client.
include { 'feature/java/config' };
#include { 'feature/rgma/client' };

# Configuration for LCMAPS.
#include { 'feature/security/lcmaps' };
include { 'feature/lcmaps/base' };

# Configuration for LCAS.
#include { 'feature/security/lcas' };
include { 'feature/lcas/base' };

# Configure the FMON agent and gridice.
#include { 'feature/gridice/base' };
#include { 'feature/fmon/agent' };

# Configure WMS environment variables. 
include { 'feature/wms/client' };

# Configure mysql.
include { 'feature/mysql/server' };

# Add WMSLB server configuration
include { 'personality/lb/config' };

