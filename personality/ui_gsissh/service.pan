
template personality/ui_gsissh/service;

# Add base UI
include { 'personality/ui/service' };

# Add RPMs specific to GSISSH UI
#include { 'personality/ui_gsissh/rpms/config' };

# Configure Globus sysconfig variables
# TODO : check if EDG/LCG sysconfig really needed on a UI...
include { 'features/globus/sysconfig' };

# Ensure that the host certificates have the correct permissions.
include { 'features/security/host_certs' };

# Modify the loadable library path.
include { 'features/ldconf/config' };

# Authorization via grid mapfile.
include { 'features/mkgridmap/standard' };

# Configuration for LCMAPS.
include { 'features/lcmaps/base' };

# Configuration for LCAS.
include { 'features/lcas/base' };

#
# Include gsissh server
#
include { 'components/iptables/config' };
include { 'features/gsissh/server/config' };

# Do base configuration for gsissh
include { 'personality/ui_gsissh/config' };
