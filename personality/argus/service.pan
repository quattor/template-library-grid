
unique template personality/argus/service;

# Include MON RPMs
include { 'personality/argus/rpms/config' };

# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# LCG and Globus sysconfig files. 
include { 'feature/globus/sysconfig' };
#include { 'feature/lcg/sysconfig' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Authorization via grid mapfile.
include { 'feature/mkgridmap/standard' };

# Configure java.
include { 'feature/java/config' };

# Configuration for LCMAPS.
include { 'feature/lcmaps/base' };

# Configure MON-specific services
include { 'personality/argus/config' };

