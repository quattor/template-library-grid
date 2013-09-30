
unique template glite/ui/service;

variable PKG_ARCH_GLITE ?= PKG_ARCH_DEFAULT;

# Add UI RPMs
include { 'glite/ui/rpms/config' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# Include standard environmental variables.
include { 'common/glite/env' };
include { 'common/globus/env' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# General globus configuration.
include { 'common/globus/base' };
include { 'common/globus/sysconfig' };

# Configure Java.
include { 'common/java/config' };

# Configure classads library
#NOTE: this seems not to be there anymore
include { 'common/classads/config' };

# Configure WMS environment variables and clients
include { 'common/wms/client' };

include { 'components/symlink/config' };
'/software/components/symlink/links'=push(
  nlist('name','/etc/glite_wmsui_cmd_var.conf',
        'replace', nlist('all','no','link','yes'),
        'target','/etc/glite-wms/glite_wmsui_cmd_var.conf',)
);

# Configure FTS client.
include { 'common/fts/client/config' };

# Configure gsisshclient.
include { 'common/gsissh/client/config' };

# Configure MPI.
include { 'common/mpi/config' };

