
unique template personality/argus/service;

# Include BDII
# BDII user must be root
variable BDII_USER ?= 'root';
include { 'personality/bdii/service' };
include { 'features/gip/base'};
include { 'features/gip/argus'};

# Include MON RPMs
include { 'personality/argus/rpms/config' };

# Ensure that the host certificates have the correct permissions.
include { 'features/security/host_certs' };

# Modify the loadable library path.
include { 'features/ldconf/config' };

# LCG and Globus sysconfig files.
include { 'features/globus/sysconfig' };
#include { 'features/lcg/sysconfig' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Authorization via grid mapfile.
include { 'features/mkgridmap/standard' };

# Configure java.
include { 'features/java/config' };

# Configuration for LCMAPS.
include { 'features/lcmaps/base' };

# Configure MON-specific services
include { 'personality/argus/config' };

