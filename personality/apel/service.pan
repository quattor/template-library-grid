
unique template personality/apel/service;

# Include MON RPMs
include { 'personality/apel/rpms/config' };

# BDII is used to publish information
#variable NODE_USE_RESOURCE_BDII = true;

# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# LCG and Globus sysconfig files. 
include { 'feature/globus/sysconfig' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Configure paths for java.
include { 'feature/java/config' };

# Configure mysql.
include { 'feature/mysql/server' };

# APEL accounting.
include { 'feature/accounting/apel/publisher_ActiveMQ' };

# Configure BDII or GRIS, whatever is appropriate
#include { 'glite/bdii/service' };

# Configure the information provider.
#include { 'feature/gip/base' };

# Configure MON-specific services
include { 'personality/apel/config' };

