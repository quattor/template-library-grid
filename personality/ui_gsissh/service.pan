
template personality/ui_gsissh/service;

# Add base UI
include { 'personality/ui/service' };

# Add RPMs specific to GSISSH UI
include { 'personality/ui_gsissh/rpms/config' };

# Configure Globus sysconfig variables
# TODO : check if EDG/LCG sysconfig really needed on a UI...
include { 'feature/globus/sysconfig' };

# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Modify the loadable library path.
include { 'feature/ldconf/config' };

# Authorization via grid mapfile.
include { 'feature/mkgridmap/standard' };

# Configuration for LCMAPS.
include { 'feature/lcmaps/base' };

# Configuration for LCAS.
include { 'feature/lcas/base' };

#
# Include gsissh server
#
include { 'components/iptables/config' };
include { 'feature/gsissh/server/config' };

# Do base configuration for gsissh
include { 'personality/ui_gsissh/config' };
