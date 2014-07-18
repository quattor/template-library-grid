
unique template personality/apel/service;

# Include MON RPMs
include { 'personality/apel/rpms/config' };

# BDII is used to publish information
#variable NODE_USE_RESOURCE_BDII = true;

# Ensure that the host certificates have the correct permissions.
include { 'features/security/host_certs' };

# Modify the loadable library path. 
include { 'features/ldconf/config' };

# LCG and Globus sysconfig files. 
include { 'features/globus/sysconfig' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Configure mysql.
include { 'features/mysql/server' };

# APEL accounting.
include { 'features/accounting/apel/client' };

# Configure BDII or GRIS, whatever is appropriate
#include { 'glite/bdii/service' };

# Configure the information provider.
#include { 'features/gip/base' };

# Configure MON-specific services
include { 'personality/apel/config' };

