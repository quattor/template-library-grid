
unique template personality/lfc/service;

variable LFC_SERVER_MYSQL ?= true;

# Add RPMs for LFC
include { 'personality/lfc/rpms/config' };


# Check if  MDS (before gLite 3.0 update 35) or BDII is used to publish DPM information into BDII
# Do it early as it may impact service configuration
variable NODE_USE_RESOURCE_BDII = true;

# Add LFC server configuration
include { 'personality/lfc/config' };

# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# EDG, LCG, and Globus sysconfig files. 
include { 'feature/globus/sysconfig' };


# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Authorization via grid mapfile. 
include { 'feature/mkgridmap/lcgdm' };

# Configure BDII or GRIS, whatever is appropriate
include { 'personality/bdii/service' };

# Configure the information provider.
include { 'feature/gip/base' };
include { 'feature/gip/lfc' };

# Configure MySQL server
include { 'feature/mysql/server' };
