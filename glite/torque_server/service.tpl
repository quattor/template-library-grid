# Template to configure a Torque/MAUI server to be used in the gLite context.
# This includes bdii/gip configuration required to publish cluster related information
# and a gsiftp server to handle software tag management.
#
# Note that conversely to most high-level services, there is no config.tpl or rpms.tpl for the Torque server
# as it relies on services configured as low-level services (in common/).

template glite/torque_server/service;


variable GIP_USER ?= 'ldap';

variable MAUI_GROUP_PARAMS ?= nlist(
  "DEFAULT",    "FSTARGET=1+",
);

variable BDII_TYPE ?= 'resource';
variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;


# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Do base configuration for GIP before configuring Torque/MAUI
include { 'common/gip/base' };

# Set permissions on key directories, in particular log directory
include { 'common/glite/dirperms' };


# When using MAUI, postpone configuration of maui-monitoring after GIP configuration.
variable MAUI_MONITORING_POSTPONED = true;
include { 'common/torque2/server/service' };


# Configure GIP plugin for Torque/MAUI
include { 'common/gip/ce' };


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
include { 'glite/bdii/service' };


# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# Globus sysconfig files. 
include { 'common/globus/sysconfig' };
include { 'common/edg/sysconfig' };
# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Authorization via grid mapfile. 
include { 'common/mkgridmap/standard' };

# GridFTP is needed for experiments to publish
# their run time tags. 
include { 'common/gridftp/service' };

# PBS accounting.
variable APEL_PARSER_EMI3 ?= false;
variable APEL_PARSER_TEMPLATE ?= if (APEL_PARSER_EMI3) {
    'common/accounting/apel/emi-3_parser';
} else {
    'common/accounting/apel/parser_pbs';
};
include { APEL_PARSER_TEMPLATE };
