
unique template glite/argus/service;

# Include MON RPMs
include { 'glite/argus/rpms/config' };

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# LCG and Globus sysconfig files. 
include { 'common/globus/sysconfig' };
#include { 'common/lcg/sysconfig' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Authorization via grid mapfile.
include { 'common/mkgridmap/standard' };

# Configure BDII or GRIS, whatever is appropriate
include { 'glite/bdii/service' };

# Configure the information provider.
include { 'common/gip/base' };
include { 'common/gip/argus' };

# Configure java.
include { 'common/java/config' };

# Configuration for LCMAPS.
include { 'common/lcmaps/base' };

# Configure MON-specific services
include { 'glite/argus/config' };

