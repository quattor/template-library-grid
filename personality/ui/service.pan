
unique template personality/ui/service;

variable PKG_ARCH_GLITE ?= PKG_ARCH_DEFAULT;

# Add UI RPMs
include { 'personality/ui/rpms/config' };

# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# Include standard environmental variables.
include { 'feature/grid/env' };
include { 'feature/globus/env' };

# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# General globus configuration.
include { 'feature/globus/base' };
include { 'feature/globus/sysconfig' };

# Configure Java.
include { 'feature/java/config' };

# Configure classads library
#NOTE: this seems not to be there anymore
include { 'feature/classads/config' };

# Configure WMS environment variables and clients
include { 'feature/wms/client' };

include { 'components/symlink/config' };
#Force replace since the "glite-wms-ui-commands" puts a default version of this file
'/software/components/symlink/links'=push(
  nlist('name','/etc/glite_wmsui_cmd_var.conf',
        'replace', nlist('all','yes','link','yes'),
        'target','/etc/glite-wms/glite_wmsui_cmd_var.conf',)
);

# Configure FTS client.
include { 'feature/fts/client/config' };

# Configure gsisshclient.
include { 'feature/gsissh/client/config' };

# Configure MPI.
include { 'feature/mpi/config' };
