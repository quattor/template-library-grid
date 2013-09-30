
template glite/ui_gsissh/service;

# Add base UI
include { 'glite/ui/service' };

# Add RPMs specific to GSISSH UI
include { 'glite/ui_gsissh/rpms/config' };

# Configure Globus sysconfig variables
# TODO : check if EDG/LCG sysconfig really needed on a UI...
include { 'common/globus/sysconfig' };

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Modify the loadable library path.
include { 'common/ldconf/config' };

# Authorization via grid mapfile.
include { 'common/mkgridmap/standard' };

# Configuration for LCMAPS.
include { 'common/lcmaps/base' };

# Configuration for LCAS.
include { 'common/lcas/base' };

#
# Include gsissh server
#
include { 'components/iptables/config' };
include { 'common/gsissh/server/config' };

# Do base configuration for gsissh
include { 'glite/ui_gsissh/config' };
