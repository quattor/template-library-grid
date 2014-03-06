# Template to configure a Torque/MAUI server to be used in the gLite context.
# This includes bdii/gip configuration required to publish cluster related information
# and a gsiftp server to handle software tag management.
#
# Note that conversely to most high-level services, there is no config.tpl or rpms.tpl for the Torque server
# as it relies on services configured as low-level services (in common/).

template personality/torque_server/service;


variable GIP_USER ?= 'ldap';

variable MAUI_GROUP_PARAMS ?= nlist(
  "DEFAULT",    "FSTARGET=1+",
);

variable BDII_TYPE ?= 'resource';
variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;


# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Do base configuration for GIP before configuring Torque/MAUI
include { 'feature/gip/base' };

# Set permissions on key directories, in particular log directory
include { 'feature/grid/dirperms' };


# When using MAUI, postpone configuration of maui-monitoring after GIP configuration.
variable MAUI_MONITORING_POSTPONED = true;
include { 'feature/torque2/server/service' };


# Configure GIP plugin for Torque/MAUI
include { 'feature/gip/ce' };


# Configure MAUI monitoring, also used to optionally implement a GIP plugin cache.
variable MAUI_MONITORING_TEMPLATE_INCLUDE = if ( is_defined(MAUI_MONITORING_TEMPLATE) ) {
                                               debug(OBJECT+': configuring MAUI monitoring');
                                               MAUI_MONITORING_TEMPLATE;
                                             } else {
                                               debug(OBJECT+': MAUI monitoring disabled');
                                               undef;
                                             };
include { MAUI_MONITORING_TEMPLATE_INCLUDE };


# Include a resource BDII
include { 'personality/bdii/service' };


# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# Globus sysconfig files. 
include { 'feature/globus/sysconfig' };
include { 'feature/edg/sysconfig' };
# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Authorization via grid mapfile. 
include { 'feature/mkgridmap/standard' };

# GridFTP is needed for experiments to publish
# their run time tags. 
include { 'feature/gridftp/service' };

# PBS accounting.
include { 'feature/accounting/apel/parser_pbs' };

