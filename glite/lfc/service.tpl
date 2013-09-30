
unique template glite/lfc/service;

variable LFC_SERVER_MYSQL ?= true;

# Add RPMs for LFC
include { 'glite/lfc/rpms/config' };


# Check if  MDS (before gLite 3.0 update 35) or BDII is used to publish DPM information into BDII
# Do it early as it may impact service configuration
variable NODE_USE_RESOURCE_BDII = true;

# Add LFC server configuration
include { 'glite/lfc/config' };

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# EDG, LCG, and Globus sysconfig files. 
include { 'common/globus/sysconfig' };


# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Authorization via grid mapfile. 
include { 'common/mkgridmap/lcgdm' };

# Configure BDII or GRIS, whatever is appropriate
include { 'glite/bdii/service' };

# Configure the information provider.
include { 'common/gip/base' };
include { 'common/gip/lfc' };

# Configure MySQL server
include { 'common/mysql/server' };
