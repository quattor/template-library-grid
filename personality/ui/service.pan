
unique template personality/ui/service;

variable PKG_ARCH_GLITE ?= PKG_ARCH_DEFAULT;

# Add some RPMs from the OS
include 'rpms/scientific-libraries';

# Configure WLCG-related libraries and packages
include 'features/wlcg/config';

# Add UI RPMs
include 'personality/ui/rpms/config' };

# Modify the loadable library path.
include 'features/ldconf/config';

# Include standard environmental variables.
include 'features/grid/env';
include 'features/globus/env';

# Add accepted CAs certificates
include 'security/cas';

# Update the certificate revocation lists.
include 'features/fetch-crl/config';

# General globus configuration.
include 'features/globus/base';
include 'features/globus/sysconfig';

# Configure Java.
include 'features/java/config';

# Configure classads library
#NOTE: this seems not to be there anymore
include 'features/classads/config';

# Configure FTS client.
include 'features/fts/client/config';

# Configure gsisshclient.
include 'features/gsissh/client/config';

# Configure MPI.
include 'features/mpi/config';

# UI specific tasks
include 'personality/ui/config';

